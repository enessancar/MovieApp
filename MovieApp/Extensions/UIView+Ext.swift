//
//  UIView+Ext.swift
//  MovieApp
//
//  Created by Enes Sancar on 3.10.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
