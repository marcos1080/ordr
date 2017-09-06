//
//  AddressTableViewCell.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 20/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

// Interact with view containing the tableview.
protocol AddressDataSourceDelegate {
    func isNotDuplicate( instance: BaseAttribute ) -> Bool
    func toggleAddButton()
}

class AddressTableViewCell: BaseEditTableViewCell {
    
    var delegate: AddressDataSourceDelegate!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var streetLineOneField: UITextField!
    @IBOutlet weak var streetLineTwoField: UITextField!
    @IBOutlet weak var townField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var postCodeField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLineOneLabel: UILabel!
    @IBOutlet weak var streetLineTwoLabel: UILabel!
    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var duplicateLabel: UILabel!
    
    static var nameLabelOriginalText: String?
    static var nameLabelOriginalColor: UIColor?
    static var streetLineOneLabelOriginalText: String?
    static var streetLineOneLabelOriginalColor: UIColor?
    static var streetLineTwoLabelOriginalText: String?
    static var streetLineTwoLabelOriginalColor: UIColor?
    static var townLabelOriginalText: String?
    static var townLabelOriginalColor: UIColor?
    static var stateLabelOriginalText: String?
    static var stateLabelOriginalColor: UIColor?
    static var postCodeLabelOriginalText: String?
    static var postCodeLabelOriginalColor: UIColor?
    static var countryLabelOriginalText: String?
    static var countryLabelOriginalColor: UIColor?
    static var duplicateLabelOriginalText: String?
    static var duplicateLabelOriginalColor: UIColor?
    
    override var object: BaseAttribute {
        set {
            self.addressObject = newValue as! Address
            if let name = self.addressObject.name {
                self.nameField.text = name
                self.setLabel(labelName: "name", message: "Saved", color: UIColor.savedTextColor)
                self.addressObject.candidateName = self.addressObject.name
            } else {
                self.nameField.text = ""
                self.nameLabel.text = AddressTableViewCell.nameLabelOriginalText
                self.nameLabel.textColor = AddressTableViewCell.nameLabelOriginalColor
            }
            if self.addressObject.streetLineOne != "" {
                self.streetLineOneField.text = self.addressObject.streetLineOne
                self.setLabel(labelName: "streetLineOne", message: "Saved", color: UIColor.savedTextColor)
                self.addressObject.candidateStreetLineOne = self.addressObject.streetLineOne
            } else {
                self.streetLineOneField.text = ""
                self.streetLineOneLabel.text = AddressTableViewCell.streetLineOneLabelOriginalText
                self.streetLineOneLabel.textColor = AddressTableViewCell.streetLineOneLabelOriginalColor
            }
            if let streetLineTwo = self.addressObject.streetLineTwo {
                self.streetLineTwoField.text = streetLineTwo
                self.setLabel(labelName: "streetLineTwo", message: "Saved", color: UIColor.savedTextColor)
                self.addressObject.candidateStreetLineTwo = self.addressObject.streetLineTwo
            } else {
                self.streetLineTwoField.text = ""
                self.streetLineTwoLabel.text = AddressTableViewCell.streetLineTwoLabelOriginalText
                self.streetLineTwoLabel.textColor = AddressTableViewCell.streetLineTwoLabelOriginalColor
            }
            if self.addressObject.town != "" {
                self.townField.text = self.addressObject.town
                self.setLabel(labelName: "town", message: "Saved", color: UIColor.savedTextColor)
                self.addressObject.candidateTown = self.addressObject.town
            } else {
                self.townField.text = ""
                self.townLabel.text = AddressTableViewCell.townLabelOriginalText
                self.townLabel.textColor = AddressTableViewCell.townLabelOriginalColor
            }
            if self.addressObject.state != "" {
                self.stateField.text = self.addressObject.state
                self.setLabel(labelName: "state", message: "Saved", color: UIColor.savedTextColor)
                self.addressObject.candidateState = self.addressObject.state
            } else {
                self.stateField.text = ""
                self.stateLabel.text = AddressTableViewCell.stateLabelOriginalText
                self.stateLabel.textColor = AddressTableViewCell.stateLabelOriginalColor
            }
            if self.addressObject.postCode != "" {
                self.postCodeField.text = self.addressObject.postCode
                self.setLabel(labelName: "postCode", message: "Saved", color: UIColor.savedTextColor)
                self.addressObject.candidatePostCode = self.addressObject.postCode
            } else {
                self.postCodeField.text = ""
                self.postCodeLabel.text = AddressTableViewCell.postCodeLabelOriginalText
                self.postCodeLabel.textColor = AddressTableViewCell.postCodeLabelOriginalColor
            }
            if let country = self.addressObject.country {
                self.countryField.text = country
                self.setLabel(labelName: "country", message: "Saved", color: UIColor.savedTextColor)
                self.addressObject.candidateCountry = self.addressObject.country
            } else {
                self.countryField.text = ""
                self.countryLabel.text = AddressTableViewCell.countryLabelOriginalText
                self.countryLabel.textColor = AddressTableViewCell.countryLabelOriginalColor
            }
        }
        get {
            return self.addressObject
        }
    }
    
    var addressObject : Address!
    
    override func setup() {
        // Save original label values
        if AddressTableViewCell.nameLabelOriginalText == nil {
            AddressTableViewCell.nameLabelOriginalText = self.nameLabel.text!
        }
        
        if AddressTableViewCell.nameLabelOriginalColor == nil {
            AddressTableViewCell.nameLabelOriginalColor = self.nameLabel.textColor
        }
        
        if AddressTableViewCell.streetLineOneLabelOriginalText == nil {
            AddressTableViewCell.streetLineOneLabelOriginalText = self.streetLineOneLabel.text!
        }
        
        if AddressTableViewCell.streetLineOneLabelOriginalColor == nil {
            AddressTableViewCell.streetLineOneLabelOriginalColor = self.streetLineOneLabel.textColor
        }
        
        if AddressTableViewCell.streetLineTwoLabelOriginalText == nil {
            AddressTableViewCell.streetLineTwoLabelOriginalText = self.streetLineTwoLabel.text!
        }
        
        if AddressTableViewCell.streetLineTwoLabelOriginalColor == nil {
            AddressTableViewCell.streetLineTwoLabelOriginalColor = self.streetLineTwoLabel.textColor
        }
        
        if AddressTableViewCell.townLabelOriginalText == nil {
            AddressTableViewCell.townLabelOriginalText = self.townLabel.text!
        }
        
        if AddressTableViewCell.townLabelOriginalColor == nil {
            AddressTableViewCell.townLabelOriginalColor = self.townLabel.textColor
        }
        
        if AddressTableViewCell.stateLabelOriginalText == nil {
            AddressTableViewCell.stateLabelOriginalText = self.stateLabel.text!
        }
        
        if AddressTableViewCell.stateLabelOriginalColor == nil {
            AddressTableViewCell.stateLabelOriginalColor = self.stateLabel.textColor
        }
        
        if AddressTableViewCell.postCodeLabelOriginalText == nil {
            AddressTableViewCell.postCodeLabelOriginalText = self.postCodeLabel.text!
        }
        
        if AddressTableViewCell.postCodeLabelOriginalColor == nil {
            AddressTableViewCell.postCodeLabelOriginalColor = self.postCodeLabel.textColor
        }
        
        if AddressTableViewCell.countryLabelOriginalText == nil {
            AddressTableViewCell.countryLabelOriginalText = self.countryLabel.text!
        }
        
        if AddressTableViewCell.countryLabelOriginalColor == nil {
            AddressTableViewCell.countryLabelOriginalColor = self.countryLabel.textColor
        }
        
        if AddressTableViewCell.duplicateLabelOriginalText == nil {
            AddressTableViewCell.duplicateLabelOriginalText = self.duplicateLabel.text!
        }
        
        if AddressTableViewCell.duplicateLabelOriginalColor == nil {
            AddressTableViewCell.duplicateLabelOriginalColor = self.duplicateLabel.textColor
        }
    }
    
    // Validation on end editing on text field.
    @IBAction func endEditing( sender: UITextField ) {
        
        switch sender {
        case self.nameField:
            self.addressObject.candidateName = sender.text!
            break
        case self.streetLineOneField:
            self.addressObject.candidateStreetLineOne = sender.text!
            break
        case self.streetLineTwoField:
            self.addressObject.candidateStreetLineTwo = sender.text!
            break
        case self.townField:
            self.addressObject.candidateTown = sender.text!
            break
        case self.stateField:
            self.addressObject.candidateState = sender.text!
            break
        case self.postCodeField:
            self.addressObject.candidatePostCode = sender.text!
            break
        default:
            self.addressObject.candidateCountry = sender.text!
            break
        }
        
        self.validate()
    }
    
    func validate() {
        print("validating")
        if self.addressObject.isValid() {
            if self.delegate.isNotDuplicate(instance: self.addressObject) {
                self.showSavedLabels()
                self.addressObject.save()
                if self.addressObject.isNew {
                    self.delegate.toggleAddButton()
                }
            } else {
                showDuplicateWarning()
            }
        } else {
            if self.addressObject.isSaved {
                showWarnings()
            }
        }
    }
    
    // Show error message and change colour to indicate error.
    func showWarnings() {
        if (self.streetLineOneField.text?.isEmpty)! {
            self.streetLineOneLabel.text = AddressTableViewCell.streetLineOneLabelOriginalText
            self.streetLineOneLabel.textColor = UIColor.errorTextColor
        }
        
        if (self.townField.text?.isEmpty)! {
            self.townLabel.text = AddressTableViewCell.townLabelOriginalText
            self.townLabel.textColor = UIColor.errorTextColor
        }
        
        if (self.stateField.text?.isEmpty)! {
            self.stateLabel.text = AddressTableViewCell.stateLabelOriginalText
            self.stateLabel.textColor = UIColor.errorTextColor
        }
        
        if (self.postCodeField.text?.isEmpty)! {
            self.postCodeLabel.text = AddressTableViewCell.postCodeLabelOriginalText
            self.postCodeLabel.textColor = UIColor.errorTextColor
        }
        
        self.addressObject.isGood = false
        self.delegate.toggleAddButton()
        
        // All fields are empty, show prompt to delete.
        if self.addressObject.isEmpty() {
            let alertController = UIAlertController(title: "Cannot leave address blank!", message: "Did you mean to delete the address?\n If so swipe left to delete.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil )
            alertController.addAction(action)
            
            self.viewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showDuplicateWarning() {
        self.nameLabel.textColor = UIColor.errorTextColor
        self.streetLineOneLabel.textColor = UIColor.errorTextColor
        self.streetLineTwoLabel.textColor = UIColor.errorTextColor
        self.townLabel.textColor = UIColor.errorTextColor
        self.stateLabel.textColor = UIColor.errorTextColor
        self.postCodeLabel.textColor = UIColor.errorTextColor
        self.countryLabel.textColor = UIColor.errorTextColor
        self.setLabel(labelName: "duplicate", message: "Duplicate detected!", color: UIColor.errorTextColor)
        let alertController = UIAlertController(title: "Address has already been used!", message: "A duplicate address is already present.\n The duplicate fields are marked in red.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil )
        alertController.addAction(action)
        
        self.viewController()?.present(alertController, animated: true, completion: nil)
        self.delegate.toggleAddButton()
    }
    
    func showSavedLabels() {
        if self.addressObject.candidateName != nil {
            if self.addressObject.name == nil {
                self.setLabel(labelName: "name", message: "Saved", color: UIColor.savedTextColor)
            } else {
                self.setLabel(labelName: "name", message: "Updated", color: UIColor.savedTextColor)
            }
        } else {
            self.nameLabel.text = AddressTableViewCell.nameLabelOriginalText
            self.nameLabel.textColor = AddressTableViewCell.nameLabelOriginalColor
        }
        
        if self.addressObject.streetLineOne.isEmpty {
            self.setLabel(labelName: "streetLineOne", message: "Saved", color: UIColor.savedTextColor)
        } else {
            self.setLabel(labelName: "streetLineOne", message: "Updated", color: UIColor.savedTextColor)
        }
        
        if self.addressObject.candidateStreetLineTwo != nil {
            if self.addressObject.streetLineTwo == nil {
                self.setLabel(labelName: "streetLineTwo", message: "Saved", color: UIColor.savedTextColor)
            } else {
                self.setLabel(labelName: "streetLineTwo", message: "Updated", color: UIColor.savedTextColor)
            }
        } else {
            self.streetLineTwoLabel.text = AddressTableViewCell.streetLineTwoLabelOriginalText
            self.streetLineTwoLabel.textColor = AddressTableViewCell.streetLineTwoLabelOriginalColor
        }
        
        if self.addressObject.town.isEmpty {
            self.setLabel(labelName: "town", message: "Saved", color: UIColor.savedTextColor)
        } else {
            self.setLabel(labelName: "town", message: "Updated", color: UIColor.savedTextColor)
        }
        
        if self.addressObject.state.isEmpty {
            self.setLabel(labelName: "state", message: "Saved", color: UIColor.savedTextColor)
        } else {
            self.setLabel(labelName: "state", message: "Updated", color: UIColor.savedTextColor)
        }
        
        if self.addressObject.postCode.isEmpty {
            self.setLabel(labelName: "postCode", message: "Saved", color: UIColor.savedTextColor)
        } else {
            self.setLabel(labelName: "postCode", message: "Updated", color: UIColor.savedTextColor)
        }
        
        if self.addressObject.candidateCountry != nil {
            if self.addressObject.country == nil {
                self.setLabel(labelName: "country", message: "Saved", color: UIColor.savedTextColor)
            } else {
                self.setLabel(labelName: "country", message: "Updated", color: UIColor.savedTextColor)
            }
        } else {
            self.countryLabel.text = AddressTableViewCell.countryLabelOriginalText
            self.countryLabel.textColor = AddressTableViewCell.countryLabelOriginalColor
        }
    }
    
    func setLabel(labelName: String, message:String, color: UIColor) {
        var label: UILabel!
        
        switch labelName {
        case "name":
            label = self.nameLabel
            break
        case "streetLineOne":
            label = self.streetLineOneLabel
            break
        case "streetLineTwo":
            label = self.streetLineTwoLabel
            break
        case "town":
            label = self.townLabel
            break
        case "state":
            label = self.stateLabel
            break
        case "postCode":
            label = self.postCodeLabel
            break
        case "country":
            label = self.countryLabel
            break
        default:
            label = self.duplicateLabel
            break
        }
        
        label.text! = message
        label.textColor = color
    }
    
    // Cell passed duplicate check after being flagged.
    override func reset() {
        print("Cell Reset")
        self.duplicateLabel.text = AddressTableViewCell.duplicateLabelOriginalText
        self.duplicateLabel.textColor = AddressTableViewCell.duplicateLabelOriginalColor
        if self.addressObject.isValid() {
            self.showSavedLabels()
            self.addressObject.save()
            if self.addressObject.isNew {
                self.delegate.toggleAddButton()
            }
        } else {
            if self.addressObject.isSaved {
                showWarnings()
            }
        }
    }
}
