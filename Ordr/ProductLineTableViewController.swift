//
//  ProductLineTableViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 1/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol ProductItemNavigationDelegate {
    func setItem( _ productItem: ProductItem )
    func newItem( _ master: ProductLineTableViewController )
}

class ProductLineTableViewController: UITableViewController, splitViewMasterDelegate {
    
    var productDelegate: ProductItemNavigationDelegate!
    let coreDataManager: CoreDataManager = Model.sharedInstance.coreDataManager
    
    var productItems: [ProductItem]?
    
    @IBAction func newProduct( _ sender: UIButton ) {
        if let productItemViewController = self.productDelegate as? ProductItemNavigationController {
            self.productDelegate.newItem( self )
            self.splitViewController?.showDetailViewController(productItemViewController, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFromCoreData()
        
        self.productDelegate = self.splitViewController?.viewControllers.last as! ProductItemNavigationController
        
        // Set product item view to the first item.
        if ( productItems!.count > 0 ) {
            self.productDelegate.setItem( productItems![0] )
        } else {
            self.productDelegate.newItem( self )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFromCoreData()
        self.tableView.reloadData()
    }
    
    func loadFromCoreData()
    {
        print("\nLoading locations from core data")
        let retreivedProducts = coreDataManager.getEntityFromCoreData("ProductItem")
        print("\tproducts in core data: \(retreivedProducts.count)")
        
        if let retreivedProducts = retreivedProducts as? [ProductItem]
        {
            self.productItems = retreivedProducts
        }
    }
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.productItems!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let productItem = self.productItems![indexPath.row]
        
        cell?.textLabel?.text = productItem.name
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let productItemViewController = self.productDelegate as? ProductItemNavigationController {
            self.productDelegate.setItem( self.productItems![indexPath.row] )
            self.splitViewController?.showDetailViewController(productItemViewController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func popToRootView() {
        loadFromCoreData()
        self.tableView.reloadData()
        
        self.productDelegate.setItem( productItems!.last! )
        
        // Iphone, navigate back to table view.
        if self.navigationController?.viewControllers.count > 1 {
            self.navigationController?.popToRootViewController( animated: true )
        }
    }
}
