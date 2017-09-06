//
//  ProductLineSplitViewController.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 1/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class ProductLineSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        self.delegate = self
    }
    
    // Show the master view first. Needs the delegate to be set!!
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool{
        return true
    }

}
