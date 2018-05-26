//
//  ProductWishListCell.swift
//  CaseStudy
//
//  Created by Gaurang Makwana on 7/21/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

class ProductWishListCell: UITableViewCell {
    
    @IBOutlet weak var btnAddWishList: UIButton!
    
    /*!
     @function    configureCell
     @abstract    This function is used to do the basic configuration of the tableviewcell.
     */
    func configureCell() {
        
        btnAddWishList.layer.borderWidth = 0.5
        btnAddWishList.layer.borderColor = UIColor.gray.cgColor
    }
}
