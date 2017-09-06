//
//  PhoneVendorTableView.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 5/1/17.
//  Copyright © 2017 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class PhoneVendorTableView: UITableViewController {
    let dataManager: DataManager = Model.sharedInstance.dataManager
    var vendors: [Vendor]?
    var vendorSegueIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vendors = self.dataManager.vendors
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vendors = self.dataManager.vendors
        self.tableView.reloadData()
    }
    
    @IBAction func newVendor( _ sender: UIButton ) {
        self.performSegue(withIdentifier: "PhoneNewVendorSegue", sender: self)
    }
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.vendors!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhoneVendorCell")
        let vendor = self.vendors![indexPath.row]
        cell?.textLabel?.text = vendor.name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.vendorSegueIndex = indexPath.row
        self.performSegue(withIdentifier: "PhoneVendorSegue", sender: self)
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
            
            self.tableView.reloadData()
        }
    }
    
    // Segue to product line table view
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {        
        if segue.identifier == "PhoneVendorSegue"
        {
            if let destinationVC = segue.destination as? PhoneVendorDisplayViewController {
                destinationVC.vendor = self.vendors?[self.vendorSegueIndex!]
            }
        }
        
        if segue.identifier == "PhoneNewVendorSegue"
        {
            if let destinationVC = segue.destination as? PhoneVendorDisplayViewController {
                destinationVC.vendor = self.vendors?[self.vendorSegueIndex!]
            }
        }
    }
}
