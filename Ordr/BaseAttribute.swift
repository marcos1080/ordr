//
//  BaseAttribute.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 29/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData

class BaseAttribute: NSManagedObject {
    var isNew: Bool = true
    var isGood: Bool = true
    var resetDuplicate: Bool = false
    var isSaved: Bool = false
    
    var comparisonObject: [String: String] {
        get {
            let dictionary = [String: String]()
            return dictionary
        }
    }
    
    func isValid() -> Bool {
        return true
    }
    
    func isNotDuplicate() -> Bool {
        return true
    }
    
    func printInfo() {}
}
