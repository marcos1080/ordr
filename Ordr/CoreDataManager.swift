//
//  CoreDataManager.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 4/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager
{
    init() {
    }
    
    var managedContext: NSManagedObjectContext {
        get {
            return self.getContext()
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    
    // Function to get any entity from core data.
    func getEntityFromCoreData(_ entity: String) -> [NSManagedObject]
    {
        print("\nFetching \(entity) from CoreData")
        
        var entityRecords = [NSManagedObject]()
        let managedContext = self.getContext()
        
        do
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let results = try managedContext.fetch(fetchRequest)
            
            if let results = results as? [NSManagedObject] {
                entityRecords = results
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return entityRecords
    }
    
    // Function to get any entity from core data that matches a predicate.
    func getEntityFromCoreDataWithEqualsPredicate(_ entity: String, attribute: String, value: String) -> [NSManagedObject]
    {
        print("\nFetching \(entity) from CoreData")
        
        var entityRecords = [NSManagedObject]()
        let managedContext = self.getContext()
        
        do
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let predicate = NSPredicate(format: "%K == %@",   attribute , value)
            fetchRequest.predicate = predicate
            let results = try managedContext.fetch(fetchRequest)
            
            if let results = results as? [NSManagedObject] {
                entityRecords = results
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return entityRecords
    }
    
    func removeObjectFromCoreDataWithoutSave(_ object: NSManagedObject) {
        self.managedContext.delete(object)
    }
    
    func removeObjectFromCoreData(_ object: NSManagedObject) -> Bool {
        self.managedContext.delete(object)
        
        do {
            try managedContext.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
            return false
        }
        
        return true
    }
    
    
    // Vendor Functions
    
    func makeEmailAddressObject() -> EmailAddress {
        let entity = NSEntityDescription.entity(forEntityName: "EmailAddress", in:self.managedContext)
        return EmailAddress(entity: entity!, insertInto:self.managedContext)
    }
    
    func makePhoneNumberObject() -> PhoneNumber {
        let entity = NSEntityDescription.entity(forEntityName: "PhoneNumber", in:self.managedContext)
        return PhoneNumber(entity: entity!, insertInto:self.managedContext)
    }
    
    func makeAddressObject() -> Address {
        let entity = NSEntityDescription.entity(forEntityName: "Address", in:self.managedContext)
        return Address(entity: entity!, insertInto:self.managedContext)
    }
    
    func makeProductLineObject() -> ProductLine {
        let entity = NSEntityDescription.entity(forEntityName: "ProductLine", in:self.managedContext)
        return ProductLine(entity: entity!, insertInto:self.managedContext)
    }
    
    func makeVendorObject() -> Vendor {
        let entity = NSEntityDescription.entity(forEntityName: "Vendor", in:self.managedContext)
        return Vendor(entity: entity!, insertInto:self.managedContext)
    }
    
    
    
    // Product Line Functions
    
    func makeMoneyObject() -> MoneyCoreData {
        let entity = NSEntityDescription.entity(forEntityName: "MoneyCoreData", in:self.managedContext)
        return MoneyCoreData(entity: entity!, insertInto:self.managedContext)
    }
    
    func makeProductItemObject() -> ProductItem {
        let entity = NSEntityDescription.entity(forEntityName: "ProductItem", in:self.managedContext)
        return ProductItem(entity: entity!, insertInto:self.managedContext)
    }
    
    func updateCoreData()
    {
        do
        {
            print("\nUpdating CoreData")
            try managedContext.save()
        }
        catch let error as NSError
        {
            print( "could not save \(error), \(error.userInfo)" )
        }
    }
}
