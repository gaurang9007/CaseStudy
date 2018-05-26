//
//  NetworkManager.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 24/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Request Type

enum WebServiceType {
    case GET
    case POST
    case DELETE
    case PUT
}

// MARK: Content Type

enum ContentType : String {
    case JSON,XML,RSS,HTML,TEXT,FORM
    
    func getContentType() -> String {
        switch self {
        case .XML:
            return "application/xml"
        case .RSS:
            return "application/rss+xml"
        case .HTML:
            return "text/html"
        case .TEXT:
            return "text/plain"
        case .FORM:
            return "application/x-www-form-urlencoded"
        default:
            return "application/json"
        }
    }
}

// MARK: Request Type

enum RequestType : String {
    
    case productDetail = "/product/findbyslug/"
    case productList = "/search/full"
    
    func serviceUrl() -> String {
        switch self {
        case .productList:
            return String(API.stagingUrl + "/search/full")
        case .productDetail:
            return String(API.stagingUrl + "/product/findbyslug/")
        //default:
        //    return String("https://www.google.com")
        }
    }
}

protocol NetworkProtocol {
    
    func getRequestTask(completionHandler: ((_ response: Any) -> (Void))?, errorHandler: ((_ error: NSError) -> (Void))?)
    
    func postRequestTask(contentType : ContentType, parameters:Dictionary<String,Any>?, completionHandler: ((_ response: Any) -> (Void))?, errorHandler: ((_ error: NSError) -> (Void))?)
}

extension Request {
    public func debugLog() -> Self {
        // #if DEBUG
        debugPrint(self)
        // #endif
        return self
    }
}

struct NetworkManager {
    
    var requestType : RequestType
    var queryString : String
    
    init(withRequestType requestType: RequestType, queryString: String) {
        self.requestType = requestType
        self.queryString = queryString
    }
}

extension NetworkManager : NetworkProtocol {
    
    func getRequestTask(completionHandler: ((Any) -> (Void))?, errorHandler: ((NSError) -> (Void))?){
        
        Alamofire.request(self.requestType.serviceUrl()+self.queryString).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let data) :
                if completionHandler != nil {
                    completionHandler!(response:data)
                }
            case .failure(let error) :
                if errorHandler != nil {
                    errorHandler!(error as NSError)
                }
            }
        }
    }
    
    func postRequestTask(contentType: ContentType, parameters: Dictionary<String, Any>?, completionHandler: ((Any) -> (Void))?, errorHandler: ((NSError) -> (Void))?) {
        
        // Add default headers if needed.
        //        let headers: HTTPHeaders = [
        //            "Accept": "text/html",
        //            "Content-Type" : "application/x-www-form-urlencoded"
        //            // "application/json"
        //            // application/x-www-form-urlencoded
        //        ]
        
        Alamofire.request(self.requestType.serviceUrl()+self.queryString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).validate().responseJSON { (response) in
            
            //debugPrint(response)
            
            switch response.result {
            case .success(let data) :
                
                if completionHandler != nil {
                    completionHandler!(response: data)
                }
            case .failure(let error):
                
                if errorHandler != nil {
                    errorHandler!(error as NSError)
                }
            }
        }
    }
}
