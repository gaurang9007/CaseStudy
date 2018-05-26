//
//  ProductGalleryCell.swift
//  CaseStudy
//
//  Created by Gaurang Makwana on 7/21/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

class ProductGalleryCell: UITableViewCell, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var imgDiscount: UIImageView!
    @IBOutlet weak var lblNewProduct: UILabel!
    @IBOutlet weak var imgNewProduct: UIImageView!
    @IBOutlet weak var btnLeftArrow: UIButton!
    @IBOutlet weak var btnRightArrow: UIButton!
    
    let collectionCellIdentifier = "ProductCollectionCell"
    var productDetails:ProductDetail! = nil
    
    /*!
     @function    configureCell
     @abstract    This function is used to do the basic configuration of the tableviewcell.
     */
    func configureCell() {
    
        self.productCollectionView!.register(UINib(nibName: collectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionCellIdentifier)
        self.imgDiscount.isHidden = true
        self.lblDiscount.isHidden = true
        self.imgNewProduct.isHidden = true
        self.lblNewProduct.isHidden = true
        updateUI()
    }
    
    // MARK:
    // MARK: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.productDetails != nil) {
            return self.productDetails.productImageArray.count;
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width:self.frame.width, height:self.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let cell:ProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath as IndexPath) as! ProductCollectionCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! ProductCollectionCell
        
        let productMedia:ProductMedia = self.productDetails.productImageArray[indexPath.row]
        let imageURL = String(format:"%@%@", API.baseImageURL, productMedia.src!)
        cell.imgProduct.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder_cell"))
        return cell;
    }
    
    
    // MARK:
    // MARK: - ScrollView Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentPage = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        if (0.0 != fmodf(Float(currentPage), 1.0)) {
            pageControl.currentPage = Int(currentPage) + 1
        } else {
            pageControl.currentPage = Int(currentPage)
        }
        intializePageArrow()
    }
    
    /*!
     @function    prevPage
     @abstract    This function is called when the user click on the previous page button.
     */
    @IBAction func prevPage(_ sender: Any) {
        
        pageControl.currentPage -= 1
        let prevPageX: CGFloat = productCollectionView.frame.size.width * CGFloat(max(pageControl.currentPage, 0))
        productCollectionView.setContentOffset(CGPoint(x: prevPageX, y: CGFloat(0)), animated: true)
        //print("NewPage: \(Int(pageControl.currentPage))")
        intializePageArrow()
    }
    
    /*!
     @function    nextPage
     @abstract    This function is called when the user click on the next page button.
     */
    @IBAction func nextPage(_ sender: Any) {
        pageControl.currentPage += 1
        let prevPageX: CGFloat = productCollectionView.frame.size.width * CGFloat(min(pageControl.currentPage, 5))
        productCollectionView.setContentOffset(CGPoint(x: prevPageX, y: CGFloat(0)), animated: true)
        //print("NewPage: \(Int(pageControl.currentPage))")
        intializePageArrow()
    }
    
    /*!
     @function    changePage
     @abstract    This function is called when the user tries to change the page.
     */
    @IBAction func changePage(_ sender: Any) {
        let x = CGFloat(pageControl.currentPage) * productCollectionView.frame.size.width
        productCollectionView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }

    /*!
     @function    updateUI
     @abstract    This function is used to update the badge values and initializing the array with values.
     */
    func updateUI() {
        
        if (self.productDetails != nil) {
            
            if self.productDetails.isNew {
                self.imgNewProduct.isHidden = false
                self.lblNewProduct.isHidden = false
            }
            
            if self.productDetails.isDiscounted {
                self.imgDiscount.isHidden = false
                self.lblDiscount.isHidden = false
                let discount:String = String(format:"%@",self.productDetails.strDiscount)
                self.lblDiscount.text = discount + "%"
            }
            self.pageControl.numberOfPages = self.productDetails.productImageArray.count
            intializePageArrow()
            self.productCollectionView.reloadData()
        }
    }
    
    /*!
     @function    intializePageArrow
     @abstract    This function is used to update arrow status based on the user actions.
     */

    func intializePageArrow() {
        
        btnLeftArrow.isHidden = true
        btnRightArrow.isHidden = true
        self.pageControl.isHidden = true
        
        if self.productDetails.productImageArray.count > 1 {    
            btnLeftArrow.isHidden = false
            btnRightArrow.isHidden = false
            self.pageControl.isHidden = false
            
            if self.pageControl.currentPage == 0 {
                btnLeftArrow.isHidden = true
                btnRightArrow.isHidden = false
            } else if (self.pageControl.currentPage == self.productDetails.productImageArray.count-1) {
                btnLeftArrow.isHidden = false
                btnRightArrow.isHidden = true
            }
        }
    }
}

