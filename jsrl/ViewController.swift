//
//  ViewController.swift
//  jsrl
//
//  Created by Fisk on 10/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

class ViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var EmblemImage: UIButton!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var songName: UILabel!
    var swipeGestureRecogniser = UISwipeGestureRecognizer()
    
    let jsrl = JSRL()
    
    var library = Library()
    var player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.jsrl = jsrl
        
        if mainView != nil {
            if (library.list.count == 0) {
                _ = library.loadFromCoreData()
            }
        }
    }
    
    @IBAction func onSkipButtonTouch(_ sender: Any) {
        onFinishedPlayingMedia()
    }
    
    /**
     Set the currently playing media and play it.
 	 */
    func setCurrentlyPlayingMedia(_ track: Track) {
        player.setCurrent(track: track)
        player.play()
        
        updateMetadata()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onFinishedPlayingMedia), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.avItem)
    }
    
    /**
     Callback to play the next track when the current song is finished playing.
     */
    func onFinishedPlayingMedia() {
        setCurrentlyPlayingMedia(library.getRandom())
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
    
    func getContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "jsrl")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
            container.viewContext.perform({
                // actions upon the NSMainQueueConcurrencyType NSManagedObjectContext for this container
            })
        })

        return container
    }
    
    @IBAction func debugPopulateLibrary(_ sender: AnyObject) {
        library.populateFrom(jsrl: jsrl)
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceived(with event: UIEvent?) { // *
        let rc = event!.subtype
        let p = player.player
        print("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
        
        switch rc {
        case .remoteControlTogglePlayPause:
            if ((p.rate != 0) && (p.error == nil)) {
                // player is playing
                p.pause()
            } else {
                p.play()
            }
        case .remoteControlPlay:
            p.play()
        case .remoteControlPause:
            p.pause()
        case .remoteControlNextTrack:
            onFinishedPlayingMedia()
        case .remoteControlPreviousTrack:
            onFinishedPlayingMedia()
        default:break
        }
    }
    
    func updateChat() {
        
    }
}
