//
//  ProductManager.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 24/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation

protocol ProductLists {
    func getProductList (with queryString:String, completionHandler : ((_ responseArray: [ProductList]) -> (Void))? , errorHandler : ((_ error: NSError) -> (Void))? )
}

protocol ProductDetails {
    func getProductDetail (with queryString:String, completionHandler : ((_ responseDic: [String : AnyObject]) -> (Void))? , errorHandler : ((_ error: NSError) -> (Void))? )
}

extension ProductListViewController : ProductLists {
    func getProductList(with queryString: String, completionHandler: (([ProductList]) -> (Void))?, errorHandler: ((NSError) -> (Void))?) {
        
        if NetworkReachability.isInternetAvailable() == false {
            _ = SweetAlert().showAlert(appName, subTitle: NetworkStatus.message, style: AlertStyle.warning)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            appDelegate.hideProgressHUD()
            return
        }
        let objNetworkManager = NetworkManager(withRequestType: RequestType.productList, queryString: queryString)
        
        objNetworkManager.postRequestTask(contentType: ContentType.JSON, parameters: nil, completionHandler: { (response) -> (Void) in
            
            let responseDic : NSDictionary = response as! NSDictionary
            let items = responseDic[ProductListResponse.hits] as! [[String: AnyObject]]
            let pageDict = responseDic[ProductListResponse.pagination] as! [String:AnyObject]
            self.totalHits = pageDict[ProductListResponse.totalHits]! as! Int
            self.totalPages = pageDict[ProductListResponse.totalPages]! as! Int
            
            var arrProductList:[ProductList] = []
            for dictItem:[String:AnyObject] in items {
                
                let serverProduct:ProductList = ProductList(responseDict: dictItem)
                arrProductList.append(serverProduct)
            }
            completionHandler!(arrProductList)
            
        }) { (error) -> (Void) in
            print(error.localizedDescription)
            errorHandler!(error)
        }
    }
}

extension ProductDetailViewController : ProductDetails {
    func getProductDetail(with queryString: String, completionHandler: (([String : AnyObject]) -> (Void))?, errorHandler: ((NSError) -> (Void))?) {
        
        if NetworkReachability.isInternetAvailable() == false {
            _ = SweetAlert().showAlert(appName, subTitle: NetworkStatus.message, style: AlertStyle.warning)
            appDelegate.hideProgressHUD()
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        let objNetworkManager = NetworkManager(withRequestType: RequestType.productDetail, queryString: queryString)
        objNetworkManager.getRequestTask(completionHandler: { (response) -> (Void) in
            let responsedic:[String : AnyObject] = (response as? [String : AnyObject])!
            //print(responsedic)
            completionHandler!(responsedic)
            
        }) { (error) -> (Void) in
            print(error.localizedDescription)
            errorHandler!(error)
        }
    }
}

