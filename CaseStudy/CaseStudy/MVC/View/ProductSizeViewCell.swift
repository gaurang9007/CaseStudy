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
}


class ProductSizeViewCell: UITableViewCell {
    
    @IBOutlet weak var productTagListView: TagListView!
    @IBOutlet weak var btnAddBag: UIButton!
    
    @IBOutlet weak var pickerQuantity: CustomePickerView!
    
    var delegate:ProductQuantityDelegate?
    var quantityData = [String]()
    var maxQuantity: Int64 = 0
    var productDetails:ProductDetails! = nil
    
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
        
        for i in 1..<self.maxQuantity+1 {
            self.quantityData.append(String(i))
        }
        configPicker(picker: pickerQuantity, stringData: self.quantityData)
    }
    
    // MARK:
    // MARK: - Custom PickerView Methods
    // MARK:
    
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
        }
    }
    
    /*!
     @function    configureSizeCell
     @abstract    This function is used to initialize the size values and enable/disable the size option.
     */

    func configureSizeCell(delegate:ProductDetailViewController) {
        
        if (self.productDetails != nil) {
        
            if self.productDetails.productSizesArray.count > 0 {
                
                productTagListView.delegate = delegate
                productTagListView.textFont = UIFont.systemFont(ofSize: 15)
                productTagListView.shadowRadius = 2
                productTagListView.shadowOpacity = 0.4
                productTagListView.shadowColor = UIColor.black
                productTagListView.shadowOffset = CGSize(width: 1, height: 1)
                for productSize in self.productDetails.productSizesArray {
                    let sizeName = productSize.size
                    productTagListView.addTag(sizeName!)
                }
                productTagListView.alignment = .left
                
            } else { print("No sizes available") }
            
            for subview in self.productTagListView.tagViews {
                
                subview.isEnabled = true
                if subview.currentTitle == self.productDetails.currentSize {
                    if maxQuantity == 0 {
                        subview.isEnabled = false
                    } else {
                        subview.isSelected = true
                    }
                } else {
                    let maxQuantity = self.productDetails.getProductQuantityBySize(productSize: subview.currentTitle!)
                    if maxQuantity == 0 {
                        subview.isEnabled = false
                    }
                }
            }
        }
    }
}
