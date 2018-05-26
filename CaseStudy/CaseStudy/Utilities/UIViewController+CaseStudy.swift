//
//  UIViewController+CaseStudy.swift
//  CaseStudy
//
//  Created by Gaurang Makawana on 17/07/17.
//  Copyright © 2017 Gaurang Makawana. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func productDetailViewController() -> ProductDetailViewController {
        return UIStoryboard.main().instantiateViewController(withIdentifier: String(describing: ProductDetailViewController.self)) as! ProductDetailViewController
    }
}
