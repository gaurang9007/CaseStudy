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

class ProductDetailViewController: UITableViewController, TagListViewDelegate, ProductQuantityDelegate {

    var serverProduct:ServerProduct! = nil
    var productDetails:ProductDetails! = nil
    
    var tagListViewHeight:CGFloat = 0.0
    
    let galleryCellIdentifier = "ProductGalleryCell"
    let detailedInfoCellIdentifier = "ProductDetailedInfoCell"
    let deliveryOptionCellIdentifier = "ProductDeliveryOptionCell"
    let wishListCellIdentifier = "ProductWishListCell"
    let sizeViewCellIdentifier = "ProductSizeViewCell"
    let priceViewCellIdentifier = "ProductPriceCell"
    
     // MARK:
    //MARK:- ViewLife Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(UINib(nibName: galleryCellIdentifier, bundle: nil), forCellReuseIdentifier: galleryCellIdentifier)
        self.tableView.register(UINib(nibName: detailedInfoCellIdentifier, bundle: nil), forCellReuseIdentifier: detailedInfoCellIdentifier)
        self.tableView.register(UINib(nibName: deliveryOptionCellIdentifier, bundle: nil), forCellReuseIdentifier: deliveryOptionCellIdentifier)
        self.tableView.register(UINib(nibName: wishListCellIdentifier, bundle: nil), forCellReuseIdentifier: wishListCellIdentifier)
        self.tableView.register(UINib(nibName: sizeViewCellIdentifier, bundle: nil), forCellReuseIdentifier: sizeViewCellIdentifier)
        self.tableView.register(UINib(nibName: priceViewCellIdentifier, bundle: nil), forCellReuseIdentifier: priceViewCellIdentifier)
        
        //Call webservice to get the product details by slug
        getProductDetails(slugName:serverProduct.slug!)
        
        self.perform(#selector(self.reloadTableViewAsChangeInTagList), with: nil, afterDelay: 1.0)
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
            return productGalleryCellHeight
        } else if indexPath.row == tableViewOption.ProductPriceView.rawValue {
            return productPriceCellHeight
        } else if indexPath.row == tableViewOption.ProdcutSizeView.rawValue {
            return productSizeCellHeight + tagListViewHeight
        } else if indexPath.row == tableViewOption.ProdcutWishListView.rawValue {
            return productWishListCellHeight
        } else if indexPath.row == tableViewOption.ProdcutDeliveryView.rawValue {
            return productDeliveryOptionCellHeight
        } else {
            return productDetailedInfoCellHeight
        }
        //return UITableViewAutomaticDimension
    }
    
    /*
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            
        return UITableViewAutomaticDimension
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == tableViewOption.ProductGalleryView.rawValue {

            let cell = tableView.dequeueReusableCell(withIdentifier: galleryCellIdentifier, for: indexPath) as! ProductGalleryCell
            cell.productDetails = self.productDetails
            cell.configureCell()
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == tableViewOption.ProductPriceView.rawValue {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: priceViewCellIdentifier, for: indexPath) as! ProductPriceCell
            cell.productDetails = self.productDetails
            cell.configureCell()
            cell.selectionStyle = .none
            return cell
        
        } else if indexPath.row == tableViewOption.ProdcutSizeView.rawValue {

            let cell = tableView.dequeueReusableCell(withIdentifier: sizeViewCellIdentifier, for: indexPath) as! ProductSizeViewCell
            cell.btnAddBag.addTarget(self, action: #selector(self.btnAddBagClicked(_:)), for: UIControlEvents.touchUpInside)
            cell.productDetails = self.productDetails
            cell.productTagListView.removeAllTags()
            cell.configureSizeCell(delegate: self)
            cell.maxQuantity = (self.productDetails != nil) ? self.productDetails.currentQuantity : 0
            cell.configureCell()
            cell.delegate = self
            configureBagCell(cell: cell)
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
            cell.productDetails = self.productDetails
            cell.configureCell()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
    // MARK:
    //MARK: Action Events
    
    @IBAction func btnAddBagClicked(_ sender:UIButton) {
        _ = SweetAlert().showAlert(appName, subTitle: "Add to bag clicked.", style: AlertStyle.none)
    }
    
    // MARK:
    //MARK: WebService Call
    
    /*!
     @function    getProductDetails
     @abstract    This function is used to get the product details based on selected slug.
     */
    func getProductDetails(slugName:String) {
        if NetworkReachability.isInternetAvailable() == false {
            _ = SweetAlert().showAlert(appName, subTitle: "Please check internet connection!", style: AlertStyle.warning)
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        appDelegate.showProgressHUD(message: "Please wait...")
        let strSlug = String(format:"?slug=%@", slugName)
        getProductDetail(with: strSlug, completionHandler: { (responseDict) -> (Void) in
            
            self.productDetails = ProductDetails(responseDict: responseDict)
            self.tableView.reloadData()
            appDelegate.hideProgressHUD()
            
        }) { (error) -> (Void) in
            appDelegate.hideProgressHUD()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK:
    // MARK: Custom function

    /*!
     @function    configureBagCell
     @abstract    This function is used to configure the productsize cell to enable/disable AddToBag button.
     */
    func configureBagCell(cell: ProductSizeViewCell) {
        
        cell.btnAddBag.isEnabled = false
        if (self.productDetails != nil) {
            if self.productDetails.productSizesArray.count > 0 {
                
                var isSizeSelected: Bool = false
                for subview in (cell.productTagListView.tagViews) {
                    if subview.isSelected {
                        isSizeSelected = true
                        break
                    }
                }
                if (isSizeSelected && (cell.pickerQuantity.text != "")) {
                    cell.btnAddBag.isEnabled = true
                }
            } else {
                if cell.pickerQuantity.text != "" {
                    cell.btnAddBag.isEnabled = true
                }
            }
        }
    }
    
    /*!
     @function    updateSizeCellByQuantity
     @abstract    This function is used to update the status of product size based on the selected quantity.
     */
    func updateSizeCellByQuantity(selectedQuantity:Int64) {
        
        let sizeCell: ProductSizeViewCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ProductSizeViewCell
        for subview in sizeCell.productTagListView.tagViews {
            
            subview.isEnabled = true
            let maxQuantity = self.productDetails.getProductQuantityBySize(productSize: subview.currentTitle!)
            if selectedQuantity > maxQuantity {
                subview.isEnabled = false
            }
        }
    }
    
    // MARK:
    // MARK: ProductQuantity Delegate
    
    func selectedQuantity(quantity: String) {
        
        let priceCell: ProductPriceCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ProductPriceCell
        var price:Int64 = 0
        if self.productDetails.isDiscounted {
            price = Int64(self.productDetails.specialPrice)
            price = price * Int64(quantity)!
            priceCell.lblAmberPoints.text = String(format:"EARN %d AMBER POINTS", price)
        } else {
            price = Int64(self.productDetails.price)
            price = price * Int64(quantity)!
            priceCell.lblAmberPoints.text = String(format:"EARN %d AMBER POINTS", price)
        }
        
        if self.productDetails.productSizesArray.count > 0 {
            let selectedQuantity:Int64 = Int64(quantity)!
            updateSizeCellByQuantity(selectedQuantity: selectedQuantity)
        }
        
        let sizeCell: ProductSizeViewCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ProductSizeViewCell
        configureBagCell(cell: sizeCell)
    }

    // MARK:
    // MARK: TagListViewDelegate
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        print("Tag pressed: \(title), \(sender)")
        
        let priceCell: ProductPriceCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ProductPriceCell
        let productID = self.productDetails.getProductIDByName(name: title)
        priceCell.updateProductID(productID: productID)

        let sizeCell: ProductSizeViewCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ProductSizeViewCell
        
        let quantity =  self.productDetails.getProductQuantityByID(productID: productID)
        sizeCell.maxQuantity = quantity
        sizeCell.configureCell()
        
        for subview in sizeCell.productTagListView.tagViews {
        
             if subview == tagView {
                if quantity == 0 {
                    tagView.isEnabled = false
                }
                tagView.isSelected = !tagView.isSelected
             } else {
                subview.isSelected = false
             }
        }
        configureBagCell(cell: sizeCell)
    }
}

