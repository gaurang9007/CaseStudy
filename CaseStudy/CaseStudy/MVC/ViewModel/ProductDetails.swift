//
//  ProductDetails.swift
//  CaseStudy
//
//  Created by Gaurang Makwana on 7/24/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation

struct ProductDetailResponse {
    static let name: String =                   "name"
    static let discounted: String =             "discounted"
    static let specialPrice: String =           "specialPrice"
    static let price: String =                  "price"
    static let visibleSku: String =             "visibleSku"
    static let description: String =            "description"
    static let color: String =                  "color"
    static let gender: String =                 "gender"
    static let siblings: String =               "siblings"
    static let relatedProductsLookup: String =  "relatedProductsLookup"
    static let sizeCode: String =               "sizeCode"
    static let stock: String =                  "stock"
    static let maxAvailableQty: String =        "maxAvailableQty"
    static let media: String =                  "media"
    static let position: String =               "position"
    static let mediaType: String =              "mediaType"
    static let src: String =                    "src"
    static let videoUrl: String =               "videoUrl"
    static let badges: String =                 "badges"
    static let isNew: String =                  "isNew"
    static let discount: String =               "discount"
}

class ProductDetails {
    
    //MARK:- Properties
    var productSizesArray:[ProductSize] = []
    var productImageArray:[ProductMedia] = []
    var isNew:Bool = false
    var strDiscount:String = ""
    var strName:String = ""
    var isDiscounted:Bool = false
    var specialPrice:NSNumber = 0
    var price:NSNumber = 0
    var strVisibleSku:String = ""
    
    var strDescription:String = ""
    var strColor:String = ""
    var strGender:String = ""
    
    var currentSize:String = ""
    var currentQuantity:Int64 = 0
    
    init(responseDict:[String:AnyObject]) {
        
        if let name = responseDict[ProductDetailResponse.name] as? String {
            self.strName = name
        }
        if let discounted = responseDict["discounted"] as? String {
            
            if discounted.lowercased() == "yes" {
                self.isDiscounted = true
            }
        }
        if let sp = responseDict[ProductDetailResponse.specialPrice] as? NSNumber {
            self.specialPrice = sp
        }
        if let price = responseDict[ProductDetailResponse.price] as? NSNumber {
            self.price = price
        }
        if let sku = responseDict[ProductDetailResponse.visibleSku] as? String {
            self.strVisibleSku = sku
        }
        
        if let description = responseDict[ProductDetailResponse.description] as? String {
            self.strDescription = description
        }
        
        if let color = responseDict[ProductDetailResponse.color] as? String {
            self.strColor = color
        }
        
        if let gender = responseDict[ProductDetailResponse.gender] as? String {
            self.strGender = gender
        }
        
        if let sizeCode = responseDict[ProductDetailResponse.sizeCode] as? String {
            self.currentSize = sizeCode
        }
        
        if let dictStocks = responseDict[ProductDetailResponse.stock] as? [String: AnyObject]{
            self.currentQuantity = (dictStocks[ProductDetailResponse.maxAvailableQty] as? Int64)!
        }
        
        let prouctIDArray = responseDict[ProductDetailResponse.siblings] as? [String]
        if (prouctIDArray?.count)! > 0 {

            for productID in prouctIDArray! {
                
                if let dictRelatedProduct = responseDict[ProductDetailResponse.relatedProductsLookup] as? [String:AnyObject]{
                    let productSize:ProductSize = ProductSize()
                    if let relatedDict = dictRelatedProduct[productID] as? [String: AnyObject] {
                        
                        productSize.size = relatedDict[ProductDetailResponse.sizeCode] as? String
                        if let dictStocks = relatedDict[ProductDetailResponse.stock] as? [String: AnyObject]{
                            productSize.maxQuantity = dictStocks[ProductDetailResponse.maxAvailableQty] as? Int64
                        }
                    }
                    productSize.ID = productID
                    self.productSizesArray.append(productSize)
                }
            }
        }
        
        let imageArray = responseDict[ProductDetailResponse.media] as! [[String: AnyObject]]
        if imageArray.count > 0 {
            
            for mediaDict in imageArray {
                
                let productMedia:ProductMedia = ProductMedia()
                if let position = mediaDict[ProductDetailResponse.position] as? NSNumber {
                    productMedia.position = position
                }
                if let mediaType = mediaDict[ProductDetailResponse.mediaType] as? String {
                    productMedia.mediaType = mediaType
                }
                if let src = mediaDict[ProductDetailResponse.src] as? String {
                    productMedia.src = src
                }
                if let videoUrl = mediaDict[ProductDetailResponse.videoUrl] as? String {
                    productMedia.videoUrl = videoUrl
                }
                self.productImageArray.append(productMedia)
            }
        }
        
        if let dictBadges = responseDict[ProductDetailResponse.badges] as? [String: AnyObject] {
            if let _:String = dictBadges[ProductDetailResponse.isNew] as? String {
                self.isNew = true
            }
            
            if let discount:String = dictBadges[ProductDetailResponse.discount] as? String {
                strDiscount = discount
            }
        }
    }
    
    /*!
     @function    getProductQuantityByID
     @abstract    This function is used to get the product quantity based on the given productId.
     */
    func getProductQuantityByID(productID:String)  -> Int64 {
        
        var maxQuantity:Int64 = 0
        for productSizeDict in self.productSizesArray {
            let ID = productSizeDict.ID
            if productID == ID {
                maxQuantity = productSizeDict.maxQuantity!
                break
            }
        }
        return maxQuantity
    }
    
    /*!
     @function    getProductQuantityBySize
     @abstract    This function is used to get the product quantity based on the given product size.
     */
    func getProductQuantityBySize(productSize:String)  -> Int64 {
        var maxQuantity:Int64 = 0
        for productSizeDict in self.productSizesArray {
            let size = productSizeDict.size
            if productSize == size {
                maxQuantity = productSizeDict.maxQuantity!
                break
            }
        }
        return maxQuantity
    }
    
    /*!
     @function    getProductIDByName
     @abstract    This function is used to get the productId based on the given product size.
     */
    func getProductIDByName(name:String)  -> String {
        
        var productID:String = ""
        for productSize in self.productSizesArray {
            
            let sizeName = productSize.size
            if name == sizeName {
                productID = productSize.ID!
                break
            }
        }
        return productID
    }
}
