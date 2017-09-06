//
//  VendorViewProductLineTableView.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 4/1/17.
//  Copyright © 2017 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

protocol VendorDelegate {
    func showProductLine(productLine: ProductLine)
}

class VendorViewProductLineTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var productLines = [ProductLine]()
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var dataManager: DataManager!
    var segueDelegate: VendorDelegate!
    
    func setup(dataManager: DataManager) {
        self.dataSource = self
        self.delegate = self
        self.dataManager = dataManager
        self.setHeight()
    }
    
    func setDelegate(delegate: PhoneVendorDisplayViewController) {
        self.segueDelegate = delegate
    }
    
    func createNew(name: String) -> ProductLine {
        let newProductLineObject: ProductLine = self.dataManager.newProductLine()
        newProductLineObject.name = name
        self.productLines.append(newProductLineObject)
        self.setHeight()
        return newProductLineObject
    }
    
    func populateFromVendor(data: [ProductLine]) {
        self.productLines = data
        self.setHeight()
    }
    
    func nameAlreadyUsed(name: String) -> Bool {
        for productLine in self.productLines {
            if productLine.name == name {
                return true
            }
        }
        return false
    }
    
    func setHeight() {
        self.reloadData()
        var height: CGFloat = 0
        for cell in self.visibleCells {
            height += cell.bounds.size.height
        }
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.contentSize.height)
        // Set the height for the table.
        self.tableHeight.constant = self.frame.height
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.productLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.dequeueReusableCell(withIdentifier: "VendorProductLineCell")
        cell?.textLabel?.text = self.productLines[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let productLine = self.productLines[indexPath.row]
        self.segueDelegate.showProductLine(productLine: productLine)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let productLine = self.productLines[indexPath.row]
            
            if productLine.products != nil {
                // Ask for confirmation
                let alertController = UIAlertController(title: "Remove Product Line", message: "Product Line Is Not Empty!/nAre You Sure You Want To Delete It?", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    self.productLines.remove(at: indexPath.row)
                    self.setHeight()
                    _ = self.dataManager.removeProductLine(productLine: productLine)
                })
                alertController.addAction(action)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                
                self.viewController()?.present(alertController, animated: true, completion: nil)
            } else {
                // Empty just remove.
                self.productLines.remove(at: indexPath.row)
                self.setHeight()
                _ = self.dataManager.removeProductLine(productLine: productLine)
            }
        }
    }
}
