//
//  MediaPlayer.swift
//  jsrl
//
//  Created by Fisk on 14/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import AVFoundation
import CoreData

class MediaLibrary {
    var nowPlaying: Track?
    var player = AVPlayer()
    var library = [Track]()
    var station = "Future"
    
    func getRandomTrack() -> Track {
        let tracks = getTracksIn(station: self.station)
        return tracks[Int(arc4random_uniform(UInt32(tracks.count)))]
    }
    
    func getTracksIn(station: String) -> [Track] {
    	return self.library.filter({ (track: Track) -> Bool in
    		return track.station == station
    	})
    }
}
