//
//  BaseEditTableViewCell.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 29/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class BaseEditTableViewCell: UITableViewCell {
    var object: BaseAttribute {
        set {
            
        }
        get {
            return self.object
        }
    }
    
    func reset() {
    }
    
    func setup() {
    }
    
    func getFrame() -> CGRect {
        return self.frame
    }
}
