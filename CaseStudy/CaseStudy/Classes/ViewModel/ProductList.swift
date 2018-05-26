//
//  ProductList.swift
//  CaseStudy
//
//  Created by Gaurang Makwana on 7/17/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation

struct ProductListResponse {
    static let productId: String =      "productId"
    static let name: String =           "name"
    static let slug: String =           "slug"
    static let image: String =          "image"
    static let smallImage: String =     "smallImage"
    static let thumbnail: String =      "thumbnail"
    static let description: String =    "description"
    static let price: String =          "price"
    
    static let hits: String =           "hits"
    static let pagination: String =     "pagination"
    static let totalHits: String =      "totalHits"
    static let totalPages: String =     "totalPages"
}

class ProductList {

    var productId: String?
    var name: String?
    var slug: String?
    var image: String?
    var smallImage:String?
    var thumbnail: String?
    var description: String?
    var price:String?
    
    init(responseDict:[String:AnyObject]) {
    
        if let productId = responseDict[ProductListResponse.productId] as? String {
            self.productId = productId
        }
        
        if let name = responseDict[ProductListResponse.name] as? String {
            self.name = name
        }
        
        if let slug = responseDict[ProductListResponse.slug] as? String {
            self.slug = slug
        }
        
        if let image = responseDict[ProductListResponse.image] as? String {
            self.image = image
        }
        
        if let smallImage = responseDict[ProductListResponse.smallImage] as? String {
            self.smallImage = smallImage
        }

        if let thumbnail = responseDict[ProductListResponse.thumbnail] as? String {
            self.thumbnail = thumbnail
        }

        if let description = responseDict[ProductListResponse.description] as? String {
            self.description = description
        }

        if let price = responseDict[ProductListResponse.price] as? Int64 {
            self.price = String(price)
        }
    }
}
