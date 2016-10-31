//
//  TrackLists.swift
//  jsrl
//
//  Created by Fisk on 12/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class TrackLists : Resource {
    /**
     Parse a script at an URI and callback with an array of track names.
     
     - parameters:
     	- source: The source URI (is appended to the context root).
     	- callback: A callback returning an Error object in the first parameter
                    (if something happened) and an array of track names.
     */
    func parseUrl(source: String, callback: @escaping (Error?, [String])->()) {
        let url = URL(string: self.context.root + source)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                callback(error, [])
            }
            
            if let data = data, let html = String(data: data, encoding: String.Encoding.utf8) {
                callback(nil, self.parse(html))
            }
        }
        
        task.resume()
    }
    
    /**
     Parse a large multi-line script to extract an array of track names.
     
     - parameters:
     	- body: A body of text (probably some JavaScript source from jetsetradio.live).
     
     - returns: An array of track names.
     */
    func parse(_ bodyRaw: String) -> [String] {
        // Swift is buggy crap that does not understand carriage returns in regex so remove them first
        // If we don't do this then indexing completely ignores the character and everything is off-by-one
        var body = bodyRaw.replacingOccurrences(of: "\r", with: "")
        
        let pattern = ".+ = \"(.*)\""
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: body, options: [], range: NSRange(location: 0, length: body.characters.count))
        
        return matches.map({
            let range = $0.rangeAt(1)
            
            let start = body.index(body.startIndex, offsetBy: range.location)
            let end = body.index(body.startIndex, offsetBy: range.location + range.length)
            return body.substring(with: start ..< end)
        })
    }
}
