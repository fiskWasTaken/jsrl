//
//  Tracks.swift
//  jsrl
//
//  Created by Fisk on 13/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class Tracks : Resource {
    func get(_ name: String, _ callback: ()->()) {
        getFile(name + ".mp3", callback)
    }
    
    func getFile(_ name: String, _ callback: ()->()) {
        let url = URL(string: context.root + name)
        
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
