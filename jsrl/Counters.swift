//
//  Counters.swift
//  jsrl
//

import Foundation

class Counters : Resource {
}

/**
 Counter user entity.
 */
class CounterUser {
    var ip: String
    var timestamp: Int
    
    init(ip: String, timestamp: Int) {
        self.ip = ip
        self.timestamp = timestamp
    }
}
