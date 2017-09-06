//
//  PhoneNumber.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 27/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData
import PhoneNumberKit

class PhoneNumber: BaseAttribute {
    @NSManaged var name: String?
    @NSManaged var number: String
    @NSManaged var vendor: Vendor
    
    // Used to trigger other variables on setting the address
    var phoneNumber: String {
        set {
            self.number = newValue
            self.isGood = true
            self.isSaved = true
        }
        get {
            return self.number
        }
    }
    
    var candidateNumber: String?
    override var comparisonObject: [String: String] {
        get {
            var returnObject = [String: String]()
            if let number = self.candidateNumber {
                returnObject["phoneNumber"] = number
            } else if !self.number.isEmpty {
                returnObject["phoneNumber"] = number
            }
            
            return returnObject
        }
    }
    
    // Test to see if address can be blank
    func blankNumberFieldInvalid() -> Bool {
        if self.isNew {
            // New number can be left blank, remove any error state
            self.isGood = true
            self.number.removeAll()
            self.candidateNumber = nil
            return false
        }
        
        return true
    }
    
    // Email validation test.
    override func isValid() -> Bool {
        // Initialize phone number parser
        let phoneNumberKit = PhoneNumberKit()
        
        let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        
        do {
            if let number = self.candidateNumber {
                _ = try phoneNumberKit.parse(number, withRegion: countryCode!, ignoreType: true)
            } else {
                return false
            }
        }
        catch {
            return false
        }
        
        return true
    }
    
    override func printInfo() {
        print("\nCell Info")
        print("Name: \(self.name)")
        print("Number: \(self.number)")
    }
}
