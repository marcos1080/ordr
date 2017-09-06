//
//  VendorTableViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 24/12/16.
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


protocol VendorItemNavigationDelegate {
    func setItem( _ vendor: Vendor )
    func newItem( _ master: VendorItemTableViewController )
}

class VendorItemTableViewController: UITableViewController, VendorSplitViewMasterDelegate, VendorDelegate {
    
    var vendorDelegate: VendorItemNavigationDelegate!
    let dataManager: DataManager = Model.sharedInstance.dataManager
    
    var vendors: [Vendor]?
    
    @IBAction func newVendor( _ sender: UIButton ) {
        self.showEditViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vendors = self.dataManager.vendors
        
        self.vendorDelegate = self.splitViewController?.viewControllers.last as! VendorItemNavigationController
        
        // Set product item view to the first item.
        if ( vendors!.count > 0 ) {
            self.vendorDelegate.setItem( vendors![0] )
        } else {
            self.vendorDelegate.newItem( self )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vendors = self.dataManager.vendors
        self.tableView.reloadData()
    }
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.vendors!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "VendorCell")
        
        let vendor = self.vendors![indexPath.row]
        
        cell?.textLabel?.text = vendor.name
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.displayVendor(vendor: self.vendors![indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let vendor = self.vendors![indexPath.row]
            if self.dataManager.removeVendor(vendor: vendor) {
                self.vendors?.remove(at: indexPath.row)
            }
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                if self.vendors?.count > 0 {
                    // Show the next vendor.
                    let rowCount = self.vendors!.count
                    var targetRow = indexPath.row
                    if targetRow >= rowCount {
                        targetRow -= 1
                    }
                    self.displayVendor(vendor: self.vendors![targetRow])
                } else {
                    // No vendors, show edit view.
                    self.showEditViewController()
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func displayVendor(vendor: Vendor) {
        if let vendorItemViewController = self.vendorDelegate as? VendorItemNavigationController {
            self.vendorDelegate.setItem( vendor )
            self.splitViewController?.showDetailViewController(vendorItemViewController, sender: nil)
        }
    }
    
    func showEditViewController() {
        if let vendorItemViewController = self.vendorDelegate as? VendorItemNavigationController {
            self.vendorDelegate.newItem( self )
            self.splitViewController?.showDetailViewController(vendorItemViewController, sender: nil)
        }
    }
    
    func popToRootView() {
        self.vendors = self.dataManager.vendors
        self.tableView.reloadData()
        
        self.vendorDelegate.setItem( vendors!.last! )
        
        // Iphone, navigate back to table view.
        if self.navigationController?.viewControllers.count > 1 {
            self.navigationController?.popToRootViewController( animated: true )
        }
    }
    
    // Initiate segue to product line table
    func showProductLine(productLine: ProductLine) {
        print(productLine.name)
        self.performSegue(withIdentifier: "VendorToProductLineSegue", sender: self)
    }
    
    // Segue to product line table view
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
//        if segue.identifier == "EditVendorSegue"
//        {
//            if let destinationVC = segue.destination as? VendorItemEditViewController {
//                destinationVC.editItem( self.vendor )
//            }
//        }
        
        if segue.identifier == "VendorToProductLineSegue"
        {
            print("yo2")
        }
    }
}
