//
//  ProductItemViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 4/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class ProductItemViewController: UIViewController, ProductItemDelegate {
    
    var productItem: ProductItem!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    
//    override func viewWillAppear(animated: Bool) {
//       self.setItem( self.productItem )
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh()
        
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
    }
    
    func setItem( _ productItem: ProductItem ) {
        self.productItem = productItem
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
        self.performSegue(withIdentifier: "EditProductSegue", sender: self)
    }
    
    // Segue to edit product item
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        if segue.identifier == "EditProductSegue"
        {
            if let destinationVC = segue.destination as? ProductItemEditViewController {
                destinationVC.editItem( self.productItem )
            }
        }
    }
}

