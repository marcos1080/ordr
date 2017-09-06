//
//  Vendor.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 27/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData

class Vendor: NSManagedObject {
    @NSManaged var image: NSData?
    @NSManaged var name: String
    @NSManaged var desc: String?
    @NSManaged var emailAddresses: NSSet
    @NSManaged var phoneNumbers: NSSet?
    @NSManaged var addresses: NSSet?
    @NSManaged var productLines: NSSet?
    
    func getEmailArray() -> [EmailAddress] {
        if let emails = self.emailAddresses.allObjects as? [EmailAddress] {
            return emails
        }
        
        return [EmailAddress]()
    }
    
    func getPhoneNumberArray() -> [PhoneNumber] {
        if let phoneNumbers = self.phoneNumbers?.allObjects as? [PhoneNumber] {
            return phoneNumbers
        }
        
        return [PhoneNumber]()
    }
    
    func getAddressArray() -> [Address] {
        if let addresses = self.addresses?.allObjects as? [Address] {
            return addresses
        }
        
        return [Address]()
    }
}
