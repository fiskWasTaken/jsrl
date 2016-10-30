//
//  ViewController.swift
//  jsrl
//
//  Created by Fisk on 10/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import UIKit
import CoreData

var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

class ViewController: UIViewController {
    let jsrl = JSRL()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        jsrl.getChat()
    }
}
