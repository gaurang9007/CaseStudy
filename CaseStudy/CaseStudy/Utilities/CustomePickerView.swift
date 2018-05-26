//
//  CustomePickerView.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 19/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

/// MARK:- CustomePickerView
class CustomePickerView: UITextField {
    
    var identifier: Int!
    
    open var pickerType: CustomPickerType? {
        
        didSet {
            guard let type = pickerType else {
                return
            }
            
            switch type {
            case .DatePicker:
                datePicker = UIDatePicker()
                break
            case .StringPicker:
                stringPicker = UIPickerView()
                break
            }
            inputAccessoryView = toolbar
        }
    }
    
    // For DatePicker
    open var dateFormatter = DateFormatter()
    open var dateDidChange: ((Date) -> Void)?
    
    open var datePicker: UIDatePicker? {
        get {
            return self.inputView as? UIDatePicker
        }
        set {
            inputView = newValue
            dateFormatter.dateFormat = "MM/dd/YYYY"
        }
    }
    
    // For String Picker
    
    open var stringPickerData: [String]?
    open var stringDidChange: ((Int) -> Void)?
    
    open var pickerRow: UILabel {
        let pickerLabel = UILabel()
        pickerLabel.textColor = .black
        pickerLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        pickerLabel.textAlignment = .center
        pickerLabel.sizeToFit()
        return pickerLabel
    }
    
    open var stringPicker: UIPickerView? {
        get {
            return self.inputView as? UIPickerView
        }
        set(picker) {
            picker?.delegate = self
            inputView = picker
        }
    }
    
    
    // Configurations
    
    open var toolbar: UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(CustomePickerView.doneAction))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(CustomePickerView.cancelAction))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        inputAccessoryView = toolBar
        return toolBar
    }
    
    func doneAction() {
        
        guard let type = pickerType else {
            return
        }
        
        switch type {
        case .DatePicker:
            
            let date = datePicker!.date
            self.text = dateFormatter.string(from: date)
            
            dateDidChange?(date)
            
            break
        case .StringPicker:
            let row = stringPicker!.selectedRow(inComponent: 0)
            self.text = stringPickerData![row]
            
            stringDidChange?(row)
            
            break
            
        }
        resignFirstResponder()
    }
    
    func cancelAction() {
        resignFirstResponder()
    }
    
    
}
