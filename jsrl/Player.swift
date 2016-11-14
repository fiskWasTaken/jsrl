//
//  MediaPlayer.swift
//  jsrl
//
//  Created by Fisk on 14/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import AVFoundation
import MediaPlayer

class Player {
    var currentTrack: Track?
    var player = AVPlayer()
    var jsrl: JSRL? = nil
    
    var urlAsset: AVURLAsset? = nil
    var avItem: AVPlayerItem? = nil
    
    func setCurrent(track: Track) {
        currentTrack = track
        urlAsset = AVURLAsset(url: (jsrl?.getMedia().resolveUrl(track.filename!))!)
        avItem = AVPlayerItem(asset: urlAsset!)
    }
    
    /**
     Play something on the AVPlayer.
 	 */
    func play() {
        self.player = AVPlayer(playerItem: avItem)
        self.player.play()
        
        let metadata = JSRLSongMetadata(currentTrack!)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: metadata.title,
            MPMediaItemPropertyArtist: metadata.artist
        ]
    }
}
