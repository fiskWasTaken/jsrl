//
//  Chat.swift
//  jsrl
//
//  Created by Fisk on 10/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class Chat : Resource {
    var recvEndpoint = "/chat/messages.xml"
    var sendEndpoint = "/chat/save.php"
    
    var messageReceivedHandlers: [()->()] = []
    var messages: [ChatMessage] = []
    
    func fetch(callback: (_: String, _: String)->()) {
        let url = URL(string: context.root + recvEndpoint)
        
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
    
    func send(msg: ChatMessage) {
        let form: [String: Any] = [
            "chatmessage": msg.message,
            "chatpassword": msg.password,
            "username": msg.username
        ]
        
        
    }
    
    func onMessageReceived(handler: @escaping ()->()) {
        self.messageReceivedHandlers.append(handler)
    }
}

/**
 An entity representing a single message digest.
 */
class ChatMessage {
    /**
     Message text.
     */
    var message: String = ""
    
    /**
     Usernames. May contain HTML
     */
    var username: String = ""
    
    /**
     is a 40-character hash, e.g. 250e7dd82f8dbba1e0463134ea4f7e3dcdb313e3
     
     It is unknown if this field is decryptable or not:
     - it's too long to be an md5 hash
     - doesn't seem to decode as hex or base64
     - is not referenced in the site's obfuscated javascript source
     */
    var ip: String = ""
    
    /**
     Not sure how this field works yet.
     */
    var password: Bool = false
    
    /**
     Return a unique message hash
 	*/
    func hash() -> String {
        return (message + username)
    }
}
