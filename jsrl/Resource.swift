//
//  Resource.swift
//  jsrl
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
