//
//  TopBilledCell.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit
import SnapKit

final class TopBilledCell: UICollectionViewCell {
    static let identifier = "TopBilledCell"
    
    private let posterImageView = PosterImageView(frame: .zero)
    private let nameLabel = GFTitleLabel(textAlignment: .center, fontSize: 18)
    private let characterLabel = GFBodyLabel(textAlignment: .center)
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray.withAlphaComponent(0.1)
        layer.cornerRadius = 10
        
        configurePosterImageView()
        configureNameLabel()
        configureCharacterLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.cancelDownloading()
    }
    
    public func set(_ cast: Cast) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: cast._profilePath))
        nameLabel.text = cast.name
        characterLabel.text = cast.character
    }
    
    private func configurePosterImageView() {
        addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(225)
        }
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.leading.trailing.equalTo(posterImageView)
        }
    }
    
    private func configureCharacterLabel() {
        addSubview(characterLabel)
        characterLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.height.equalTo(nameLabel)
        }
    }
}
