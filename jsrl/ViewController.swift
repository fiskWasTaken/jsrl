//
//  ViewController.swift
//  jsrl
//
//  Created by Fisk on 10/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import MediaPlayer
import UIKit
import AVFoundation
import CoreData

var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

class ViewController: UIViewController {
    @IBOutlet weak var EmblemImage: UIButton!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var songName: UILabel!
    
    let jsrl = JSRL()
    var library = Library.shared
    var player = Player.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (library.list.count == 0) {
            _ = library.loadFromCoreData()
        }
        
        player.jsrl = jsrl
        
        let tracks = library.getTracksIn(station: "The GGs")
        player.playlist = Playlist(tracks)
        player.playlist.shuffle()
    }
    
    @IBAction func onSkipButtonTouch(_ sender: Any) {
        player.next()
        updateMetadata()
    }
    
    func updateMetadata() {
        if (artist != nil && player.currentTrack != nil) {
            let metadata = JSRLSongMetadata(player.currentTrack!)
            artist.text = metadata.artist
            songName.text = metadata.title
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMetadata()
        player.onPlayStart = { self.updateMetadata() }
    }
    
    @IBAction func debugPopulateLibrary(_ sender: AnyObject) {
        library.populateFrom(jsrl: jsrl)
    }
}
