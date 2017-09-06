//
//  AddressTableView.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 20/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerDelegate {
    func scrollToShow(view: UIView)
}

class VendorItemEditTableView: UITableView,
    EmailDataSourceDelegate,
    PhoneDataSourceDelegate,
    AddressDataSourceDelegate,
    UITableViewDataSource,
    UITableViewDelegate {
    
    let dataManager: DataManager = Model.sharedInstance.dataManager
    
    var parentDelegate: ViewControllerDelegate!
    var type: String!
    var cells = [BaseAttribute]()
    var duplicates = [BaseAttribute]()
    var cellHeight: CGFloat!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var addButton: AddButton!
    
    func setup(type: String) {
        self.dataSource = self
        self.type = type
        
        // Get height of cell for automatic scrolling on new cell creation.
        switch self.type {
        case "email":
            self.cells.append(self.dataManager.newEmailAddress())
            self.hideAddButton()
            
            let cell = self.dequeueReusableCell(withIdentifier: "EmailCell")
            self.cellHeight = cell?.frame.size.height
            break
        case "phoneNumber":
            let cell = self.dequeueReusableCell(withIdentifier: "PhoneCell")
            self.cellHeight = cell?.frame.size.height
            break
        case "address":
            let cell = self.dequeueReusableCell(withIdentifier: "AddressCell")
            self.cellHeight = cell?.frame.size.height
            break
        default: break
        }
        
        self.setHeight()
    }
    
    func setHeight() {
        self.reloadData()
        
        // Set the height for the table.
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.contentSize.height)
        self.tableHeight.constant = self.frame.height
    }
    
    func populateFromSavedVendor(data: [BaseAttribute], type: String) {
        self.dataSource = self
        self.type = type
        
        for dataObject in data {
            // Set state
            dataObject.isNew = false
            dataObject.isGood = true
            dataObject.isSaved = true
            
            // Add to data source.
            self.cells.append(dataObject)
        }
        
        self.setHeight()
        self.showAddButton()
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: BaseEditTableViewCell!
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        switch self.type {
        case "email":
            if let emailCell = self.dequeueReusableCell(withIdentifier: "EmailCell") as? EmailTableViewCell {
                emailCell.setup()
                emailCell.object = self.cells[indexPath.row] as! EmailAddress
                emailCell.delegate = self
                cell = emailCell
            }
            break
        case "phoneNumber":
            if let phoneCell = self.dequeueReusableCell(withIdentifier: "PhoneCell") as? PhoneTableViewCell {
                print("New Phone Cell Created")
                phoneCell.setup()
                phoneCell.object = self.cells[indexPath.row] as! PhoneNumber
                phoneCell.delegate = self
                cell = phoneCell
            }
            break
        case "address":
            if let addressCell = self.dequeueReusableCell(withIdentifier: "AddressCell") as? AddressTableViewCell {
                addressCell.setup()
                addressCell.object = self.cells[indexPath.row] as! Address
                addressCell.delegate = self
                cell = addressCell
            }
            break
        default: break
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        if type == "email" {
            // If there is only 1 cell then cannot remove.
            if self.cells.count == 1
            {
                return false
            }
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let cell = self.cells[indexPath.row]
            
            if let cellIndex = self.duplicates.index(of: cell) {
                self.duplicates.remove(at: cellIndex)
            }
            self.cells.remove(at: indexPath.row)
            self.dataManager.removeVendorAttribute(object: cell)
            
            // Recheck duplicates
            self.resetNonDuplicates()
            self.toggleAddButton()
            self.setHeight()
        }
    }
    
    func isNotDuplicate(instance: BaseAttribute) -> Bool {
        print("Checking for duplicates")
        var notDuplicate: Bool = true
        
        self.resetNonDuplicates()
        
        for cell in self.cells {
            if cell.comparisonObject == instance.comparisonObject && cell != instance && notDuplicate {
                notDuplicate = false
                self.duplicates.append(instance)
            }
        }
        
        // Control add button if there are duplicates present. Not able to add a cell if there is a duplicate.
        if self.duplicates.isEmpty {
            self.addButton.errorSet = false
        } else {
            self.addButton.errorSet = true
        }
        
        return notDuplicate
    }
    
    func resetNonDuplicates() {
        // Reset any duplicates that are no longer duplicates.
        let duplicates = self.duplicates
        var count = 0

        for duplicate in duplicates {
            var duplicateFound = false
            for cell in self.visibleCells as! [BaseEditTableViewCell] {
                if duplicate.comparisonObject == cell.object.comparisonObject && duplicate != cell.object {
                    duplicateFound = true
                }
            }
            // Reset duplicate if no duplicate found.
            if duplicateFound == false {
                duplicate.resetDuplicate = true
                self.duplicates.remove(at: count)
            }
            count += 1
        }
        
        // Cycle through visible cells and set labels appropriately
        for cell in self.visibleCells  as! [BaseEditTableViewCell] {
            if cell.object.resetDuplicate {
                cell.reset()
                cell.object.resetDuplicate = false
                self.toggleAddButton()
            }
        }
    }
    
    func toggleAddButton() {
        if self.cells.count == 0 {
            self.showAddButton()
            return
        }
        var isGood = true
        for cell in self.cells {
            if !cell.isGood {
                isGood = false
            }
        }
        
        if isGood {
            if (self.cells.last?.isSaved)! {
                self.showAddButton()
            }
        } else {
            self.hideAddButton()
        }
    }
    
    func showAddButton() {
        self.addButton.show = true
    }
    
    func hideAddButton() {
        self.addButton.show = false
    }
    
    // Create new email cell in email table.
    @IBAction func addNew( sender: UIButton ) {
        // Set any new cells to non new state.
        for cell in self.cells {
            if cell.isNew {
                cell.isNew = false
            }
        }
        
        switch self.type {
        case "email":
            let newEmail = self.dataManager.newEmailAddress()
            self.cells.append(newEmail)
            break
        case "phoneNumber":
            let newPhoneNumber = self.dataManager.newPhoneNumber()
            self.cells.append(newPhoneNumber)
            break
        case "address":
            let newAddress = self.dataManager.newAddress()
            self.cells.append(newAddress)
            break
        default: break
        }
        
        self.setHeight()
        
        // Hide Button
        self.hideAddButton()
        
        // Scroll down
        self.parentDelegate.scrollToShow(view: self)
    }
    
    func checkForErrors() -> CGRect {
        for cell in self.visibleCells as! [BaseEditTableViewCell] {
            if !cell.object.isGood {
                return cell.getFrame()
            }
        }
        return CGRect()
    }
}
