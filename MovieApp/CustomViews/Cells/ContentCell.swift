//
//  ContentCell.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit
import SnapKit

final class ContentCell: UICollectionViewCell {
    static let identifier = "ContentCell"
    
    let posterImageView = PosterImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.cancelDownloading()
    }
    
    func set(content: ContentResult) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: content.posterPath ?? "N/A"))
    }
    
    private func configure() {
        addSubviews(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(4)
            make.trailing.bottom.equalToSuperview().offset(-4)
        }
    }
}
