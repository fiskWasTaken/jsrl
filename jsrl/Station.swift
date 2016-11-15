//
//  Station.swift
//  jsrl
//
//  Created by Fisk on 15/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

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
     Icon resource
     */
    let icon: String
    
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
        icon = dictionary.value(forKey: "Icon") as! String
        color = dictionary.value(forKey: "Color") as! String
        genre = dictionary.value(forKey: "Genre") as! String
        root = dictionary.value(forKey: "Root") as? String
    }
}
