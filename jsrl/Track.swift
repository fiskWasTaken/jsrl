//
//  Track.swift
//  jsrl
//
//  Created by Fisk on 29/10/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import CoreData

class Track: NSManagedObject {
    @NSManaged var value: String?
    @NSManaged var station: Station?
}
