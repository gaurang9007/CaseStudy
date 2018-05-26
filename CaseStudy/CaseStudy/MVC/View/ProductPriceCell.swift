
//
//  ProductPriceCell.swift
//  CaseStudy
//
//  Created by Gaurang Makwana on 7/21/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

class ProductPriceCell: UITableViewCell {
    
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblSaveMessage: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblProductID: UILabel!
    @IBOutlet weak var lblAmberPoints: UILabel!
    
    var productDetails:ProductDetails! = nil
    /*!
     @function    configureCell
     @abstract    This function is used to do the basic configuration of the tableviewcell.
     */
    func configureCell() {
        
        self.lblActualPrice.isHidden = true
        if (self.productDetails != nil) {
            updateUI()
        }
    }
    
    /*!
     @function    updateProductID
     @abstract    This function is used to update the productId based on the selected size.
     */

    func updateProductID(productID: String) {
    
        self.lblProductID.text = String(format:"ID: %@", productID)
    }
    
    /*!
     @function    updateUI
     @abstract    This function is used to update the price values and set the initial productId.
     */
    
    func updateUI() {
        
        self.lblProductTitle.text = self.productDetails.strName
        
        var price = 0.0
        if self.productDetails.isDiscounted {
            
            self.lblActualPrice.isHidden = false
            price = Double(self.productDetails.specialPrice)
            price = price * 0.1
            self.lblAmberPoints.text = String(format:"EARN %d AMBER POINTS", Int64(self.productDetails.specialPrice))
            self.lblOfferPrice.text = String(format:"%.2f AED", Double(self.productDetails.specialPrice))
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(format:"%.2f AED", Double(self.productDetails.price)))
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            self.lblActualPrice.attributedText = attributeString
            
        } else {
            self.lblOfferPrice.text = String(format:"%.2f AED",Double(self.productDetails.price))
            self.lblAmberPoints.text = String(format:"EARN %d AMBER POINTS", Int64(self.productDetails.price))
            price = Double(self.productDetails.price)
            price = price * 0.1
        }
        self.lblSaveMessage.attributedText = appDelegate.stringFromHtml(string: String(format:"Save <strong> %.2f AED </strong> with", price))
        self.lblProductID.text = String(format:"ID: %@", self.productDetails.strVisibleSku)
    }

}
