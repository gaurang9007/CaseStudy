//
//  ServerProduct.swift
//  CaseStudy
//
//  Created by Gaurang Makwana on 7/17/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation

struct ProductResponse {
    static let productId: String =      "productId"
    static let name: String =           "name"
    static let slug: String =           "slug"
    static let image: String =          "image"
    static let smallImage: String =     "smallImage"
    static let thumbnail: String =      "thumbnail"
    static let description: String =    "description"
    static let price: String =          "price"
}

class ServerProduct {

    var productId: String?
    var name: String?
    var slug: String?
    var image: String?
    var smallImage:String?
    var thumbnail: String?
    var description: String?
    var price:String?
    
    init(responseDict:[String:AnyObject]) {
    
        if let productId = responseDict[ProductResponse.productId] as? String {
            self.productId = productId
        }
        
        if let name = responseDict[ProductResponse.name] as? String {
            self.name = name
        }
        
        if let slug = responseDict[ProductResponse.slug] as? String {
            self.slug = slug
        }
        
        if let image = responseDict[ProductResponse.image] as? String {
            self.image = image
        }
        
        if let smallImage = responseDict[ProductResponse.smallImage] as? String {
            self.smallImage = smallImage
        }

        if let thumbnail = responseDict[ProductResponse.thumbnail] as? String {
            self.thumbnail = thumbnail
        }

        if let description = responseDict[ProductResponse.description] as? String {
            self.description = description
        }

        if let price = responseDict[ProductResponse.price] as? Int64 {
            self.price = String(price)
        }
    }
}
