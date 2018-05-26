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
    
    var productDetail: ProductDetail? {
        didSet {
            guard let productDetail = productDetail else {
                return
            }
            updateUI(sender: self.segmentOptions, productDetail: productDetail)
        }
    }
    
    /*!
     @function    updateUI
     @abstract    This function is used to update the value based on the selected option.
     */
    func updateUI(sender:UISegmentedControl, productDetail: ProductDetail) {
        
        //indexChanged(sender: self.segmentOptions)
        switch sender.selectedSegmentIndex {
        case SegmentOption.Description.rawValue:
            self.txtDescription.attributedText = appDelegate.stringFromHtml(string: productDetail.strDescription)
        case SegmentOption.TechSpec.rawValue:
            
            let colourValue = productDetail.strColor
            let genderValue = productDetail.strGender
            self.txtDescription.text = String(format: "Colour:    %@ \nGender:    %@", colourValue, genderValue)
            
        case SegmentOption.Delivery.rawValue:
            self.txtDescription.attributedText = appDelegate.stringFromHtml(string: "Delivery details goes here.")
        default:
            break;
        }
    }
    
    /*!
     @function    indexChanged
     @abstract    This function is called when user selected any section of the given options.
     */
    @IBAction func indexChanged(sender:UISegmentedControl) {
        
        updateUI(sender: sender, productDetail: self.productDetail!)
    }
}
