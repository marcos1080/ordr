//
//  EmailAddress.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 27/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData

class EmailAddress: BaseAttribute {
    @NSManaged var name: String?
    @NSManaged var address: String
    @NSManaged var vendor: Vendor
    
    // Used to trigger other variables on setting the address
    var emailAddress: String {
        set {
            self.address = newValue
            self.isGood = true
            self.isSaved = true
        }
        get {
            return self.address
        }
    }
    var candidateAddress: String?
    override var comparisonObject: [String: String] {
        get {
            var returnObject = [String: String]()
            if let address = self.candidateAddress {
                returnObject["emailAddress"] = address
            } else if !self.address.isEmpty {
                returnObject["emailAddress"] = address
            }
            
            return returnObject
        }
    }
    
    // Test to see if address can be blank
    func blankAddressFieldInvalid() -> Bool {
        if self.isNew {
            // New number can be left blank, remove any error state
            self.isGood = true
            self.address.removeAll()
            self.candidateAddress = nil
            return false
        }
        
        return true
    }
    
    // Email validation test.
    override func isValid() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self.candidateAddress)
        
        if result == false {
            return false
        }
        
        return result
    }
    
    override func printInfo() {
        print("\nCell Info")
        print("Name: \(self.name)")
        print("Address: \(self.address)")
    }
}
