//
//  PhoneVendorEditViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 5/1/17.
//  Copyright © 2017 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class PhoneVendorEditViewController: UIViewController, ViewControllerDelegate, UITextViewDelegate {
    
    let dataManager: DataManager = Model.sharedInstance.dataManager
        
    // Vendor item object. New empty one created on save() or existing one loaded on editItem().
    var vendor: Vendor?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Photo Variables
    @IBOutlet weak var imageContainerView: ImagePickerView!
    @IBOutlet weak var imageView: UIImageView!
    
    // Name Variables
    @IBOutlet weak var nameField: UITextField!
    
    // Description Variables
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    var descriptionFieldInitialHeight: CGFloat = 0
    
    // Email variables.
    @IBOutlet weak var emailTable: VendorItemEditTableView!
    
    // Phone variables.
    @IBOutlet weak var phoneTable: VendorItemEditTableView!
    
    // Address variables
    @IBOutlet weak var addressTable: VendorItemEditTableView!
    
    // Scroll to view variables
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare Image Picker
        self.imageContainerView.setup()
        
        // Prepare description field
        self.descriptionField.delegate = self
        self.descriptionField.layer.borderWidth = 1
        self.descriptionField.layer.borderColor = UIColor(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        self.descriptionField.layer.cornerRadius = 5
        self.descriptionFieldInitialHeight = descriptionHeight.constant
        
        // Prepare table delegates
        self.emailTable.parentDelegate = self
        self.phoneTable.parentDelegate = self
        self.addressTable.parentDelegate = self
        
        // Screen height is used to calculate scroll values
        self.screenHeight = UIScreen.main.bounds.height
        
        // Set field values if there is a vendor object set.
        if self.vendor != nil {
            print("Loading Vendor")
            if self.vendor?.image != nil {
                self.imageView.image = UIImage(data: self.vendor!.image! as Data)
            }
            self.nameField.text! = self.vendor!.name
            if let desc = self.vendor?.desc {
                self.descriptionField.text = desc
            }
            
            if let emails = self.vendor!.emailAddresses.allObjects as? [EmailAddress] {
                self.emailTable.populateFromSavedVendor(data: emails, type: "email")
            }
            
            if let phoneNumbers = self.vendor!.phoneNumbers?.allObjects as? [PhoneNumber] {
                self.phoneTable.populateFromSavedVendor(data: phoneNumbers, type: "phoneNumber")
            } else {
                self.phoneTable.setup(type: "phoneNumber")
            }
            
            if let addresses = self.vendor!.addresses?.allObjects as? [Address] {
                self.addressTable.populateFromSavedVendor(data: addresses, type: "address")
            } else {
                self.addressTable.setup(type: "address")
            }
        } else {
            self.emailTable.setup(type: "email")
            self.phoneTable.setup(type: "phoneNumber")
            self.addressTable.setup(type: "address")
        }
    }
    
    @IBAction func save( _ sender: UIButton ) {
        
        var errorDetected = false
        var scrollToRect: CGRect?
        
        if self.nameField.text == "" {
            errorDetected = true
            scrollToRect = self.nameField.frame
            self.showError(title: "Error detected", message: "Vendor must have a name!", frame: scrollToRect!)
            return
            
        }
        
        var firstErrorFieldFrame = self.emailTable.checkForErrors()
        if firstErrorFieldFrame != CGRect() {
            errorDetected = true
            scrollToRect = firstErrorFieldFrame
            scrollToRect?.origin.y += self.emailTable.frame.origin.y
            self.showError(title: "Error detected", message: "There is an invalid email entered!", frame: scrollToRect!)
            return
        }
        
        firstErrorFieldFrame = self.phoneTable.checkForErrors()
        if firstErrorFieldFrame != CGRect() {
            print(firstErrorFieldFrame)
            errorDetected = true
            scrollToRect = firstErrorFieldFrame
            scrollToRect?.origin.y += self.phoneTable.frame.origin.y
            self.showError(title: "Error detected", message: "There is an invalid phone number entered!", frame: scrollToRect!)
            return
        }
        
        firstErrorFieldFrame = self.addressTable.checkForErrors()
        if firstErrorFieldFrame != CGRect() {
            errorDetected = true
            scrollToRect = firstErrorFieldFrame
            scrollToRect?.origin.y += self.addressTable.frame.origin.y
            self.showError(title: "Error detected", message: "There is an invalid address entered!", frame: scrollToRect!)
            return
        }
        
        if !errorDetected {
            print("save")
            
            // Test for vendors of the same name
            if self.dataManager.findVendorWithAttribute(attribute: "name", value: self.nameField.text!).count > 0 {
                self.showError(title: "Error detected", message: "A vendor with the name \"\(self.nameField.text!)\" already exists!", frame: self.nameField.frame)
                return
            }
            
            // New Item, create product item object.
            if( vendor == nil ) {
                self.vendor = self.dataManager.newVendor()
            }
            
            self.vendor?.name = self.nameField.text!
            if !self.descriptionField.text.isEmpty {
                self.vendor?.desc = self.descriptionField.text
            }
            if self.imageContainerView.imageSet {
                self.vendor?.image = (UIImagePNGRepresentation(self.imageView.image!) as NSData?)!
            }
            
            // Save emails
            for email in self.emailTable.cells as! [EmailAddress] {
                email.vendor = self.vendor!
                print(email)
            }
            
            // Save phone numbers
            for phoneNumber in self.phoneTable.cells as! [PhoneNumber] {
                phoneNumber.vendor = self.vendor!
            }
            
            // Save address
            for address in self.addressTable.cells as! [Address] {
                address.vendor = self.vendor!
            }
            
            self.dataManager.updateCoreData()
            // Navigate back to parent view controller
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Set the height for the description field.
        let contentSize = self.descriptionField.sizeThatFits(self.descriptionField.bounds.size)
        if contentSize.height > self.descriptionFieldInitialHeight {
            self.descriptionHeight.constant = contentSize.height
        } else {
            self.descriptionHeight.constant = self.descriptionFieldInitialHeight
        }
    }
    
    func scrollToShow(view: UIView) {
        // Current Y coordinate of the bottom of the screen in the scroll view.
        let scrollViewBottomY = scrollView.contentOffset.y + self.screenHeight - scrollView.frame.origin.y
        // Current Y coordinate of the bottom of the selected view in the scroll view.
        let viewBottomY = view.frame.origin.y + view.frame.size.height
        // The distance from the bottom of the selected view to show after.
        let bufferFromBottom: CGFloat = 36
        
        if viewBottomY > scrollViewBottomY + bufferFromBottom {
            let currentScrollOffest = self.scrollView.contentOffset.y
            let distanceToScroll = viewBottomY - scrollViewBottomY + bufferFromBottom
            self.scrollView.setContentOffset(CGPoint(x: 0, y: currentScrollOffest + distanceToScroll), animated: true)
        }
    }
    
    func showError(title: String, message: String, frame: CGRect) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.scrollToShow(rect: frame)
        })
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func scrollToShow(rect: CGRect) {
        print("scrollToShow called...")
        // Current Y coordinate of the bottom of the screen in the scroll view.
        let scrollViewBottomY = scrollView.contentOffset.y + self.screenHeight - scrollView.frame.origin.y
        // Current Y coordinate of the bottom of the selected view in the scroll view.
        let viewBottomY = rect.origin.y + rect.size.height
        // The distance from the bottom of the selected view to show after.
        let bufferFromBottom: CGFloat = 20
        
        if viewBottomY > scrollViewBottomY + bufferFromBottom {
            let currentScrollOffest = self.scrollView.contentOffset.y
            let distanceToScroll = viewBottomY - scrollViewBottomY + bufferFromBottom
            self.scrollView.setContentOffset(CGPoint(x: 0, y: currentScrollOffest + distanceToScroll), animated: true)
        }
    }
}
