//
//  PhoneProductLineViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 6/1/17.
//  Copyright © 2017 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class PhoneProductLineViewController: UITableViewController {
    
    let dataManager: DataManager = Model.sharedInstance.dataManager
    
    var productLine: ProductLine!
    var productItems: [ProductItem]?
    var segueProductIndex: Int?
    
    @IBAction func newProduct( _ sender: UIButton ) {
        self.performSegue(withIdentifier: "PhoneProductLineToEditProductSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let products = self.productLine.products!.allObjects as? [ProductItem] {
            self.productItems = products
        }
        self.tableView.reloadData()
    }
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.productItems != nil {
            return (self.productItems?.count)!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhoneProductLineCell")
        let productItem = self.productItems![indexPath.row]
        cell?.textLabel?.text = productItem.name
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.segueProductIndex = indexPath.row
        self.performSegue(withIdentifier: "PhoneShowProductItemSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    // Segue to edit product item
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        if segue.identifier == "PhoneProductLineToEditProductSegue"
        {
            if let destinationVC = segue.destination as? PhoneEditProductViewController {
                destinationVC.productItem = self.dataManager.newProductItem()
                destinationVC.productLine = self.productLine
            }
        }
        
        if segue.identifier == "PhoneShowProductItemSegue"
        {
            if let destinationVC = segue.destination as? PhoneDisplayProductViewController {
                destinationVC.productItem = self.productItems?[self.segueProductIndex!]
            }
        }
    }
    
    func addToProductLine(product: ProductItem) {
        product.productLine = self.productLine
    }
}
