//
//  ProductLine.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 27/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData

class ProductLine: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var products: NSSet?
    @NSManaged var vendor: Vendor
}
