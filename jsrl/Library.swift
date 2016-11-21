//
//  MediaPlayer.swift
//  jsrl
//
//  Created by Fisk on 14/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import CoreData
import UIKit

/**
 Manages data stored between JSRl playlists and tracks stored in Core Data.
 Offers a simple API to get tracks by station.
 */
class Library {
    static let shared = Library()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var list = [Track]()
    
    /**
     Get all tracks belonging to Station.
 	 */
    func getTracksIn(station: Station) -> [Track] {
    	return self.list.filter({ (track: Track) -> Bool in
    		return station.source == "" || track.station == station.name
    	})
    }
    
    /**
     Load library from Core Data.
     
     - returns: True if loading from Core Data was successful.
     */
    func loadFromCoreData() -> Bool {
        let request: NSFetchRequest<Track> = Track.fetchRequest()
        
        do {
            list = try context.fetch(request)
            return true;
        } catch {
            return false;
        }
    }
    
    func downloadStationPlaylist(_ station: Station, jsrl: JSRL, onComplete: @escaping ()->()) {
        if (station.source == "") {
            onComplete()
            return
        }
        
        let tracklists = jsrl.getTrackLists()
        
        print("Populating \(station.name)...")
        
        tracklists.parseUrl(source: station.source) { (_, strings: [String]) in
            let trackList: [NSManagedObject] = strings.map {string in
                let entity = NSEntityDescription.entity(forEntityName: "Track", in: self.context)
                let track = NSManagedObject(entity: entity!, insertInto: self.context)
                track.setValue(string, forKey: "filename")
                track.setValue(station.name, forKey: "station")
                
                return track
            }
            
            print("Found \(trackList.count) songs for \(station.name)")
            
            do {
                try self.context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            onComplete()
        }
    }
    
    /**
     Get library data from the network.
     */
    func populateFrom(jsrl: JSRL, onComplete: @escaping ()->()) {
        print("Downloading library...")
        
        var remaining = Stations.shared.list.count
        
        _ = Stations.shared.list.map {
            downloadStationPlaylist($0, jsrl: jsrl, onComplete: {
                remaining -= 1
                
                if (remaining == 0) {
                    onComplete()
                }
            })
        }
    }
}

/**
 Simple class to extract song metadata.
 We could use the actual metadata but JSRL's MP3's are largely untagged.
 Instead we split the filename as all songs are stored as Artist - Song Name.mp3
 */
class JSRLSongMetadata {
    var artist = "Unknown Artist"
    var title = "Unknown Track"
    
    init(_ track: Track) {
        if let currentTrackFile = track.filename {
            let values = currentTrackFile.components(separatedBy: " - ")
            
            if (values.count == 2) {
                artist = values[0]
                title = values[1]
            } else {
                title = values[0]
            }
        }
    }
}
