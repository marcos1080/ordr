//
//  EmailTableViewCell.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 13/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

// Interact with view containing the tableview.
protocol EmailDataSourceDelegate {
    func isNotDuplicate( instance: BaseAttribute ) -> Bool
    func toggleAddButton()
}

class EmailTableViewCell: BaseEditTableViewCell {
    
    var delegate: EmailDataSourceDelegate!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    static var nameLabelOriginalText: String?
    static var nameLabelOriginalColor: UIColor?
    static var addressLabelOriginalText: String?
    static var addressLabelOriginalColor: UIColor?
    
    override var object: BaseAttribute {
        get {
            return self.emailObject
        }
        set {
            self.emailObject = newValue as! EmailAddress
            if let name = emailObject.name {
                self.nameField.text = name
                self.setNameLabel(message: "Saved", color: UIColor.savedTextColor)
            } else {
                // New Cell
                self.nameField.text = ""
                self.resetNameLabel()
            }
            if self.emailObject.address != "" {
                self.addressField.text = emailObject.address
                self.setAddressLabel(message: "Saved", color: UIColor.savedTextColor)
            } else {
                // New Cell
                self.addressField.text = ""
                self.resetAddressLabel()
            }
        }
    }
    
    var emailObject : EmailAddress!
    
    // Backup original text and colours for the name and address fields.
    override func setup() {
        if EmailTableViewCell.nameLabelOriginalText == nil {
            EmailTableViewCell.nameLabelOriginalText = self.nameLabel.text
        }
        if EmailTableViewCell.nameLabelOriginalColor == nil {
            EmailTableViewCell.nameLabelOriginalColor = self.nameLabel.textColor
        }
        if EmailTableViewCell.addressLabelOriginalText == nil {
            EmailTableViewCell.addressLabelOriginalText = self.addressLabel.text
        }
        if EmailTableViewCell.addressLabelOriginalColor == nil {
            EmailTableViewCell.addressLabelOriginalColor = self.addressLabel.textColor
        }
    }
    
    // Validation on end editing on text field.
    @IBAction func endValidation( sender: UITextField ) {
        self.emailObject.candidateAddress = self.addressField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Empty number field
        if self.emailObject.candidateAddress == "" {
            if emailObject.blankAddressFieldInvalid() {
                // Cannot leave a "saved" number blank. Prompt user and set error.
                self.showWarning( message: "Invalid Number!" )
                self.emailObject.candidateAddress = self.addressField.text!
                let alertController = UIAlertController(title: "Cannot leave address blank!", message: "Did you mean to delete the email?/nIf so swipe left to delete.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil )
                alertController.addAction(action)
                
                self.viewController()?.present(alertController, animated: true, completion: nil)
            }
            return
        }
        
        self.validate()
        self.emailObject.printInfo()
    }
    
    // If an invalid email has been entered then validate each time the address is changed
    @IBAction func activeValidation( sender: UITextField ) {
        if self.emailObject.isGood == false {
            self.emailObject.candidateAddress = self.addressField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.validate()
        }
    }
    
    func validate() {
        if !self.emailObject.isValid() {
            self.showWarning( message: "Invalid Email!" )
            return
        }
        
        if self.delegate.isNotDuplicate(instance: emailObject) {
            self.save()
        } else {
            self.showWarning( message: "Duplicate Detected!" )
        }
    }
    
    func save() {
        if self.emailObject.name != nil && !self.emailObject.isSaved {
            self.setNameLabel(message: "Saved", color: UIColor.savedTextColor)
        }
        if self.emailObject.address.isEmpty {
            self.setAddressLabel(message: "Saved", color: UIColor.savedTextColor)
        } else {
            self.setAddressLabel(message: "Updated", color: UIColor.savedTextColor)
        }
        self.emailObject.emailAddress = self.addressField.text!
        if self.emailObject.isNew {
            self.delegate.toggleAddButton()
        }
    }
    
    // Save name if cell state is saved.
    @IBAction func nameChanged(sender: UIButton) {
        if let savedName = self.emailObject.name {
            // Previous name detected
            if self.nameField.text! == "" {
                self.emailObject.name = nil
                self.resetNameLabel()
            } else if savedName != self.nameField.text! {
                self.emailObject.name = self.nameField.text!
                self.setNameLabel(message: "Updated", color: UIColor.savedTextColor)
            }
        } else if !self.nameField.text!.isEmpty {
            // No name detected, just save.
            self.emailObject.name = self.nameField.text!
            print(self.emailObject.isSaved)
            if self.emailObject.isSaved {
                self.setNameLabel(message: "Saved", color: UIColor.savedTextColor)
            }
        }
    }
    
    func setNameLabel(message: String, color: UIColor) {
        self.nameLabel.text = message
        self.nameLabel.textColor = color
    }
    
    func resetNameLabel() {
        self.nameLabel.text = EmailTableViewCell.nameLabelOriginalText!
        self.nameLabel.textColor = EmailTableViewCell.nameLabelOriginalColor!
    }
    
    // Show error message and change colour to indicate error.
    func showWarning( message: String ) {
        self.addressLabel.text = message
        self.addressLabel.textColor = UIColor.errorTextColor
        
        self.emailObject.isGood = false
        self.delegate.toggleAddButton()
    }
    
    func setAddressLabel(message:String, color: UIColor) {
        self.addressLabel.text = message
        self.addressLabel.textColor = color
    }
    
    // Reset the warning label to the original message and colour.
    func resetAddressLabel() {
        self.addressLabel.text = EmailTableViewCell.addressLabelOriginalText!
        self.addressLabel.textColor = EmailTableViewCell.addressLabelOriginalColor!
    }
    
    // Cell passed duplicate check after being flagged.
    override func reset() {
        print("Cell Reset")
        self.emailObject.candidateAddress = self.addressField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !self.emailObject.isValid() {
            self.showWarning( message: "Invalid Number!" )
        } else {
            self.save()
        }
    }
}
