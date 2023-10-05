//
//  HeaderCollectionReusableView.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "HeaderCollectionReusableView"
    
    private var headerLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHeaderLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHeaderLabel() {
        addSubviews(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview()
        }
    }
    
    public func setHeader(text: String) {
        headerLabel.text = text
    }
}
