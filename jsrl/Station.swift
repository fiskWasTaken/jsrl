//
//  Station.swift
//  jsrl
//
//  Created by Fisk on 15/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation
import UIKit

/**
 Information for a Station.
 */
class Station {
    /**
     Station name
     */
    let name: String
    
    /**
     Playlist source
     */
    let source: String
    
    /**
     Image resource filename
     */
    let image: String
    
    /**
     Accent color (hex value, #123456)
     */
    let color: String
    
    /**
     Station description.
     */
    let genre: String
    
    /**
     Root is an optional value that overrides where the songs come from
     */
    let root: String?
    
    /**
     Load from an NSDictionary entry (from Stations.plist).
     */
    init(_ dictionary: NSDictionary) {
        name = dictionary.value(forKey: "Name") as! String
        source = dictionary.value(forKey: "Source") as! String
        image = dictionary.value(forKey: "Image") as! String
        color = dictionary.value(forKey: "Color") as! String
        genre = dictionary.value(forKey: "Genre") as! String
        root = dictionary.value(forKey: "Root") as? String
    }
    
    func getImageAsset() -> UIImage? {
        let path = Bundle.main.path(forResource: image, ofType: "png")
        
        if let path = path {
            return UIImage(contentsOfFile: path)
        }
        
        return nil
    }
}

/**
 Station repository. Use the shared instance.
 */
class Stations {
    static let shared = Stations()
    
    let list: [Station]
    
    init() {
        var stations: NSArray?
        
        if let path = Bundle.main.path(forResource: "Stations", ofType: "plist") {
            stations = NSArray(contentsOfFile: path)
        }
        
        if let stations = stations {
            list = stations.map({
                return Station($0 as! NSDictionary)
            })
        } else {
            list = []
        }
    }
    
    func getBy(name: String) -> Station? {
        for station in list {
            if (station.name == name) {
                return station
            }
        }
        
        return nil
    }
}
