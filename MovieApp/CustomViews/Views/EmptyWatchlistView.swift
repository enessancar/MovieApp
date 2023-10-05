//
//  EmptyWatchlistView.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class EmptyWatchlistView: UIView {
    
    private let image = UIImageView(frame: .zero)
    private let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 22)
    private let bodyLabel  = GFBodyLabel(textAlignment: .center)
    
    private let padding: CGFloat = 10
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImage()
        configureTitleLabel()
        configureBodyLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureImage() {
        addSubview(image)
        
        image.sizeToFit()
        image.image = UIImage(systemName: "plus.circle")
        image.tintColor = .tertiarySystemFill
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(110)
            make.top.equalToSuperview().offset(padding)
        }
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview()
        }
        titleLabel.text = "Your watchlist is empty"
    }
    
    private func configureBodyLabel() {
        addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview()
        }
        bodyLabel.text = "Content you add to your watchlist will appear here."
    }
}
