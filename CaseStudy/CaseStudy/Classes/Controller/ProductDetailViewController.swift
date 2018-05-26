//
//  ProductDetailViewController.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 17/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProductDetailViewController: UITableViewController, ProductQuantityDelegate {

    var serverProduct:ProductList! = nil
    var productDetail:ProductDetail! = nil
    
    var tagListViewHeight:CGFloat = 0.0
    
    let galleryCellIdentifier = "ProductGalleryCell"
    let detailedInfoCellIdentifier = "ProductDetailedInfoCell"
    let deliveryOptionCellIdentifier = "ProductDeliveryOptionCell"
    let wishListCellIdentifier = "ProductWishListCell"
    let sizeViewCellIdentifier = "ProductSizeViewCell"
    let priceViewCellIdentifier = "ProductPriceCell"
    
    //MARK:
    //MARK:- ViewLife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: galleryCellIdentifier, bundle: nil), forCellReuseIdentifier: galleryCellIdentifier)
        self.tableView.register(UINib(nibName: detailedInfoCellIdentifier, bundle: nil), forCellReuseIdentifier: detailedInfoCellIdentifier)
        self.tableView.register(UINib(nibName: deliveryOptionCellIdentifier, bundle: nil), forCellReuseIdentifier: deliveryOptionCellIdentifier)
        self.tableView.register(UINib(nibName: wishListCellIdentifier, bundle: nil), forCellReuseIdentifier: wishListCellIdentifier)
        self.tableView.register(UINib(nibName: sizeViewCellIdentifier, bundle: nil), forCellReuseIdentifier: sizeViewCellIdentifier)
        self.tableView.register(UINib(nibName: priceViewCellIdentifier, bundle: nil), forCellReuseIdentifier: priceViewCellIdentifier)
        
        //Call webservice to get the product details by slug
        getProductDetails(slugName:serverProduct.slug!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = serverProduct.name
    }
    
    func reloadTableViewAsChangeInTagList() {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    // MARK: UITableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int  {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == tableViewOption.ProductGalleryView.rawValue {
            return ProductDetailHeight.productGalleryCell
        } else if indexPath.row == tableViewOption.ProductPriceView.rawValue {
            return ProductDetailHeight.productPriceCell
        } else if indexPath.row == tableViewOption.ProdcutSizeView.rawValue {
            return ProductDetailHeight.productSizeCell + tagListViewHeight
        } else if indexPath.row == tableViewOption.ProdcutWishListView.rawValue {
            return ProductDetailHeight.productWishListCell
        } else if indexPath.row == tableViewOption.ProdcutDeliveryView.rawValue {
            return ProductDetailHeight.productDeliveryOptionCell
        } else {
            return ProductDetailHeight.productDetailedInfoCell
        }
        //return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == tableViewOption.ProductGalleryView.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: galleryCellIdentifier, for: indexPath) as! ProductGalleryCell
            cell.productDetails = self.productDetail
            cell.configureCell()
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == tableViewOption.ProductPriceView.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: priceViewCellIdentifier, for: indexPath) as! ProductPriceCell
            cell.configureCell()
            cell.productDetail = self.productDetail
            cell.selectionStyle = .none
            return cell
        
        } else if indexPath.row == tableViewOption.ProdcutSizeView.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: sizeViewCellIdentifier, for: indexPath) as! ProductSizeViewCell
            
            cell.productTagListView.removeAllTags()
            cell.productDetail = self.productDetail
            cell.configureCell()
            cell.delegate = self
            cell.configureBagCell()
            tagListViewHeight = cell.productTagListView.systemLayoutSizeFitting(CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)).height
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == tableViewOption.ProdcutWishListView.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: wishListCellIdentifier, for: indexPath) as! ProductWishListCell
            cell.configureCell()
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == tableViewOption.ProdcutDeliveryView.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: deliveryOptionCellIdentifier, for: indexPath) as! ProductDeliveryOptionCell
            cell.selectionStyle = .none
            return cell
    
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedInfoCellIdentifier, for: indexPath) as! ProductDetailedInfoCell
            cell.productDetail = self.productDetail
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //MARK:
    //MARK: WebService Call
    /*!
     @function    getProductDetails
     @abstract    This function is used to get the product details based on selected slug.
     */
    func getProductDetails(slugName:String) {
        appDelegate.showProgressHUD(message: "Please wait...")
        let strSlug = String(format:"?slug=%@", slugName)
        getProductDetail(with: strSlug, completionHandler: { (responseDict) -> (Void) in
            self.productDetail = ProductDetail(responseDict: responseDict)
            self.tableView.reloadData()
            self.perform(#selector(self.reloadTableViewAsChangeInTagList), with: nil, afterDelay: 1.0)
            appDelegate.hideProgressHUD()
            
        }) { (error) -> (Void) in
            appDelegate.hideProgressHUD()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK:
    // MARK: ProductQuantity Delegate
    func selectedQuantity(quantity: String) {
        let priceCell: ProductPriceCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ProductPriceCell
        priceCell.updateAmberPoints(quantity: quantity)
    }

    func tagPressedForSize(title: String) {
        let priceCell: ProductPriceCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ProductPriceCell
        let productID = self.productDetail.getProductIDByName(name: title)
        priceCell.updateProductID(productID: productID)
    }
}

