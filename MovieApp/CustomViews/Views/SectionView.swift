//
//  SectionView.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class SectionView: UIStackView {

    private var containerStackView: UIStackView!
    private var titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
    var collectionView: UICollectionView!
    private var title: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(containerStackView: UIStackView, title: String) {
        self.init(frame: .zero)
        self.containerStackView = containerStackView
        self.title = title
        
        configureSectionView()
        configureTitle()
        configureCollectionView()
    }
    
    private func configureSectionView() {
        containerStackView.addArrangedSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        distribution = .fill
        spacing = 5
    }
    
    private func configureTitle() {
        addArrangedSubview(titleLabel)
        titleLabel.text = title
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIhelper.createFlowLayout())
        addArrangedSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.identifier)
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
    }
}
