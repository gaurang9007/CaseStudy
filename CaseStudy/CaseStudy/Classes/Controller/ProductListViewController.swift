//
//  ProductListViewController.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 17/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableProductList: UITableView!
    @IBOutlet var lblMessage: UILabel!
    
    let kLoadingCellTag:Int = -1
    var currentPage:Int = 0
    var totalHits:Int = 0
    var totalPages:Int = 0
    var pageHits:Int = 20
    var isFetchingData:Bool = false
    var arrProductList:[ProductList] = []
    let productListCellIdentifier = "ProductListCell"

    //MARK:-
    //MARK:- ViewLife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableProductList.addSubview(self.refreshControl)
        self.tableProductList.register(UINib(nibName: productListCellIdentifier, bundle: nil), forCellReuseIdentifier: productListCellIdentifier)
        
        //Call webservice to get the product list
        getProductList(showProgressHUD: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Product List"
        //Call function to initialize the UI part
        initializeController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:-
    //MARK:- Initializer method
    /*!
     @function    initializeController
     @abstract    This function is used to initialize the UI part based on the available records.
     */
    func initializeController() {
        if arrProductList.count == 0 {
            tableProductList.isHidden = true
            lblMessage.isHidden = false
        } else {
            tableProductList.isHidden = false
            lblMessage.isHidden = true
        }
    }
    
    //MARK:-
    //MARK:- Refresh Control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Product Data ...")
        refreshControl.addTarget(self, action: #selector(ProductListViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    /*!
     @function    handleRefresh
     @abstract    This function is used to reset the page logic and fetch the first page records
     */
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Reset the logic and call method to get the product list
        currentPage = 0
        getProductList(showProgressHUD: false)
    }
    
    //MARK:-
    //MARK:- UITableView Methods
    func numberOfSections(in tableView: UITableView) -> Int  {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProductListHeight.productListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentPage == 0 {
            return 1;
        }
        if currentPage < totalPages {
            return self.arrProductList.count + 1;
        }
        return self.arrProductList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.arrProductList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: productListCellIdentifier, for: indexPath) as! ProductListCell
            cell.serverProduct = self.arrProductList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        } else {
            return loadingCell();
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.tag == kLoadingCellTag {
            if !(isFetchingData) {
                getProductList(showProgressHUD: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.title = ""
        let productDetailVC = UIViewController.productDetailViewController()
        productDetailVC.serverProduct = self.arrProductList[indexPath.row]
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    //MARK:-
    //MARK:- Custom loding Cell
    /*!
     @function    loadingCell
     @abstract    This function is used to add the loading indicator when user loads the next page to fetch more records
     */
    func loadingCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        var activityIndicatorFrame:CGRect = activityIndicator.frame
        activityIndicatorFrame.origin.y = (140-activityIndicatorFrame.height)/2.0
        activityIndicatorFrame.origin.x = UIScreen.main.bounds.width/2.0
        activityIndicator.frame = activityIndicatorFrame
        cell.contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        cell.tag = kLoadingCellTag
        return cell
    }
    
    //MARK:-
    //MARK:- WebService Call
    /*!
     @function    getProductList
     @abstract    This function is used to get the list of products based on searchString, page and hits
     */
    func getProductList(showProgressHUD:Bool) {
        if showProgressHUD {
            appDelegate.showProgressHUD(message: "Please wait...")
        }
        self.isFetchingData = true
        let searchString = "boy"
        let page = String(currentPage)
        let hits = String(pageHits)
        let strQueryString = String(format:"?searchString=%@&page=%@&hits=%@", searchString, page, hits)
        getProductList(with: strQueryString, completionHandler: { (productArray) -> (Void) in
        
            self.isFetchingData = false
            if self.currentPage == 0 {
                if (self.arrProductList.count) > 0 {
                    self.arrProductList.removeAll()
                }
            }
            self.currentPage += 1
            self.arrProductList += productArray
            //print("items : \(self.arrProductList.count)")
            
            self.initializeController()
            self.tableProductList.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            appDelegate.hideProgressHUD()
            
        }) { (error) -> (Void) in
            
            self.isFetchingData = false
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            appDelegate.hideProgressHUD()
        }
    }
}
