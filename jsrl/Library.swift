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
 MediaLibrary manages data stored between JSRl playlists and tracks stored in Core Data.
 MediaLibrary offers a simple API to get tracks by station.
 */
class Library {
    static let shared = Library()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var list = [Track]()
    
    func getRandomFrom(station: String) -> Track {
        let tracks = getTracksIn(station: station)
        return tracks[Int(arc4random_uniform(UInt32(tracks.count)))]
    }
    
    /**
     Get a shuffled list of tracks. This is more effective than calling a random track each time.
     */
    func getShuffledList(tracks: [Track]) -> [Track] {
        var shuffled = tracks
        
        for i in 0...tracks.count {
            let tmp = tracks[i]
            let rand = Int(arc4random_uniform(UInt32(tracks.count)))
            shuffled[i] = tracks[rand]
            shuffled[rand] = tmp
        }
        
        return shuffled
    }
    
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
    
    /**
     Get library data from the network.
     */
    func populateFrom(jsrl: JSRL) {
        let tracklists = jsrl.getTrackLists()
        
        print("Downloading library")
        
        var stationArray: NSArray?
        if let path = Bundle.main.path(forResource: "Stations", ofType: "plist") {
            stationArray = NSArray(contentsOfFile: path)
        }
        
        if let stations = stationArray {
            for station in stations {
                if (((station as! NSDictionary).object(forKey: "Source") as! String) == "") {
                    continue;
                }
                
                print("Populating " + ((station as! NSDictionary).object(forKey: "Name") as! String))
                
                tracklists.parseUrl(source: ((station as! NSDictionary).object(forKey: "Source") as! String)) { (_, strings: [String]) in
                    let trackList: [NSManagedObject] = strings.map {string in
                        let entity = NSEntityDescription.entity(forEntityName: "Track", in: self.context)
                        let track = NSManagedObject(entity: entity!, insertInto: self.context)
                        track.setValue(string, forKey: "filename")
                        track.setValue((station as! NSDictionary).object(forKey: "Name") as! String, forKey: "station")
                        
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
