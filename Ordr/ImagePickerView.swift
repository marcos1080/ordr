//
//  ImagePickerView.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 24/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    // Set image set flag
    var imageSet: Bool = false
    
    func setup() {
        // Add tap guesture to close keyboard on tap.
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImagePickerView.changeImage(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func changeImage(_ sender: UIView) {
        print("1")
        let alertController = UIAlertController(title: "Load Photo", message: "", preferredStyle: .actionSheet)
        
        // Camera handler
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = true
                self.viewController()?.present(imagePicker, animated: true, completion: nil)
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
                self.viewController()?.present(imagePicker, animated: true, completion: nil)
            }
        })
        alertController.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        print("2")
        // Enable for iPads.
        if let presenter = alertController.popoverPresentationController {
            if let sender = self.imageView as? UIView {
                presenter.sourceView = sender
                presenter.sourceRect = sender.bounds
                presenter.permittedArrowDirections = UIPopoverArrowDirection.up
            }
        }
        self.viewController()?.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.imageView.image = image
        self.imageSet = true
        self.viewController()?.dismiss(animated: true, completion: nil);
    }
}
