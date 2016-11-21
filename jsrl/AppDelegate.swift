//
//  AppDelegate.swift
//  jsrl
//
//  Created by Fisk on 10/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let jsrl = JSRL()

    /**
     Application initialiser.
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("Initialising")
        let library = Library.shared
        let player = Player.shared
        
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: "chatUsername") == nil) {
            defaults.set("Rudie", forKey: "chatUsername")
        }
        
        let selectedStation = defaults.string(forKey: "selectedStation")
        
        if let selectedStation = selectedStation {
            let station = Stations.shared.getBy(name: selectedStation)
            
            if let station = station {
                player.activeStation = station
            }
        }
        
        player.jsrl = jsrl
        _ = library.loadFromCoreData()
        
        if (library.list.count == 0) {
            print("Performing first-time setup")
            
            Library.shared.populateFrom(jsrl: JSRL(), onComplete: {
                print("Reloading library")
                _ = library.loadFromCoreData()
                self.afterInit()
            })
        } else {
            print("Library already loaded, skipping firstrun")
            self.afterInit()
        }
        
        
        return true
    }
    
    func afterInit() {
        let library = Library.shared
        let player = Player.shared
        
        let tracks = library.getTracksIn(station: player.activeStation)
        player.playlist = Playlist(tracks)
        player.playlist.shuffle()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "jsrl")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

