//
//  VendorItemNavigationController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 24/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

protocol VendorItemDelegate {
    func setItem( _ productItem: Vendor )
}

protocol EditVendorItemDelegate {
    func setDelegate( _ master: VendorItemTableViewController )
}

class VendorItemNavigationController: UINavigationController, VendorItemNavigationDelegate {
    
    var vendorDelegate: VendorItemDelegate?
    var editVendorDelegate: EditVendorItemDelegate?
    
    // These two functions set the root view controller from the story board using IDs.
    func setItem( _ vendor: Vendor ) {
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "VendorItem") as? VendorItemViewController {
            self.viewControllers.removeAll()
            self.viewControllers.append( resultController )
            
            self.vendorDelegate = self.viewControllers.first as? VendorItemViewController
            self.vendorDelegate?.setItem( vendor )
        }
    }
    
    func newItem( _ masterView: VendorItemTableViewController ) {
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "NewVendor") as? VendorItemEditViewController {
            self.viewControllers.removeAll()
            self.viewControllers.append( resultController )
            
            self.editVendorDelegate = self.viewControllers.first as? VendorItemEditViewController
            self.editVendorDelegate?.setDelegate( masterView )
        }
    }
}
