//
//  Requests.swift
//  jsrl
//
//  Created by Fisk on 10/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class Requests : Resource {
    var endpoint: String = "/messages/messages.xml"
}

class RequestMessage {
    /**
     Used as a command.
     
     "REQUEST: Song Filename" forces clients to play the Song Filename.mp3
     if it's not currently playing. This means that newly connected clients
     will still play the song from the beginning even though everyone else
     is probably almost done listening.
     
     "SCREEN: URL" displays an image to all clients for a few seconds.
     */
    var message: String = ""
    
    /**
     Who is responsible for this message.
     */
    var avatar: String = ""
    
    init(message: String, avatar: String) {
        self.message = message
        self.avatar = avatar
    }
    
    /**
     Extract the request type.
     
     - returns: A string (REQUEST, SCREEN, etc)
 	 */
    func getType() -> String {
        let regex = try! NSRegularExpression(pattern: "^(.*):", options: [])
        let matches = regex.matches(in: message, options: [], range: NSRange(location: 0, length: message.characters.count))
        
        let range = matches[0].rangeAt(1)
        let end = message.index(message.startIndex, offsetBy: range.length)
        return message.substring(to: end)
    }
    
    /**
     Extract the request text.
     
     - returns: A string containing the request text.
 	 */
    func getText() -> String {
        let regex = try! NSRegularExpression(pattern: "^.*: (.*)$", options: [])
        let matches = regex.matches(in: message, options: [], range: NSRange(location: 0, length: message.characters.count))
        
        let range = matches[0].rangeAt(1)
        let start = message.index(message.startIndex, offsetBy: range.location)
        let end = message.index(message.startIndex, offsetBy: range.location + range.length)
        return message.substring(with: start ..< end)
    }
}
