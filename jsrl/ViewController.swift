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
        player.jsrl = jsrl
        player.onPlayStart = { self.updateMetadata() }
        
        if (library.list.count == 0) {
            _ = library.loadFromCoreData()
        }
    
    }
    
    @IBAction func onSkipButtonTouch(_ sender: Any) {
        player.next()
    }
    
    /**
     We could use the actual metadata but JSRL's MP3's are largely untagged :'(
     Instead we split the filename as all songs are stored as Artist - Song Name.mp3
 	 */
    func updateMetadata() {
        if let currentTrackFile = player.currentTrack?.filename {
            let values = currentTrackFile.components(separatedBy: " - ")

            artist.text = values[0]
            songName.text = values[1]
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
    }
    
    @IBAction func debugPopulateLibrary(_ sender: AnyObject) {
        library.populateFrom(jsrl: jsrl)
    }
}
