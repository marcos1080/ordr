//
//  Address.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 27/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData

class Address: BaseAttribute {
    @NSManaged var name: String?
    @NSManaged var streetLineOne: String
    @NSManaged var streetLineTwo: String?
    @NSManaged var town: String
    @NSManaged var state: String
    @NSManaged var postCode: String
    @NSManaged var country: String?
    @NSManaged var vendor: Vendor
    
    var candidateName: String? {
        didSet {
            if candidateName == "" {
                candidateName = nil
            }
        }
    }
    var candidateStreetLineOne: String? {
        didSet {
            if candidateStreetLineOne == "" {
                candidateStreetLineOne = nil
            }
        }
    }
    var candidateStreetLineTwo: String? {
        didSet {
            if candidateStreetLineTwo == "" {
                candidateStreetLineTwo = nil
            }
        }
    }
    var candidateTown: String? {
        didSet {
            if candidateTown == "" {
                candidateTown = nil
            }
        }
    }
    var candidateState: String? {
        didSet {
            if candidateState == "" {
                candidateState = nil
            }
        }
    }
    var candidatePostCode: String? {
        didSet {
            if candidatePostCode == "" {
                candidatePostCode = nil
            }
        }
    }
    var candidateCountry: String? {
        didSet {
            if candidateCountry == "" {
                candidateCountry = nil
            }
        }
    }
    
    override var comparisonObject: [String: String] {
        get {
            var dictionary = [String: String]()
            var currentString: String = ""
            
            if let candidateName = self.candidateName {
                currentString = candidateName
            } else {
                currentString = ""
            }
            dictionary["name"] = currentString
            
            if let candidateStreetLineOne = self.candidateStreetLineOne {
                currentString = candidateStreetLineOne
            } else {
                currentString = ""
            }
            dictionary["streetLineOne"] = currentString
            
            if let candidateStreetLineTwo = self.candidateStreetLineTwo {
                currentString = candidateStreetLineTwo
            } else {
                currentString = ""
            }
            dictionary["streetLineTwo"] = currentString
            
            if let candidateTown = self.candidateTown {
                currentString = candidateTown
            } else {
                currentString = ""
            }
            dictionary["town"] = currentString
            
            if let candidateState = self.candidateState {
                currentString = candidateState
            } else {
                currentString = ""
            }
            dictionary["state"] = currentString

            if let candidatePostCode = self.candidatePostCode {
                currentString = candidatePostCode
            } else {
                currentString = ""
            }
            dictionary["postCode"] = currentString
            
            if let candidateCountry = self.candidateCountry {
                currentString = candidateCountry
            } else {
                currentString = ""
            }
            dictionary["country"] = currentString
            return dictionary
        }
    }
    
    // Email validation test.
    override func isValid() -> Bool {
        if self.candidateStreetLineOne == nil {
            return false
        }
        
        if self.candidateTown == nil {
            return false
        }
        
        if self.candidateState == nil {
            return false
        }
        
        if self.candidatePostCode == nil {
            return false
        }
        
        return true
    }
    
    func save() {
        print("Saving...")
        if let name = self.candidateName {
            self.name = name
        }
        
        if let streetLineOne = self.candidateStreetLineOne {
            self.streetLineOne = streetLineOne
        }
        
        if let streetLineTwo = self.candidateStreetLineTwo {
            self.streetLineTwo = streetLineTwo
        }
        
        if let town = self.candidateTown {
            self.town = town
        }
        
        if let state = self.candidateState {
            self.state = state
        }
        
        if let postCode = self.candidatePostCode {
            self.postCode = postCode
        }
        
        if let country = self.candidateCountry {
            self.country = country
        }

        self.isSaved = true
    }
    
    func isEmpty() -> Bool {
        if self.candidateName != nil {
            return false
        }
        
        if self.candidateStreetLineOne != nil {
            return false
        }
        
        if self.candidateStreetLineTwo != nil {
            return false
        }
        
        if self.candidateTown != nil {
            return false
        }
        
        if self.candidateState != nil {
            return false
        }
        
        if self.candidatePostCode != nil {
            return false
        }
        
        if self.candidateCountry != nil {
            return false
        }
        
        return true
    }
}
