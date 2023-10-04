//
//  UILabel+Ext.swift
//  MovieApp
//
//  Created by Enes Sancar on 3.10.2023.
//

import UIKit

extension UILabel {
    var lineCount: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}

