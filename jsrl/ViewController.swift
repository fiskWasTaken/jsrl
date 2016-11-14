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
    
    var nowPlaying: Track?
    var player = AVPlayer()
    var library = [Track]()
    var station = "Future"
    let jsrl = JSRL()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var mediaLibrary = MediaLibrary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mainView != nil {
            if (library.count == 0) {
                reloadLibrary()
            }
            
            swipeGestureRecogniser.addTarget(self, action: #selector(ViewController.onViewSwiped))
            swipeGestureRecogniser.direction = UISwipeGestureRecognizerDirection.left
            mainView.addGestureRecognizer(swipeGestureRecogniser)
            mainView.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func onSkipButtonTouch(_ sender: Any) {
        setCurrentlyPlayingMedia(mediaLibrary.getRandomTrack())
    }
    
    func reloadLibrary() {
        let request: NSFetchRequest<Track> = Track.fetchRequest()
        
        do {
            mediaPlayer.library = try context.fetch(request)
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func onViewSwiped(){
        print("Swiped event")
    }
    
    func getRandomTrack() -> Track {
        return library[Int(arc4random_uniform(UInt32(library.count)))]
    }
    
    func setCurrentlyPlayingMedia(_ track: Track) {
        nowPlaying = track
        
        let urlAsset = AVURLAsset(url: jsrl.getMedia().resolveUrl(track.filename!))
        let avItem = AVPlayerItem(asset: urlAsset)
        
        updateMetadata()
        
        self.player = AVPlayer(playerItem: avItem)
        self.player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onFinishedPlayingMedia), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avItem)
    }
    
    func onFinishedPlayingMedia() {
        setCurrentlyPlayingMedia(getRandomTrack())
    }
    
    func updateMetadata() {
        // we could use the actual metadata but JSRL's MP3's are largely untagged :'(
        // instead we split the filename as this is what the Android app does anyway
    
        if (nowPlaying?.filename == nil) {
            return
        }
        
        let values = (nowPlaying?.filename)!.components(separatedBy: " - ")
        
        artist.text = values[0]
        songName.text = values[1]
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
        // Download
        let jsrl = JSRL()
        let tracklists = jsrl.getTrackLists()
        
        print("Loading library")
        
        var stationArray: NSArray?
        if let path = Bundle.main.path(forResource: "Stations", ofType: "plist") {
            stationArray = NSArray(contentsOfFile: path)
        }
        
        if let stations = stationArray {
            for station in stations {
                if (((station as! NSDictionary).object(forKey: "Source") as! String) == "") {
                    continue;
                }
                
                print("Populating " + ((station as! NSDictionary).object(forKey: "Name") as! String))
                
                tracklists.parseUrl(source: ((station as! NSDictionary).object(forKey: "Source") as! String)) { (_, strings: [String]) in
                    let trackList: [NSManagedObject] = strings.map {string in
                        let entity = NSEntityDescription.entity(forEntityName: "Track", in: self.context)
                        let track = NSManagedObject(entity: entity!, insertInto: self.context)
                        track.setValue(string, forKey: "filename")
                        track.setValue((station as! NSDictionary).object(forKey: "Name") as! String, forKey: "station")
                        
                        return track
                    }
                    
                    print(trackList)
                    
                    do {
                        try self.context.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
            }
            
            reloadLibrary()
        }
    }
    
    @IBAction func printLibrary(_ sender: Any) {
        let request: NSFetchRequest<Track> = Track.fetchRequest()
        
        do {
            let searchResults = try context.fetch(request)
            print(searchResults)
        } catch {
            print("Error with request: \(error)")
        }
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
//        let p = self.player.player! // todo
        print("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
//        switch rc {
//        case .remoteControlTogglePlayPause:
//            if p.isPlaying { p.pause() } else { p.play() }
//        case .remoteControlPlay:
//            p.play()
//        case .remoteControlPause:
//            p.pause()
//        default:break
//        }
    }
    
    func updateChat() {
        
    }
}
