//
//  Tracks.swift
//  jsrl
//
//  Created by Fisk on 13/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class Tracks : Resource {
    /**
 	 Get the absolute URL for a track name.
     
     - parameters:
     	- name: The track name.
     
     - returns: An absolute URL for the audio track as a string.
     */
    func resolveUrl(_ name: String) -> String {
        return "\(context.root)/audioplayer/audio/\(name).mp3"
    }
    
    func get(_ name: String, _ callback: ()->()) {
        let url = URL(string: resolveUrl(name))
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                return
            }
            
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            print(dataString)
        }
        
        task.resume()

    }
}
