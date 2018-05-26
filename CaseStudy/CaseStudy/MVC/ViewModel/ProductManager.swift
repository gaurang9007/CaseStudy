//
//  ProductManager.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 24/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation

protocol ProductList {
    
    func getProductList (with queryString:String, completionHandler : ((_ responseDic: NSDictionary) -> (Void))? , errorHandler : ((_ error: NSError) -> (Void))? )
}


protocol ProductDetail {
    
    func getProductDetail (with queryString:String, completionHandler : ((_ responseDic: [String : AnyObject]) -> (Void))? , errorHandler : ((_ error: NSError) -> (Void))? )
}

extension ProductListViewController : ProductList {
    
    func getProductList(with queryString: String, completionHandler: ((NSDictionary) -> (Void))?, errorHandler: ((NSError) -> (Void))?) {
        
        let objNetworkManager = NetworkManager(withRequestType: RequestType.productList, queryString: queryString)
        
        objNetworkManager.postRequestTask(contentType: ContentType.JSON, parameters: nil, completionHandler: { (response) -> (Void) in
            
            let responseDic : NSDictionary = response as! NSDictionary
            print(responseDic)
    
            completionHandler!(responseDic)
            
        }) { (error) -> (Void) in
            
            print(error.localizedDescription)
            errorHandler!(error)
        }
    }
}

extension ProductDetailViewController : ProductDetail
{
    func getProductDetail(with queryString: String, completionHandler: (([String : AnyObject]) -> (Void))?, errorHandler: ((NSError) -> (Void))?) {
        
        let objNetworkManager = NetworkManager(withRequestType: RequestType.productDetail, queryString: queryString)
        
        objNetworkManager.getRequestTask(completionHandler: { (response) -> (Void) in
            
            let responsedic:[String : AnyObject] = (response as? [String : AnyObject])!
            print(responsedic)
            
            completionHandler!(responsedic)
            
        }) { (error) -> (Void) in
            
            print(error.localizedDescription)
            errorHandler!(error)
        }
    }
}

