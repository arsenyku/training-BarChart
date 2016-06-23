//
//  ABCSignal+CoreDataProperties.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-22.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ABCSignal {

    @NSManaged var entryDate: NSDate?
    @NSManaged var status: String?
    @NSManaged var unitNumber: String?

}
