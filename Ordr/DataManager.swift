//
//  DataManager.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 29/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation

class DataManager {
    var vendors: [Vendor] {
        get {
            print("\nLoading vendors from core data")
            let retreivedVendors = coreDataManager.getEntityFromCoreData("Vendor")
            print("\nvendors in core data: \(retreivedVendors.count)")
            
            if let vendors = retreivedVendors as? [Vendor] {
                return vendors
            }
            return [Vendor]()
        }
    }
    var coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    
    // Vendor Functions
    
    func newEmailAddress() -> EmailAddress {
        return self.coreDataManager.makeEmailAddressObject()
    }
    
    func newPhoneNumber() -> PhoneNumber {
        return self.coreDataManager.makePhoneNumberObject()
    }
    
    func newAddress() -> Address {
        return self.coreDataManager.makeAddressObject()
    }
    
    func removeProductLine(productLine: ProductLine) -> Bool {
        print("Removing product line: \(productLine.name)")
        // Remove emails
        if let products = productLine.products?.allObjects as? [ProductItem] {
            for product in products {
                _ = self.coreDataManager.removeObjectFromCoreData(product)
            }
        }
        // Delete vendor
        return self.coreDataManager.removeObjectFromCoreData(productLine)
    }
    
    func newVendor() -> Vendor {
        return self.coreDataManager.makeVendorObject()
    }
    
    func removeVendor(vendor: Vendor) -> Bool {
        print("Removing vendor: \(vendor.name)")
        // Remove emails
        if let emails = vendor.emailAddresses.allObjects as? [EmailAddress] {
            for email in emails {
                _ = self.coreDataManager.removeObjectFromCoreData(email)
            }
        }
        // Delete vendor
        return self.coreDataManager.removeObjectFromCoreData(vendor)
    }
    
    func removeVendorAttribute(object: BaseAttribute) {
        self.coreDataManager.removeObjectFromCoreDataWithoutSave(object)
    }
    
    func findVendorWithAttribute(attribute: String, value: String) -> [Vendor] {
        return self.coreDataManager.getEntityFromCoreDataWithEqualsPredicate("Vendor", attribute: attribute, value: value) as! [Vendor]
    }
    
    
    // Product Line Functions
    func newMoney() -> MoneyCoreData {
        return self.coreDataManager.makeMoneyObject()
    }
    
    func newProductLine() -> ProductLine {
        return self.coreDataManager.makeProductLineObject()
    }
    
    func newProductItem() -> ProductItem {
        return self.coreDataManager.makeProductItemObject()
    }
    
    func updateCoreData() {
        self.coreDataManager.updateCoreData()
    }
}
