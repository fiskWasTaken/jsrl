//
//  Cache.swift
//  jsrl
//
//  Created by Fisk on 11/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

// todo: some sort of caching mechanism
// throw out unpopular songs when cache reaches a size
class Cache {
    func getItem(_ id: String) -> CacheItem {
    	return CacheItem(id)
    }
}

class CacheItem {
    let id: String
    
    init(_ id: String) {
        self.id = id
    }
    
    func put() {
    
    }
    
    func set() {
    
    }
    
    func exists() -> Bool {
    	return true
    }
}
