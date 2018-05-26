
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
    
    var productDetail: ProductDetail? {
        didSet {
            guard let productDetail = productDetail else {
                return
            }
            self.lblProductTitle.text = productDetail.strName
            
            var price = 0.0
            if productDetail.isDiscounted {
                
                self.lblActualPrice.isHidden = false
                price = Double(productDetail.specialPrice)
                price = price * 0.1
                self.lblAmberPoints.text = String(format:"EARN %d AMBER POINTS", Int64(productDetail.specialPrice))
                self.lblOfferPrice.text = String(format:"%.2f AED", Double(productDetail.specialPrice))
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(format:"%.2f AED", Double(productDetail.price)))
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                self.lblActualPrice.attributedText = attributeString
                
            } else {
                self.lblOfferPrice.text = String(format:"%.2f AED",Double(productDetail.price))
                self.lblAmberPoints.text = String(format:"EARN %d AMBER POINTS", Int64(productDetail.price))
                price = Double(productDetail.price)
                price = price * 0.1
            }
            self.lblSaveMessage.attributedText = appDelegate.stringFromHtml(string: String(format:"Save <strong> %.2f AED </strong> with", price))
            self.lblProductID.text = String(format:"ID: %@", productDetail.strVisibleSku)
        }
    }
    /*!
     @function    configureCell
     @abstract    This function is used to do the basic configuration of the tableviewcell.
     */
    func configureCell() {
        self.lblActualPrice.isHidden = true
    }
    
    /*!
     @function    updateProductID
     @abstract    This function is used to update the productId based on the selected size.
     */

    func updateProductID(productID: String) {
    
        self.lblProductID.text = String(format:"ID: %@", productID)
    }
    
    /*!
     @function    updateAmberPoints
     @abstract    This function is used to update the Amber points based on the selected quantity.
     */
    
    func updateAmberPoints(quantity: String) {
        
        guard let productDetail = self.productDetail else {
            return
        }
        var price:Int64 = 0
        if productDetail.isDiscounted {
            price = Int64(productDetail.specialPrice)
            price = price * Int64(quantity)!
            self.lblAmberPoints.text = String(format:"EARN %d AMBER POINTS", price)
        } else {
            price = Int64(productDetail.price)
            price = price * Int64(quantity)!
            self.lblAmberPoints.text = String(format:"EARN %d AMBER POINTS", price)
        }
    }

}
