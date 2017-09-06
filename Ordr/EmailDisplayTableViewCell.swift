//
//  EmailDisplayTableViewCell.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 28/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class EmailDisplayTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopGap: NSLayoutConstraint!
    var nameHeightOriginal: CGFloat?
    var nameLabelHeightOriginal: CGFloat?
    var nameLabelTopGapOriginal: CGFloat?
    
    func hideName() {
        if self.nameHeightOriginal == nil {
            self.nameHeightOriginal = self.nameHeight.constant
        }
        if self.nameLabelHeightOriginal == nil {
            self.nameLabelHeightOriginal = self.nameLabelHeight.constant
        }
        if self.nameLabelTopGapOriginal == nil {
            self.nameLabelTopGapOriginal = self.nameLabelTopGap.constant
        }
        self.nameHeight.constant = 0
        self.nameLabelHeight.constant = 0
        self.nameLabelTopGap.constant = 0
    }
    
    func showName() {
        if self.nameHeightOriginal != nil {
            self.nameHeight.constant = self.nameHeightOriginal!
        }
        if self.nameLabelHeightOriginal != nil {
            self.nameLabelHeight.constant = self.nameLabelHeightOriginal!
        }
        if self.nameLabelTopGapOriginal != nil {
            self.nameLabelTopGap.constant = self.nameLabelTopGapOriginal!
        }
    }
}
