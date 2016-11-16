//
//  MediaPlayer.swift
//  jsrl
//
//  Created by Fisk on 14/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import AVFoundation
import MediaPlayer

/**
 Player manages the iOS media remote. Use the shared instance.
 */
class Player {
    static let shared = Player()
    
    var activeStation: Station
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
        
        // Use the first station we know about.
        activeStation = Stations.shared.list[0]
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
            
            self.updateMediaRemoteState()
            return MPRemoteCommandHandlerStatus.success
        })
        
        remote.playCommand.addTarget(handler: { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            if (self.currentTrack == nil) {
                self.next()
            } else {
                self.player.play()
            }
            
            self.updateMediaRemoteState()
            return MPRemoteCommandHandlerStatus.success
        })
        
        remote.pauseCommand.addTarget(handler: { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            
            self.updateMediaRemoteState()
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
        
        var path = track.filename!
        let station = Stations.shared.getBy(name: track.station!)
        
        if let station = station {
            if (station.root != nil) {
                path = station.root! + track.filename!
            }
        }

        urlAsset = AVURLAsset(url: (jsrl?.getMedia().resolveUrl(path))!)
        avItem = AVPlayerItem(asset: urlAsset!)
    }
    
    func updateMediaRemoteState() {
        let metadata = JSRLSongMetadata(currentTrack!)
        let artwork = MPMediaItemArtwork(boundsSize: CGSize(), requestHandler: {size in self.activeStation.getImageAsset()!})
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: metadata.title,
            MPMediaItemPropertyArtist: metadata.artist,
            MPMediaItemPropertyArtwork: artwork,
            MPNowPlayingInfoPropertyPlaybackRate: (isPlaying() ? 1 : 0)
        ]
    }
    
    /**
     Play something on the AVPlayer.
 	 */
    func play() {
        self.onPlayStart!()
        self.player = AVPlayer(playerItem: avItem)
        self.player.play()
        
        updateMediaRemoteState()
        
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
