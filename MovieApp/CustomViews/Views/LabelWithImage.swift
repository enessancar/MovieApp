//
//  LabelWithImage.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class LabelWithImage: UIView {
    
    private let imageView = UIImageView(frame: .zero)
    private let label = GFBodyLabel(textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImage()
        configureLabel()
        
        self.snp.makeConstraints { make in
            make.height.equalTo(label.snp.height).offset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLabelwithImage(text: String?, systemImage: UIImage?) {
        label.text = text
        imageView.image = systemImage
    }
    
    private func configureImage() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.width.height.equalTo(25)
        }
    }
    
    private func configureLabel() {
        addSubviews(label)
        label.numberOfLines = 2
        
        label.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(2)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalTo(snp.trailing)
        }
    }
}
