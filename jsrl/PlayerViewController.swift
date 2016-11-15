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

class PlayerViewController: UIViewController {
    @IBOutlet weak var emblemImage: UIButton!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet var uiView: UIView!
    
    let jsrl = JSRL()
    var library = Library.shared
    var player = Player.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (library.list.count == 0) {
            _ = library.loadFromCoreData()
        }
        
        player.jsrl = jsrl
        
        let tracks = library.getTracksIn(station: Player.shared.activeStation.name)
        player.playlist = Playlist(tracks)
        player.playlist.shuffle()
    }
    
    @IBAction func onSkipButtonTouch(_ sender: Any) {
        player.next()
        updateMetadata()
    }
    
    func updateStationDecor() {
        let station = Player.shared.activeStation
        
        uiView.backgroundColor = UIColor(hexString: station.color)
        emblemImage.setImage(station.getImageAsset(), for: UIControlState.normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.onPlayStart = { self.updateMetadata() }
        updateMetadata()
        updateStationDecor()
    }
    
    @IBAction func debugPopulateLibrary(_ sender: AnyObject) {
        library.populateFrom(jsrl: jsrl)
    }
}
