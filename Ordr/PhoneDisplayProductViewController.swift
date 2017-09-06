//
//  PhoneDisplayProductViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 6/1/17.
//  Copyright © 2017 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class PhoneDisplayProductViewController: UIViewController {
    
    var productItem: ProductItem!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh()
        
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
    }
    
    func refresh() {
        if( self.productItem != nil ) {
            self.image.image = UIImage(data: productItem.image! as Data)
            self.name.text = productItem.name
            self.desc.text = productItem.desc
            do {
                if let price = productItem.price {
                    
                    self.price.text = String( format: "Unit Price: $%@", try price.get().string() )
                } else {
                    self.price.text = "N/A"
                }
                //print( try productItem.price!.get().string() )
                print( productItem )
            } catch {
                self.price.text = "Unknown"
            }
            
            // Resize description
            self.desc.sizeToFit()
            self.descHeight.constant = self.desc.frame.height
        }
    }
    
    @IBAction func editProduct( _ sender: UIButton ) {
        self.performSegue(withIdentifier: "PhoneEditProductSegue", sender: self)
    }
    
    // Segue to edit product item
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        if segue.identifier == "PhoneEditProductSegue"
        {
            if let destinationVC = segue.destination as? PhoneEditProductViewController {
                destinationVC.productItem = self.productItem
            }
        }
    }
}

