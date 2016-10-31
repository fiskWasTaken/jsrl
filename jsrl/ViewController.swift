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
    
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var songName: UILabel!
    var swipeGestureRecogniser = UISwipeGestureRecognizer()
    
    var nowPlaying: Track?
    var player = AVPlayer()
    var library = [Track]()
    let jsrl = JSRL()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mainView != nil {
            if (library.count == 0) {
                let request: NSFetchRequest<Track> = Track.fetchRequest()
                
                do {
                    self.library = try context.fetch(request)
                    print(self.library)
                    setCurrentlyPlayingMedia(getRandomTrack())
                } catch {
                    print("Error with request: \(error)")
                }
            }
            
            swipeGestureRecogniser.addTarget(self, action: #selector(ViewController.onViewSwiped))
            swipeGestureRecogniser.direction = UISwipeGestureRecognizerDirection.left
            mainView.addGestureRecognizer(swipeGestureRecogniser)
            mainView.isUserInteractionEnabled = true
        }
    }
    
    func onViewSwiped(){
        print("Swiped event")
        setCurrentlyPlayingMedia(getRandomTrack())
    }
    
    func getRandomTrack() -> Track {
        return library[Int(arc4random_uniform(UInt32(library.count)))]
    }
    
    func setCurrentlyPlayingMedia(_ track: Track) {
        nowPlaying = track
        
        let urlAsset = AVURLAsset(url: jsrl.getMedia().resolveUrl(track.value!))
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
    
        if (nowPlaying?.value == nil) {
            return
        }
        
        let values = (nowPlaying?.value)!.components(separatedBy: " - ")
        
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
        
        tracklists.parseUrl(source: "/audioplayer/audio/~list.js") { (_, strings: [String]) in
            let trackList: [NSManagedObject] = strings.map {string in
                let entity = NSEntityDescription.entity(forEntityName: "Track", in: self.context)
                let track = NSManagedObject(entity: entity!, insertInto: self.context)
                track.setValue(string, forKey: "value")
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
    
    @IBAction func printLibrary(_ sender: Any) {
        let request: NSFetchRequest<Track> = Track.fetchRequest()
        
        do {
            let searchResults = try context.fetch(request)
            print(searchResults)
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func updateChat() {
        
    }
}
