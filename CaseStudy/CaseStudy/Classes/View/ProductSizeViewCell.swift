//
//  ProductSizeViewCell.swift
//  CaseStudy
//
//  Created by Gaurang Makwana on 7/21/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

protocol ProductQuantityDelegate {
    
    func selectedQuantity(quantity: String)
    func tagPressedForSize(title: String)
}

class ProductSizeViewCell: UITableViewCell, TagListViewDelegate {
    
    @IBOutlet weak var productTagListView: TagListView!
    @IBOutlet weak var btnAddBag: UIButton!
    
    @IBOutlet weak var pickerQuantity: CustomePickerView!
    
    var delegate:ProductQuantityDelegate?
    var quantityData = [String]()
    var maxQuantity: Int64 = 0
    
    var productDetail: ProductDetail? {
        didSet {
            guard let productDetail = productDetail else {
                return
            }
            self.maxQuantity = productDetail.currentQuantity
            
            if productDetail.productSizesArray.count > 0 {
                
                productTagListView.delegate = self
                productTagListView.textFont = UIFont.systemFont(ofSize: 15)
                productTagListView.shadowRadius = 2
                productTagListView.shadowOpacity = 0.4
                productTagListView.shadowColor = UIColor.black
                productTagListView.shadowOffset = CGSize(width: 1, height: 1)
                for productSize in productDetail.productSizesArray {
                    let sizeName = productSize.size
                    productTagListView.addTag(sizeName!)
                }
                productTagListView.alignment = .left
                
            } else { print("No sizes available") }
            
            for subview in self.productTagListView.tagViews {
                
                subview.isEnabled = true
                if subview.currentTitle == productDetail.currentSize {
                    if maxQuantity == 0 {
                        subview.isEnabled = false
                    } else {
                        subview.isSelected = true
                    }
                } else {
                    let maxQuantity = productDetail.getProductQuantityBySize(productSize: subview.currentTitle!)
                    if maxQuantity == 0 {
                        subview.isEnabled = false
                    }
                }
            }
        }
    }
    
    /*!
     @function    configureCell
     @abstract    This function is used to do the basic configuration of the tableviewcell.
     */
    func configureCell() {
        
        self.btnAddBag.setBackgroundImage(UIImage.image(with: UIColor(red: 154.0/255.0, green: 171.0/255.0, blue: 158.0/255.0, alpha: 1.0)), for: .normal)
        self.btnAddBag.setBackgroundImage(UIImage.image(with: UIColor.lightGray), for: .disabled)
        
        if self.quantityData.count > 0 {
            self.quantityData.removeAll()
        }
        
        if self.maxQuantity == 0 {
            return
        }
        for i in 1..<self.maxQuantity+1 {
            self.quantityData.append(String(i))
        }
        configPicker(picker: pickerQuantity, stringData: self.quantityData)
    }
    
    // MARK:
    // MARK: - Custom PickerView Methods
    func configPicker(picker : CustomePickerView,stringData : [String] ) {
        
        picker.pickerType = .StringPicker
        //let stringData = ["AVFoundation","Accelerate","AddressBook","AddressBookUI","AssetsLibrary"]
        picker.stringPickerData = stringData
        picker.pickerRow.font = UIFont(name: "American Typewriter", size: 30)
        picker.toolbar.barTintColor = .darkGray
        picker.toolbar.tintColor = .black
        
        picker.stringDidChange = { (index) in
            
            print("selectedString ", self.quantityData[index])
            self.delegate?.selectedQuantity(quantity: self.quantityData[index])
            
            let selectedQuantity:Int64 = Int64(self.quantityData[index])!
            for subview in self.productTagListView.tagViews {
                
                subview.isEnabled = true
                let maxQuantity = self.productDetail?.getProductQuantityBySize(productSize: subview.currentTitle!)
                if selectedQuantity > maxQuantity! {
                    subview.isEnabled = false
                }
            }
            self.configureBagCell()
        }
    }
    
    /*!
     @function    configureBagCell
     @abstract    This function is used to configure the productsize cell to enable/disable AddToBag button.
     */
    func configureBagCell() {
        
        self.btnAddBag.isEnabled = false
        if (self.productDetail != nil) {
            if (self.productDetail?.productSizesArray.count)! > 0 {
                
                var isSizeSelected: Bool = false
                for subview in (self.productTagListView.tagViews) {
                    if subview.isSelected {
                        isSizeSelected = true
                        break
                    }
                }
                if (isSizeSelected && (self.pickerQuantity.text != "")) {
                    self.btnAddBag.isEnabled = true
                }
            } else {
                if self.pickerQuantity.text != "" {
                    self.btnAddBag.isEnabled = true
                }
            }
        }
    }
    
    // MARK:
    // MARK: TagListView Delegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        print("Tag pressed: \(title), \(sender)")
        self.delegate?.tagPressedForSize(title: title)
        
        let quantity =  self.productDetail?.getProductQuantityBySize(productSize: title)
        self.maxQuantity = quantity!
        self.configureCell()
        
        for subview in self.productTagListView.tagViews {
            if subview == tagView {
                if quantity == 0 {
                    tagView.isEnabled = false
                }
                tagView.isSelected = !tagView.isSelected
            } else {
                subview.isSelected = false
            }
        }
        self.configureBagCell()
    }
    
    //MARK:
    //MARK: Action Events
    @IBAction func btnAddBagClicked(_ sender:UIButton) {
        _ = SweetAlert().showAlert(appName, subTitle: "Add to bag clicked.", style: AlertStyle.none)
    }
}
