//
//  ProductListCell.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 17/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage

class ProductListCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    
    /*!
     @function    configureCell
     @abstract    This function is used to do the basic configuration of the tableviewcell.
     */
    
    var serverProduct: ProductList? {
        didSet {
            guard let productList = serverProduct else {
                return
            }
            let imageURL = String(format:"%@%@", API.baseImageURL, productList.image!)
            self.imgProduct.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder_cell"))
            
            self.lblName.text = productList.name
            self.lblDescription.text = productList.description
            self.lblDescription.attributedText = appDelegate.stringFromHtml(string: productList.description!)
            self.lblPrice.text = productList.price
        }
    }
}

