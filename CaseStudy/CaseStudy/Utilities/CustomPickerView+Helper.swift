//
//  CustomPickerView+Helper.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 19/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

/// Picker View type

/// - StringPicker: string picker
/// - DatePicker: date picker

public enum CustomPickerType {
    case StringPicker
    case DatePicker
}

//MARK: UIPickerViewDelegate
extension CustomePickerView: UIPickerViewDelegate {
    
    open func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stringPickerData?.count ?? 0
    }
    
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = pickerRow
        label.text = stringPickerData![row]
        return label
    }
    
}
