//
//  Constant.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 17/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

//Application name
let appName:String = "CaseStudy"
//Application delegate object
let appDelegate = UIApplication.shared.delegate as! AppDelegate

struct API {
    static let stagingUrl: String = "https://www.mamasandpapas.ae"
    static let baseImageURL: String = "https://prod4.mnpcdn.ae/pub/media/catalog/product"
}

struct ProductDetailHeight {
    
    static let productGalleryCell:CGFloat =            (appDelegate.window?.frame.size.width)!
    static let productPriceCell:CGFloat =              186.0
    static let productSizeCell:CGFloat =               120.0
    static let productWishListCell:CGFloat =           60.0
    static let productDeliveryOptionCell:CGFloat =     95.0
    static let productDetailedInfoCell:CGFloat =       258.0
}

struct ProductListHeight {
    
    static let productListCell:CGFloat =            140.0

}

enum SegmentOption: Int {

    case Description = 0
    case TechSpec = 1
    case Delivery = 2
}

enum tableViewOption: Int {
    
    case ProductGalleryView = 0
    case ProductPriceView = 1
    case ProdcutSizeView = 2
    case ProdcutWishListView = 3
    case ProdcutDeliveryView = 4
    case ProdcutDetailedInfoView = 5
    
}
