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
 	 Get the absolute URL for a track name with percent encoding.
     
     - parameters:
     	- name: The track name.
     
     - returns: An URL object representing the resource location.
     */
    func resolveUrl(_ name: String) -> URL {
        let encName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        return URL(string: "\(context.root)/audioplayer/audio/\(encName).mp3")!
    }
    
    func get(_ name: String, _ callback: @escaping ()->()) {
        var request = URLRequest(url: resolveUrl(name))
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
            
            callback()
        }
        
        task.resume()

    }
}
