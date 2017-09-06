//
//  PhoneEditProductViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 6/1/17.
//  Copyright © 2017 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class PhoneEditProductViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate,
    UITextViewDelegate {
    
    var dataManager: DataManager = Model.sharedInstance.dataManager
    var productLine: ProductLine!
    var productItem: ProductItem!
    var dollars: Int?
    var cents: Int?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var dollarStepper: UIStepper!
    @IBOutlet weak var centStepper: UIStepper!
    
    @IBAction func save( _ sender: UIButton ) {
        // Error checking
        if self.nameField.text == "" {
            let alertController = UIAlertController(title: "No Name Entered", message: "A new product must at the very least have a name", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil )
            alertController.addAction(action)
            
            present(alertController, animated: true, completion: nil)
        } else {
            print("save")
            
            self.productItem.name = self.nameField.text!
            self.productItem.desc = self.descField.text
            self.productItem.image = UIImagePNGRepresentation(self.imageView.image!) as NSData?
            
            // Set price.
            self.productItem.price = dataManager.newMoney()
            self.productItem.price!.set(Money( amount: Float( self.priceField.text! )! ) )
            
            if self.productItem.productLine == nil {
                self.productItem.productLine = self.productLine
            }
            self.dataManager.updateCoreData()
            
            // Navigate back to parent view controller
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func editImage( _ sender: UIView ) {
        let alertController = UIAlertController(title: "Load Photo", message: "", preferredStyle: .actionSheet)
        
        // Camera handler
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        alertController.addAction(cameraAction)
        
        // Photo library handler
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        alertController.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Enable for iPads.
        let popOver = alertController.popoverPresentationController
        popOver?.sourceView  = sender as UIView
        popOver?.sourceRect = (sender as UIView).bounds
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.any
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func dollarStepper( _ sender: UIStepper ) {
        self.dollars = Int( sender.value )
        self.updatePrice()
    }
    
    @IBAction func centStepper( _ sender: UIStepper ) {
        self.cents = Int( sender.value )
        self.updatePrice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = self.productItem.image {
            self.imageView.image = UIImage(data: image as Data)
        }
        
        if !self.productItem.name.isEmpty {
            self.nameField.text = self.productItem.name
        }
        
        if let desc = self.productItem.desc {
            self.descField.text = desc
        }
        
        if self.dollars == nil  {
            self.dollars = 0
        }
        
        if self.cents == nil {
            self.cents = 0
        }
        
        // Set money field values
        self.dollarStepper.value = Double( self.dollars! )
        self.centStepper.value = Double( self.cents! )
        self.centStepper.maximumValue = 99
        
        self.updatePrice()
        
        // Add border to descField
        self.descField.layer.borderWidth = 0.3
        self.descField.layer.borderColor = UIColor.lightGray.cgColor
        self.descField.layer.cornerRadius = 5
        
        // Add delegate to allow for dismissal of keyboard on pressing return.
        self.nameField.delegate = self
        self.priceField.delegate = self
        self.descField.delegate = self
        
        // Add tap guesture to close keyboard on tap.
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProductItemEditViewController.userTappedBackground(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.imageView.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    func updatePrice() {
        self.priceField.text = String( format: "%d.%0.2d", self.dollars!, self.cents! )
    }
    
    // Dismiss keyboard when return key is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // Dismiss keyboard by tapping anywhere outside the text field.
    func userTappedBackground(_ sender: UIView) {
        self.detailsView.endEditing(true)
    }
}
