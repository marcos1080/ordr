//
//  AddButton.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 20/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class AddButton: UIButton {
    var errorSet: Bool = false {
        didSet {
            if errorSet {
                if self.show {
                    self.hideAddButton()
                }
            } else {
                if self.show {
                    self.showAddButton()
                }
            }
        }
    }
    
    var show: Bool = true {
        didSet {
            if show && !errorSet {
                self.showAddButton()
            } else {
                self.hideAddButton()
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showAddButton() {
        if self.isHidden == true {
            self.alpha = 0.0
            self.isHidden = false
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.alpha = 1.0
            })
        }
    }
    
    func hideAddButton() {
        if self.isHidden == false {
            UIView.animate(withDuration: 0.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.alpha = 0.0
            }, completion: {
                finished in
                self.isHidden = true
            })
        }
    }
}
