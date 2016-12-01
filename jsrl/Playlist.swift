//
//  Playlist.swift
//  jsrl
//

import Foundation

/**
 Playlist manages a sequential playlist that loops forever.
 */
class Playlist {
    var list: [Track]
    var cursor = -1
    
    /**
     Create a new playlist with an array of tracks as the source.
     
     - properties:
       - tracks: A list of tracks.
     */
    init(_ tracks: [Track]) {
        self.list = tracks
    }
    
    /**
     Get the previous track in the sequence. If the cursor is < 0, this
     will just return the first track in the playlist.
     
     - returns: The previous track.
     */
    func getPrevious() -> Track {
        if (cursor > 0) {
            cursor -= 1
        } else {
            cursor = 0
        }
        
        let track = list[cursor % list.count]
        return track
    }
    
    /**
     Get the next track in the sequence.
     
     - returns: The next track.
     */
    func getNext() -> Track {
        cursor += 1
        let track = list[cursor % list.count]
        return track
    }
    
    /**
     Shuffles tracks in this playlist and resets the cursor.
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
        
        cursor = -1
    }
}
