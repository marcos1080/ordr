//
//  PhoneTableViewCell.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 15/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

protocol PhoneDataSourceDelegate {
    func isNotDuplicate( instance: BaseAttribute ) -> Bool
    func toggleAddButton()
}

class PhoneTableViewCell: BaseEditTableViewCell {

    var delegate: PhoneDataSourceDelegate!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    static var nameLabelOriginalText: String?
    static var nameLabelOriginalColor: UIColor?
    static var numberLabelOriginalText: String?
    static var numberLabelOriginalColor: UIColor?
    
    override var object: BaseAttribute {
        set {
            self.phoneNumberObject = newValue as! PhoneNumber
            if let name = self.phoneNumberObject.name {
                self.nameField.text = name
                self.setNameLabel(message: "Saved", color: UIColor.savedTextColor)
            } else {
                // New Cell
                self.nameField.text = ""
                self.resetNameLabel()
            }
            if self.phoneNumberObject.number != "" {
                self.numberField.text = self.phoneNumberObject.number
                self.setNumberLabel(message: "Saved", color: UIColor.savedTextColor)
            } else {
                // New Cell
                self.numberField.text = ""
                self.resetNumberLabel()
            }
        }
        get {
            return self.phoneNumberObject
        }
    }
    
    var phoneNumberObject : PhoneNumber!
    
    // Backup original text and colours for the name and address fields.
    override func setup() {
        if PhoneTableViewCell.nameLabelOriginalText == nil {
            PhoneTableViewCell.nameLabelOriginalText = self.nameLabel.text
        }
        if PhoneTableViewCell.nameLabelOriginalColor == nil {
            PhoneTableViewCell.nameLabelOriginalColor = self.nameLabel.textColor
        }
        if PhoneTableViewCell.numberLabelOriginalText == nil {
            PhoneTableViewCell.numberLabelOriginalText = self.numberLabel.text
        }
        if PhoneTableViewCell.numberLabelOriginalColor == nil {
            PhoneTableViewCell.numberLabelOriginalColor = self.numberLabel.textColor
        }
    }
    
    // Validation on end editing on text field.
    @IBAction func endValidation( sender: UITextField ) {
        self.phoneNumberObject.candidateNumber = self.numberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Empty number field
        if self.phoneNumberObject.candidateNumber == "" {
            if phoneNumberObject.blankNumberFieldInvalid() {
                // Cannot leave a "saved" number blank. Prompt user and set error.
                self.showWarning( message: "Invalid Number!" )
                self.phoneNumberObject.candidateNumber = self.numberField.text!
                let alertController = UIAlertController(title: "Cannot leave number blank!", message: "Did you mean to delete the number? If so swipe left to delete.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil )
                alertController.addAction(action)
                
                self.viewController()?.present(alertController, animated: true, completion: nil)
            }
            return
        }
        
        self.validate()
        self.phoneNumberObject.printInfo()
    }
    
    // If an invalid number has been entered then validate each time the numer is changed
    @IBAction func activeValidation( sender: UITextField ) {
        if self.phoneNumberObject.isGood == false {
            self.phoneNumberObject.candidateNumber = self.numberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.validate()
        }
    }
    
    func validate() {
        if !self.phoneNumberObject.isValid() {
            self.showWarning( message: "Invalid Number!" )
            return
        }
        
        if self.delegate.isNotDuplicate(instance: phoneNumberObject) {
            self.save()
        } else {
            self.showWarning( message: "Duplicate Detected!" )
        }
    }
    
    func save() {
        if self.phoneNumberObject.name != nil && !self.phoneNumberObject.isSaved {
            self.setNameLabel(message: "Saved", color: UIColor.savedTextColor)
        }
        if self.phoneNumberObject.number.isEmpty {
            self.setNumberLabel(message: "Saved", color: UIColor.savedTextColor)
        } else {
            self.setNumberLabel(message: "Updated", color: UIColor.savedTextColor)
        }
        self.phoneNumberObject.phoneNumber = self.numberField.text!
        if self.phoneNumberObject.isNew {
            self.delegate.toggleAddButton()
        }
    }
    
    // Save name if cell state is saved.
    @IBAction func nameChanged(sender: UIButton) {
        if let savedName = self.phoneNumberObject.name {
            // Previous name detected
            if self.nameField.text! == "" {
                self.phoneNumberObject.name = nil
                self.resetNameLabel()
            } else if savedName != self.nameField.text! {
                self.phoneNumberObject.name = self.nameField.text!
                self.setNameLabel(message: "Updated", color: UIColor.savedTextColor)
            }
        } else if !self.nameField.text!.isEmpty {
            // No name detected, just save.
            self.phoneNumberObject.name = self.nameField.text!
            if self.phoneNumberObject.isSaved {
                self.setNameLabel(message: "Saved", color: UIColor.savedTextColor)
            }
        }
    }
    
    func setNameLabel(message: String, color: UIColor) {
        self.nameLabel.text = message
        self.nameLabel.textColor = color
    }
    
    func resetNameLabel() {
        self.nameLabel.text = PhoneTableViewCell.nameLabelOriginalText
        self.nameLabel.textColor = PhoneTableViewCell.nameLabelOriginalColor!
    }
    
    // Show error message and change colour to indicate error.
    func showWarning( message: String ) {
        self.numberLabel.text = message
        self.numberLabel.textColor = UIColor.errorTextColor
        
        self.phoneNumberObject.isGood = false
        self.delegate.toggleAddButton()
    }
    
    func setNumberLabel(message:String, color: UIColor) {
        self.numberLabel.text = message
        self.numberLabel.textColor = color
    }
    
    // Reset the warning label to the original message and colour.
    func resetNumberLabel() {
        self.numberLabel.text = PhoneTableViewCell.numberLabelOriginalText
        self.numberLabel.textColor = PhoneTableViewCell.numberLabelOriginalColor
    }
    
    // Cell passed duplicate check after being flagged.
    override func reset() {
        print("Cell Reset")
        self.phoneNumberObject.candidateNumber = self.numberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !self.phoneNumberObject.isValid() {
            self.showWarning( message: "Invalid Number!" )
        } else {
            self.save()
        }
        self.phoneNumberObject.printInfo()
    }
}
