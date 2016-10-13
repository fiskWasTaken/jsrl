//
//  Counters.swift
//  jsrl
//
//  Created by Fisk on 11/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

class Counters : Resource {
}

class CounterUser {
    var ip: String
    var timestamp: Int
    
    init(ip: String, timestamp: Int) {
        self.ip = ip
        self.timestamp = timestamp
    }
}
