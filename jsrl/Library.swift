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
    func getTracksIn(station: String) -> [Track] {
    	return self.list.filter({ (track: Track) -> Bool in
    		return track.station == station
    	})
    }
    
    /**
     Load library from Core Data.
     */
    func loadFromCoreData() -> Bool {
        let request: NSFetchRequest<Track> = Track.fetchRequest()
        
        // todo: necessary? this can't really fail
        do {
            list = try context.fetch(request)
            return true;
        } catch {
            print("Error with request: \(error)")
            return false;
        }
    }
    
    func saveStation(_ station: NSDictionary, jsrl: JSRL) {
        if ((station.object(forKey: "Source") as! String) == "") {
            return
        }
        
        let tracklists = jsrl.getTrackLists()
        
        print("Populating " + (station.object(forKey: "Name") as! String))
        
        tracklists.parseUrl(source: (station.object(forKey: "Source") as! String)) { (_, strings: [String]) in
            let trackList: [NSManagedObject] = strings.map {string in
                let entity = NSEntityDescription.entity(forEntityName: "Track", in: self.context)
                let track = NSManagedObject(entity: entity!, insertInto: self.context)
                track.setValue(string, forKey: "filename")
                track.setValue(station.object(forKey: "Name") as! String, forKey: "station")
                
                return track
            }
            
            print(trackList)
            
            do {
                try self.context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    /**
     Get library data from the network.
     */
    func populateFrom(jsrl: JSRL) {
        print("Downloading library")
        
        var stationArray: NSArray?
        if let path = Bundle.main.path(forResource: "Stations", ofType: "plist") {
            stationArray = NSArray(contentsOfFile: path)
        }
        
        if let stations = stationArray {
            for station in stations {
                saveStation(station as! NSDictionary, jsrl: jsrl)
            }
            
            _ = loadFromCoreData()
        }
    }
}

class JSRLSongMetadata {
    var artist = "Unknown Artist"
    var title = "Unknown Track"
    
    init(_ track: Track) {
        if let currentTrackFile = track.filename {
            let values = currentTrackFile.components(separatedBy: " - ")
            
            artist = values[0]
            title = values[1]
        }
    }
}
