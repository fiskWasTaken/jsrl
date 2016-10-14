//
//  Resource.swift
//  jsrl
//
//  Created by Fisk on 13/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

/**
 Abstract API Reesource implementation. 
 */
class Resource {
    var context: Context
    
    init(_ context: Context) {
        self.context = context
    }
}
