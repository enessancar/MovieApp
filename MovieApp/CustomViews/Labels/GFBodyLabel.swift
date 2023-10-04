//
//  GFBodyLabel.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit

final class GFBodyLabel: UILabel {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    private func configure() {
        textColor = .secondaryLabel
        font = .preferredFont(forTextStyle: .body)
        numberOfLines = 0
        lineBreakMode = .byTruncatingTail
    }
}
