//
//  ProductDetailedInfoCell.swift
//  CaseStudy
//
//  Created by Gaurang Makwana on 7/21/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailedInfoCell: UITableViewCell {
    
    @IBOutlet weak var segmentOptions: UISegmentedControl!
    @IBOutlet weak var txtDescription: UITextView!
    
    var productDetails:ProductDetails! = nil
    
    /*!
     @function    configureCell
     @abstract    This function is used to do the basic configuration of the tableviewcell.
     */
    func configureCell() {
        
        if (self.productDetails != nil) {
            updateUI()
        }
    }
    
    /*!
     @function    updateUI
     @abstract    This function is used to update the value based on the selected option.
     */
    func updateUI() {
        
        indexChanged(sender: self.segmentOptions)
        /*
        if segmentOptions.selectedSegmentIndex == SegmentOption.Description.rawValue {
             self.txtDescription.attributedText = appDelegate.stringFromHtml(string: self.productDetails.strDescription)
        
        } else if segmentOptions.selectedSegmentIndex == SegmentOption.TechSpec.rawValue {
            let colourValue = self.productDetails.strColor
            let genderValue = self.productDetails.strGender
            self.txtDescription.text = String(format: "Colour:    %@ \nGender:    %@", colourValue, genderValue)
            
        } else {
            self.txtDescription.attributedText = appDelegate.stringFromHtml(string: "Delivery details goes here.")
        }
        */
    }
    
    /*!
     @function    indexChanged
     @abstract    This function is called when user selected any section of the given options.
     */
    @IBAction func indexChanged(sender:UISegmentedControl) {
        
        switch segmentOptions.selectedSegmentIndex {
        case SegmentOption.Description.rawValue:
            self.txtDescription.attributedText = appDelegate.stringFromHtml(string: self.productDetails.strDescription)
        case SegmentOption.TechSpec.rawValue:
            
            let colourValue = self.productDetails.strColor
            let genderValue = self.productDetails.strGender
            self.txtDescription.text = String(format: "Colour:    %@ \nGender:    %@", colourValue, genderValue)
            
        case SegmentOption.Delivery.rawValue:
            self.txtDescription.attributedText = appDelegate.stringFromHtml(string: "Delivery details goes here.")
        default:
            break;
        }
    }
}
