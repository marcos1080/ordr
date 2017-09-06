//
//  ProductItemViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 1/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import UIKit
import CoreData

protocol splitViewMasterDelegate {
    func popToRootView()
}

class ProductItemEditViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate,
    UITextViewDelegate,
    EditProductItemDelegate {
    
    let coreDataManager: CoreDataManager = Model.sharedInstance.coreDataManager
    
    var slitViewMasterDelegate: splitViewMasterDelegate?
    
    // Product item object. New empty one created on newItem() or existing one loaded on editItem().
    var productItem: ProductItem!
    
    var name: String?
    var desc: String?
    var image: Data?
    var dollars: Int?
    var cents: Int?
    
    var new: Bool?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var dollarStepper: UIStepper!
    @IBOutlet weak var centStepper: UIStepper!
    
    @IBAction func save( _ sender: UIButton ) {
        if self.nameField.text == "" {
            let alertController = UIAlertController(title: "No Name Entered", message: "A new product must at the very least have a name", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil )
            alertController.addAction(action)
            
            present(alertController, animated: true, completion: nil)
        } else {
            print("save")
            
            // New Item, create product item object.
            if( productItem == nil ) {
                let entity = NSEntityDescription.entity(forEntityName: "ProductItem", in:coreDataManager.managedContext)
                self.productItem = ProductItem(entity: entity!, insertInto:coreDataManager.managedContext)
            }
            print("1")
            self.productItem.name = self.nameField.text!
            self.productItem.desc = self.descField.text
            self.productItem.image = UIImagePNGRepresentation(self.imageView.image!) as? NSData
            print("2")
            // Set price.
            let entity = NSEntityDescription.entity(forEntityName: "Money", in:coreDataManager.managedContext)
            print("2.1")
            self.productItem.price = MoneyCoreData(entity: entity!, insertInto:coreDataManager.managedContext)
            print("2.2")
            self.productItem.price!.set(Money( amount: Float( self.priceField.text! )! ) )
            print("3")
            self.coreDataManager.updateCoreData()
            print("4")
            // Navigate back to parent view controller
            if navigationController?.viewControllers.count == 1 {
                self.slitViewMasterDelegate!.popToRootView()
            } else {
                navigationController?.popViewController(animated: true)
            }
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
        
        if self.image != nil {
            self.imageView.image = UIImage(data: self.image!)
        }
        
        if self.name != nil {
            self.nameField.text = self.name!
        }
        
        if self.desc != nil {
            self.descField.text = self.desc!
        }
        
        if self.dollars == nil  {
            self.dollars = 0
        }
        self.dollarStepper.value = Double( self.dollars! )
        
        if self.cents == nil {
            self.cents = 0
        }
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
    
    func editItem( _ productItem: ProductItem ) {
        print("edit")
        
        self.productItem = productItem
        
        if let image = productItem.image {
            self.image = image as Data
        }
        
        self.name = productItem.name
        
        if let desc = productItem.desc {
            self.desc = desc
        }
        
        do {
            if let price = productItem.price {
                let price = try price.get()
                if price.sign == false {
                    self.dollars = 0 - price.dollar
                } else {
                    self.dollars = price.dollar
                }
                
                self.cents = price.cent
            } else {
                self.dollars = 0
                self.cents = 0
            }
        } catch {
            self.priceField.text = "Unknown"
        }
    }
    
    func setDelegate( _ master: ProductLineTableViewController ) {
        self.slitViewMasterDelegate = master
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
