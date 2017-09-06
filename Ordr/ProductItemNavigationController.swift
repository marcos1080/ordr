//
//  ProductItemNavigationController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 1/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ProductItemDelegate {
    func setItem( _ productItem: ProductItem )
}

protocol EditProductItemDelegate {
    func setDelegate( _ master: ProductLineTableViewController )
}

class ProductItemNavigationController: UINavigationController, ProductItemNavigationDelegate {
    
    var productDelegate: ProductItemDelegate?
    var editProductDelegate: EditProductItemDelegate?
    
    // These two functions set the root view controller from the story board using IDs.
    func setItem( _ productItem: ProductItem ) {
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "ProductItem") as? ProductItemViewController {
            self.viewControllers.removeAll()
            self.viewControllers.append( resultController )
            
            self.productDelegate = self.viewControllers.first as? ProductItemViewController
            self.productDelegate?.setItem( productItem )
        }
    }
    
    func newItem( _ masterView: ProductLineTableViewController ) {
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "NewProduct") as? ProductItemEditViewController {
            self.viewControllers.removeAll()
            self.viewControllers.append( resultController )
            
            self.editProductDelegate = self.viewControllers.first as? ProductItemEditViewController
            self.editProductDelegate?.setDelegate( masterView )
        }
    }
}
