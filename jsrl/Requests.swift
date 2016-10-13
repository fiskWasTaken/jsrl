//
//  Requests.swift
//  jsrl
//
//  Created by Fisk on 10/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class Requests : Resource {
    var endpoint: String = "/messages"
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
}
