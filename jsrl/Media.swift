//
//  Media.swift
//  jsrl
//
//  Created by Fisk on 13/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class Media : Resource {
    /**
 	 Get the absolute URL for some media with percent encoding.
     
     - parameters:
     	- name: The track name.
     
     - returns: An URL object representing the resource location.
     */
    func resolveUrl(_ name: String) -> URL {
        let encName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        return URL(string: "\(context.root)/audioplayer/audio/\(encName).mp3")!
    }
    
    /**
     Get a track and return a callback.
     
     - parameters:
     	- name: The track name.
     	- callback: Callback with err and data.
     */
    func getData(_ name: String, _ callback: @escaping (Error?, Data?)->()) {
        var request = URLRequest(url: resolveUrl(name))
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if (error != nil) {
                callback(error, nil)
            }
            
            if let data = data {
                callback(nil, data)
            }
        }
        
        task.resume()
    }
}
