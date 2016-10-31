//
//  JSRL.swift
//  jsrl
//
//  Created by Fisk on 12/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class JSRL {
    var root: String = "https://jetsetradio.live"
    
    /**
     Get a Chat instance bound to this context.
	 */
    func getChat() -> Chat {
        return Chat(self)
    }
    
    /**
     Get a Requests instance bound to this context.
     */
    func getRequests() -> Requests {
        return Requests(self)
    }
    
    /**
     Get a TrackLists instance bound to this context.
     */
    func getTrackLists() -> TrackLists {
        return TrackLists(self)
    }
    
    /**
     Get a Counters instance bound to this context.
     */
    func getCounters() -> Counters {
        return Counters(self)
    }
    
    /**
     Get a Media instance bound to this context.
     */
    func getMedia() -> Media {
        return Media(self)
    }
}
