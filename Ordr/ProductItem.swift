//
//  ProductItem.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 27/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData

class ProductItem: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var desc: String?
    @NSManaged var image: NSData?
    @NSManaged var price: MoneyCoreData?
    @NSManaged var productLine: ProductLine
}
