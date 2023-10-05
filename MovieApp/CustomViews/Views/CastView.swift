//
//  CastView.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class CastView: UIStackView {
    
    private var superContainerView: UIStackView!
    private let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    init(superContainerView: UIStackView) {
        super.init(frame: .zero)
        self.superContainerView = superContainerView
        
        configureCastView()
        configureTitleLabel()
        configureCollectionView()
    }
    
    private func configureCastView() {
        superContainerView.addArrangedSubview(self)
        axis = .vertical
        distribution = .fill
    }
    
    private func configureTitleLabel() {
        addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        titleLabel.text = "Top Billed Cast"
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIhelper.createCastFlowLayout())
        addArrangedSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopBilledCell.self, forCellWithReuseIdentifier: TopBilledCell.identifier)
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
    }
}
