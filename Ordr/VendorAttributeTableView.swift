//
//  VendorAttributeTableView.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 28/12/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import UIKit

class VendorAttributeTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var tableData = [[String: String]]()
    var type: String!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    func setDataSource(data: [AnyObject]) {
        self.tableData.removeAll()
        
        if let data = data as? [EmailAddress] {
            self.type = "email"
            for email in data {
                var emailDictionary = [String:String]()
                if let name = email.name {
                    emailDictionary["name"] = name
                }
                emailDictionary["address"] = email.address
                self.tableData.append(emailDictionary)
            }
        }
        
        if let data = data as? [PhoneNumber] {
            self.type = "phoneNumber"
            for phoneNumber in data {
                var phoneDictionary = [String:String]()
                if let name = phoneNumber.name {
                    phoneDictionary["name"] = name
                }
                phoneDictionary["number"] = phoneNumber.number
                self.tableData.append(phoneDictionary)
            }
        }
        
        if let data = data as? [Address] {
            self.type = "address"
            for address in data {
                var addressDictionary = [String:String]()
                if let name = address.name {
                    addressDictionary["name"] = name
                }
                addressDictionary["streetLineOne"] = address.streetLineOne
                if let streetLineTwo = address.streetLineTwo {
                    addressDictionary["streetLineTwo"] = streetLineTwo
                }
                addressDictionary["town"] = address.town
                addressDictionary["state"] = address.state
                addressDictionary["postCode"] = address.postCode
                if let country = address.country {
                    addressDictionary["country"] = country
                }
                self.tableData.append(addressDictionary)
            }
        }
        self.dataSource = self
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 66
        self.reloadData()
        self.setHeight()
    }
    
    func setHeight() {
        var height: CGFloat = 0
        for cell in self.visibleCells {
            height += cell.bounds.size.height
        }
        // Set the height for the table.
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.contentSize.height)
        self.tableHeight.constant = height
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell!
        
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        switch self.type {
        case "email":
            if let emailCell = self.dequeueReusableCell(withIdentifier: "EmailDisplayCell") as? EmailDisplayTableViewCell {
                let email = self.tableData[indexPath.row]
                if let name = email["name"] {
                    emailCell.nameLabel.text = name
                    emailCell.showName()
                } else {
                    emailCell.hideName()
                }
                emailCell.addressLabel.text = email["address"]
                cell = emailCell
            }
            break
        case "phoneNumber":
            if let phoneCell = self.dequeueReusableCell(withIdentifier: "PhoneDisplayCell") as? PhoneNumberDisplayTableViewCell {
                let phoneNumber = self.tableData[indexPath.row]
                if let name = phoneNumber["name"] {
                    phoneCell.nameLabel.text = name
                    phoneCell.showName()
                } else {
                    phoneCell.hideName()
                }
                phoneCell.numberLabel.text = phoneNumber["number"]
                cell = phoneCell
            }
            break
        case "address":
            if let addressCell = self.dequeueReusableCell(withIdentifier: "AddressDisplayCell") as? AddressDisplayTableViewCell {
                let address = self.tableData[indexPath.row]
                if let name = address["name"] {
                    addressCell.nameLabel.text = name
                    addressCell.showName()
                } else {
                    addressCell.hideName()
                }
                addressCell.streetLineOneLabel.text = address["streetLineOne"]
                if let streetLineTwo = address["streetLineTwo"] {
                    addressCell.streetLineTwoLabel.text = streetLineTwo
                    addressCell.showStreetLineTwo()
                } else {
                    addressCell.hideStreetLineTwo()
                }
                addressCell.townLabel.text = address["town"]
                addressCell.stateLabel.text = address["state"]
                addressCell.stateLabel.sizeToFit()
                addressCell.stateLabelWidth.constant = addressCell.stateLabel.frame.size.width
                addressCell.postCodeLabel.text = address["postCode"]
                if let country = address["country"] {
                    addressCell.countryLabel.text = country
                    addressCell.showCountry()
                } else {
                    addressCell.hideCountry()
                }
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
}
