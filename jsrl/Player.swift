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
    static let shared = Player()
    
    var playlist: Playlist = Playlist([])
    var currentTrack: Track?
    var player = AVPlayer()
    var jsrl: JSRL? = nil
    var onPlayStart: (()->())? = nil
    
    var urlAsset: AVURLAsset? = nil
    var avItem: AVPlayerItem? = nil
    
    init() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPNowPlayingInfoPropertyPlaybackRate: 0
        ]
        
        initialiseMediaRemote()
    }
    
    /**
     Add media remote handlers.
     */
    func initialiseMediaRemote() {
        let remote = MPRemoteCommandCenter.shared()
        
        remote.togglePlayPauseCommand.addTarget(handler: { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            if (self.currentTrack == nil) {
                self.next()
            } else if (self.isPlaying()) {
                self.player.pause()
            } else {
                self.player.play()
            }
            
            return MPRemoteCommandHandlerStatus.success
        })
        
        remote.playCommand.addTarget(handler: { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            if (self.currentTrack == nil) {
                self.next()
            } else {
                self.player.play()
            }
            
            return MPRemoteCommandHandlerStatus.success
        })
        
        remote.pauseCommand.addTarget(handler: { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            return MPRemoteCommandHandlerStatus.success
        })
        
        remote.nextTrackCommand.addTarget(handler: { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.next()
            return MPRemoteCommandHandlerStatus.success
        })
        
        remote.previousTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.previous()
            return MPRemoteCommandHandlerStatus.success
        }
        
        remote.stopCommand.addTarget(handler: { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.next()
            return MPRemoteCommandHandlerStatus.success
        })
    }
    
    func setCurrent(track: Track) {
        currentTrack = track
        urlAsset = AVURLAsset(url: (jsrl?.getMedia().resolveUrl(track.filename!))!)
        avItem = AVPlayerItem(asset: urlAsset!)
    }
    
    /**
     Play something on the AVPlayer.
 	 */
    func play() {
        self.onPlayStart!()
        self.player = AVPlayer(playerItem: avItem)
        self.player.play()
        
        let metadata = JSRLSongMetadata(currentTrack!)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: metadata.title,
            MPMediaItemPropertyArtist: metadata.artist,
            MPNowPlayingInfoPropertyPlaybackRate: 1
        ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(next), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avItem)
    }
    
    /**
     Returns true if AVPlayer is currently playing a track.
     */
    func isPlaying() -> Bool {
        return ((player.rate != 0) && (player.error == nil))
    }
    
    /**
     Next track.
     */
    @objc func next() {
        if (playlist.list.count == 0) {
            return
        }
        
        setCurrent(track: playlist.getNext())
        play()
    }
    
    /**
     Previous track.
     */
    @objc func previous() {
        if (playlist.list.count == 0) {
            return
        }
        
        setCurrent(track: playlist.getPrevious())
        play()
    }
}
