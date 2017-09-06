//
//  Category.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 8/1/17.
//  Copyright © 2017 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var productLine: ProductLine
    @NSManaged var products: NSSet?
}
