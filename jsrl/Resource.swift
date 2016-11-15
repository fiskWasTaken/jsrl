//
//  Resource.swift
//  jsrl
//
//  Created by Fisk on 13/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import Foundation

/**
 Abstract API Resource implementation.
 */
class Resource {
    var context: JSRL
    
    /**
     Create a new instance of this resource.
     
     - parameters:
       - context: The API context.
     */
    init(_ context: JSRL) {
        self.context = context
    }
}
