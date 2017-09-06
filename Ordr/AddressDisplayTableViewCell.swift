//
//  AddressDisplayTableViewCell.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 28/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class AddressDisplayTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopGap: NSLayoutConstraint!
    @IBOutlet weak var streetLineOneLabel: UILabel!
    @IBOutlet weak var streetLineTwoLabel: UILabel!
    @IBOutlet weak var streetLineTwoHeight: NSLayoutConstraint!
    @IBOutlet weak var streetLineTwoLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var streetLineTwoLabelTopGap: NSLayoutConstraint!
    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var postCodeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryHeight: NSLayoutConstraint!
    @IBOutlet weak var countryLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var countryLabelBottomGap: NSLayoutConstraint!
    
    var nameHeightOriginal: CGFloat?
    var nameLabelHeightOriginal: CGFloat?
    var nameLabelTopGapOriginal: CGFloat?
    var streetLineTwoHeightOriginal: CGFloat?
    var streetLineTwoLabelHeightOriginal: CGFloat?
    var streetLineTwoLabelTopGapOriginal: CGFloat?
    var countryHeightOriginal: CGFloat?
    var countryLabelHeightOriginal: CGFloat?
    var countryLabelBottomGapOriginal: CGFloat?
    
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
    
    func hideStreetLineTwo() {
        if self.streetLineTwoHeightOriginal == nil {
            self.streetLineTwoHeightOriginal = self.streetLineTwoHeight.constant
        }
        if self.streetLineTwoLabelHeightOriginal == nil {
            self.streetLineTwoLabelHeightOriginal = self.streetLineTwoLabelHeight.constant
        }
        if self.streetLineTwoLabelTopGapOriginal == nil {
            self.streetLineTwoLabelTopGapOriginal = self.streetLineTwoLabelTopGap.constant
        }
        self.streetLineTwoHeight.constant = 0
        self.streetLineTwoLabelHeight.constant = 0
        self.streetLineTwoLabelTopGap.constant = 0
    }
    
    func showStreetLineTwo() {
        if self.streetLineTwoHeightOriginal != nil {
            self.streetLineTwoHeight.constant = self.streetLineTwoHeightOriginal!
        }
        if self.streetLineTwoLabelHeightOriginal != nil {
            self.streetLineTwoLabelHeight.constant = self.streetLineTwoLabelHeightOriginal!
        }
        if self.streetLineTwoLabelTopGapOriginal != nil {
            self.streetLineTwoLabelTopGap.constant = self.streetLineTwoLabelTopGapOriginal!
        }
    }
    
    func hideCountry() {
        if self.countryHeightOriginal == nil {
            self.countryHeightOriginal = self.countryHeight.constant
        }
        if self.countryLabelHeightOriginal == nil {
            self.countryLabelHeightOriginal = self.countryLabelHeight.constant
        }
        if self.countryLabelBottomGapOriginal == nil {
            self.countryLabelBottomGapOriginal = self.countryLabelBottomGap.constant
        }
        self.countryHeight.constant = 0
        self.countryLabelHeight.constant = 0
        self.countryLabelBottomGap.constant = 0
    }
    
    func showCountry() {
        if self.countryHeightOriginal != nil {
            self.countryHeight.constant = self.countryHeightOriginal!
        }
        if self.countryLabelHeightOriginal != nil {
            self.countryLabelHeight.constant = self.countryLabelHeightOriginal!
        }
        if self.countryLabelBottomGapOriginal != nil {
            self.countryLabelBottomGap.constant = self.countryLabelBottomGapOriginal!
        }
    }
}
