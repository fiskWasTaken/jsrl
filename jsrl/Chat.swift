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
    
    func fetch(callback: @escaping (_ err: String, _ body: String)->()) {
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
            
            callback("", dataString!)
        }
        
        task.resume()
    }
    
    func send(msg: ChatMessage) {
        let url = URL(string: context.root + sendEndpoint)
        
        let form: [String: String] = [
            "chatmessage": msg.message,
            "chatpassword": msg.password ? "true" : "false",
            "username": msg.username
        ]
        
        let formData = form.map({"\($0)=\($1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))"}).joined(separator: "&")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.httpBody = formData.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                return
            }
            
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            print(dataString)
            
//            callback("", dataString!)
        }
        
        task.resume()
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
