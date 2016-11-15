//
//  Playlist.swift
//  jsrl
//
//  Created by Fisk on 15/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

/**
 Manages a sequential playlist.
 */
class Playlist {
    var list: [Track]
    var position = -1
    
    init(_ tracks: [Track]) {
        self.list = tracks
    }
    
    /**
     Get the previous track in the sequence.
     
     - returns: The previous track.
     */
    func getPrevious() -> Track {
        if (position > 0) {
            position -= 1
        } else {
            position = 0
        }
        
        let track = list[position % list.count]
        
        
        return track
    }
    
    /**
     Get the next track in the sequence.
     */
    func getNext() -> Track {
        position += 1
        let track = list[position % list.count]
        return track
    }
    
    /**
     Shuffles tracks in the playlist.
     */
    func shuffle() {
        if (list.count > 0) {
            for i in 0...(list.count - 1) {
                let tmp = list[i]
                let rand = Int(arc4random_uniform(UInt32(list.count)))
                list[i] = list[rand]
                list[rand] = tmp
            }
        }
    }
}
