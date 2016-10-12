//
//  Context.swift
//  jsrl
//
//  Created by Fisk on 12/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class Context {
    var root: String = "http://jetsetradio.live"
    
    func getChat() -> Chat {
        return Chat(self)
    }
    
    func getRequests() -> Requests {
        return Requests(self)
    }
    
    func getTrackLists() -> TrackLists {
        return TrackLists(self)
    }
}
