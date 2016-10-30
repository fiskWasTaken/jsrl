//
//  Station.swift
//  jsrl
//
//  Created by Fisk on 29/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import CoreData

class Station: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var tracks: [Track]?
}
