//
//  SearchCell.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class SearchCell: UITableViewCell {
    static let identifier = "SearchCell"
    
    //MARK: - Properties
    private let posterImageView = PosterImageView(frame: .zero)
    private let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 18)
    private let yearLabel  = GFBodyLabel(textAlignment: .left)
    private let extraInfoLabel = GFBodyLabel(textAlignment: .left)
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        configurePosterImageView()
        configureTitleLabel()
        configureYearLabel()
        configureExtraInfoLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.cancelDownloading()
    }
    
    public func set(content: SearchResult) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: content._posterPath))
        
        if content.mediaType == .movie {
            titleLabel.text = content.title
            yearLabel.text  = content.releaseDateString
            extraInfoLabel.text = "🎬 🍿"
        } else {
            titleLabel.text = content.name
            yearLabel.text = content.fistAirDateString
        }
    }
    
    private func configurePosterImageView() {
        addSubviews(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(60)
            make.height.equalTo(90)
        }
    }
    
    private func configureTitleLabel() {
        addSubviews(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top)
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(35)
        }
    }
    
    private func configureYearLabel() {
        addSubviews(yearLabel)
        yearLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.leading.equalTo(posterImageView.snp.trailing).offset(10)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    private func configureExtraInfoLabel() {
        addSubviews(extraInfoLabel)
        extraInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(yearLabel.snp.trailing).offset(10)
            make.height.equalTo(25)
        }
    }
}
