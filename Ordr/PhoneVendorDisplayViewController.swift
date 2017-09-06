//
//  PhoneVendorDisplayViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 5/1/17.
//  Copyright © 2017 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class PhoneVendorDisplayViewController: UIViewController, VendorDelegate {
    var vendor: Vendor!
    var dataManager: DataManager = Model.sharedInstance.dataManager
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTable: VendorAttributeTableView!
    
    @IBOutlet weak var phoneNumberTable: VendorAttributeTableView!
    @IBOutlet weak var phoneLabelViewHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneLabelTopGap: NSLayoutConstraint!
    @IBOutlet weak var phoneLabelBottomGap: NSLayoutConstraint!
    var phoneLabelViewOriginalHeight: CGFloat?
    var phoneLabelOriginalHeight: CGFloat?
    var phoneLabelTopGapOriginalHeight: CGFloat?
    var phoneLabelBottomGapOriginalHeight: CGFloat?
    
    @IBOutlet weak var addressTable: VendorAttributeTableView!
    @IBOutlet weak var addressLabelViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var addressLabelTopGap: NSLayoutConstraint!
    @IBOutlet weak var addressLabelBottomGap: NSLayoutConstraint!
    var addressLabelViewOriginalHeight: CGFloat?
    var addressLabelOriginalHeight: CGFloat?
    var addressLabelTopGapOriginalHeight: CGFloat?
    var addressLabelBottomGapOriginalHeight: CGFloat?
    
    // Vendor line table outlets.
    @IBOutlet weak var productLineTable: VendorViewProductLineTableView!
    var segueProductLine: ProductLine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productLineTable.setup(dataManager: self.dataManager)
        self.productLineTable.setDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
    }
    
    func refresh() {
        if( self.vendor != nil ) {
            // Show/Hide Image
            if let image = self.vendor.image as? Data {
                self.imageView.image = UIImage(data: image)
                self.imageViewHeight.constant = self.view.frame.size.width
            } else {
                imageViewHeight.constant = 0
            }
            self.name.text = vendor.name
            
            // Show/Hide description
            if let desc = self.vendor.desc {
                self.desc.text = desc
                self.desc.sizeToFit()
                self.descHeight.constant = self.desc.frame.size.height
            } else {
                self.descHeight.constant = 0
            }
            
            // There will always be more than 0 emails.
            if self.vendor.emailAddresses.count > 0 {
                print("Number of emails: \(self.vendor.emailAddresses.count)")
                if let emails = self.vendor.emailAddresses.allObjects as? [EmailAddress] {
                    self.emailTable.setDataSource(data: emails)
                }
            }
            
            // Show/Hide phone numbers
            if (self.vendor.phoneNumbers?.count)! > 0 {
                print("Number of phone numbers: \(self.vendor.phoneNumbers?.count)")
                if let phoneNumbers = self.vendor.phoneNumbers?.allObjects as? [PhoneNumber] {
                    self.phoneNumberTable.setDataSource(data: phoneNumbers)
                    self.showPhoneLabel()
                }
            } else {
                // Hide table if no phone numbers present
                self.phoneNumberTable.tableHeight.constant = 0
                self.hidePhoneLabel()
            }
            
            // Show/Hide addresses
            if (self.vendor.addresses?.count)! > 0 {
                print("Number of addresses: \(self.vendor.addresses?.count)")
                if let addresses = self.vendor.addresses?.allObjects as? [Address] {
                    self.addressTable.setDataSource(data: addresses)
                    self.showAddressLabel()
                }
            } else {
                // Hide table if no addresses present
                self.addressTable.tableHeight.constant = 0
                self.hideAddressLabel()
            }
            
            // Show product lines.
            if (self.vendor.productLines?.count)! > 0 {
                print("Number of product lines: \(self.vendor.productLines?.count)")
                if let productLines = self.vendor.productLines?.allObjects as? [ProductLine] {
                    self.productLineTable.populateFromVendor(data: productLines)
                }
            }
        }
    }
    
    func showPhoneLabel() {
        // Show label
        if self.phoneLabelViewOriginalHeight != nil {
            self.phoneLabelViewHeight.constant = self.phoneLabelViewOriginalHeight!
        }
        if self.phoneLabelOriginalHeight != nil {
            self.phoneLabelHeight.constant = self.phoneLabelOriginalHeight!
        }
        if self.phoneLabelTopGapOriginalHeight != nil {
            self.phoneLabelTopGap.constant = self.phoneLabelTopGapOriginalHeight!
        }
        if self.phoneLabelBottomGapOriginalHeight != nil {
            self.phoneLabelBottomGap.constant = self.phoneLabelBottomGapOriginalHeight!
        }
    }
    
    func hidePhoneLabel() {
        // Save original values for restoring.
        if self.phoneLabelViewOriginalHeight == nil {
            self.phoneLabelViewOriginalHeight = self.phoneLabelViewHeight.constant
        }
        if self.phoneLabelOriginalHeight == nil {
            self.phoneLabelOriginalHeight = self.phoneLabelHeight.constant
        }
        if self.phoneLabelTopGapOriginalHeight == nil {
            self.phoneLabelTopGapOriginalHeight = self.phoneLabelTopGap.constant
        }
        if self.phoneLabelBottomGapOriginalHeight == nil {
            self.phoneLabelBottomGapOriginalHeight = self.phoneLabelBottomGap.constant
        }
        
        // Hide Label
        self.phoneLabelHeight.constant = 0
        self.phoneLabelViewHeight.constant = 0
        self.phoneLabelTopGap.constant = 0
        self.phoneLabelBottomGap.constant = 0
    }
    
    func showAddressLabel() {
        // Show label
        if self.addressLabelViewOriginalHeight != nil {
            self.addressLabelViewHeight.constant = self.addressLabelViewOriginalHeight!
        }
        if self.addressLabelOriginalHeight != nil {
            self.addressLabelHeight.constant = self.addressLabelOriginalHeight!
        }
        if self.addressLabelTopGapOriginalHeight != nil {
            self.addressLabelTopGap.constant = self.addressLabelTopGapOriginalHeight!
        }
        if self.addressLabelBottomGapOriginalHeight != nil {
            self.addressLabelBottomGap.constant = self.addressLabelBottomGapOriginalHeight!
        }
    }
    
    func hideAddressLabel() {
        // Save original values for restoring.
        if self.addressLabelViewOriginalHeight == nil {
            self.addressLabelViewOriginalHeight = self.addressLabelViewHeight.constant
        }
        if self.addressLabelOriginalHeight == nil {
            self.addressLabelOriginalHeight = self.addressLabelHeight.constant
        }
        if self.addressLabelTopGapOriginalHeight == nil {
            self.addressLabelTopGapOriginalHeight = self.addressLabelTopGap.constant
        }
        if self.addressLabelBottomGapOriginalHeight == nil {
            self.addressLabelBottomGapOriginalHeight = self.addressLabelBottomGap.constant
        }
        
        // Hide Label
        self.addressLabelHeight.constant = 0
        self.addressLabelViewHeight.constant = 0
        self.addressLabelTopGap.constant = 0
        self.addressLabelBottomGap.constant = 0
    }
    
    // Segue to edit product item
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        if segue.identifier == "EditVendorSegue"
        {
            if let destinationVC = segue.destination as? VendorItemEditViewController {
                destinationVC.editItem( self.vendor )
            }
        }
        
        if segue.identifier == "PhoneVendorToProductLineSegue"
        {
            if let destinationVC = segue.destination as? PhoneProductLineViewController {
                destinationVC.productLine = self.segueProductLine
            }
        }
    }
    
    func showProductLine(productLine: ProductLine) {
        self.segueProductLine = productLine
        self.performSegue(withIdentifier: "PhoneVendorToProductLineSegue", sender: self)
    }
    
    // IBActions
    @IBAction func editProduct( _ sender: UIButton ) {
        self.performSegue(withIdentifier: "EditVendorSegue", sender: self)
    }
    
    @IBAction func addNewProductLine(sender: UIButton) {
        askForName(title: "Enter Name", message: "This Product Line Needs a Title", error: false)
    }
    
    func askForName(title: String, message: String, error: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            if error {
                textField.attributedPlaceholder = NSAttributedString(string:"Enter Name Here..", attributes: [NSForegroundColorAttributeName: UIColor.errorTextColor])
            } else {
                textField.placeholder = "Enter Name Here..";
            }
        })
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            // Error check and save
            let textField = alertController.textFields![0] as UITextField
            if (textField.text?.isEmpty)! {
                self.askForName(title: "Enter Name", message: "The Title Cannot Be Empty!", error: true)
            } else if self.productLineTable.nameAlreadyUsed(name: textField.text!) {
                self.askForName(title: "Enter Name", message: "The Title Has Already Been Used!", error: true)
            } else {
                // Set relationship
                self.productLineTable.createNew(name: textField.text!).vendor = self.vendor
                self.dataManager.updateCoreData()
            }
        })
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
}
