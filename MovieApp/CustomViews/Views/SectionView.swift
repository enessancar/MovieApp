//
//  SectionView.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
    
    private var superContainerView: UIStackView!
    
    private var posterImageView = PosterImageView(frame: .zero)
    private var titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 22)
    
    private var attributesStackView = UIStackView(frame: .zero)
    private var dateLabel  = LabelWithImage()
    private var genreLabel = LabelWithImage()
    private var runtimeLabel = LabelWithImage()
    private var statusLabel = LabelWithImage()
    private var ratingLabel = LabelWithImage()
    
    let padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(superContainerView: UIStackView) {
        self.init(frame: .zero)
        self.superContainerView = superContainerView
        
        configureView()
        
        configurePosterImageView()
        configureTitleLabel()
        
        configureAttributesStackView()
        configureDateLabel()
        configureGenreLabel()
        configureRuntimeLabel()
    }
    
    public func setHeaderView(contentDetail: ContentDetail) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: contentDetail._posterPath))
        
        if contentDetail.isMovie {
            configureRatingLabel()
            
            titleLabel.text = contentDetail.title
            dateLabel.setLabelwithImage(text: contentDetail.releaseDateString, systemImage: SystemImages.calendarImage)
            genreLabel.setLabelwithImage(text: contentDetail.genresString, systemImage: SystemImages.filmImage)
            runtimeLabel.setLabelwithImage(text: contentDetail.runtimeString, systemImage: SystemImages.clockImage)
            ratingLabel.setLabelwithImage(text: contentDetail.rating, systemImage: SystemImages.staurImage)
        } else {
            configureStatusLabel()
            configureRatingLabel()
            
            titleLabel.text = contentDetail.name
            dateLabel.setLabelwithImage(text: contentDetail.startEndDate, systemImage: SystemImages.calendarImage)
            genreLabel.setLabelwithImage(text: contentDetail.genresString, systemImage: SystemImages.filmImage)
            runtimeLabel.setLabelwithImage(text: contentDetail.season, systemImage: SystemImages.clockImage)
            statusLabel.setLabelwithImage(text: contentDetail.status, systemImage: SystemImages.infoImage)
            ratingLabel.setLabelwithImage(text: contentDetail.rating, systemImage: SystemImages.staurImage)
        }
    }
    
    private func configureView() {
        superContainerView.addArrangedSubview(self)
        self.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
    }
    
    private func configurePosterImageView() {
        addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(225)
        }
        posterImageView.backgroundColor = .secondarySystemBackground
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top)
            make.leading.equalTo(posterImageView.snp.trailing).offset(2 * padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
    }
    
    private func configureAttributesStackView() {
        addSubviews(attributesStackView)
        
        attributesStackView.axis = .vertical
        attributesStackView.distribution = .fill
        attributesStackView.spacing = padding / 2
        
        attributesStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2 * padding)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
    
    private func configureDateLabel() {
        attributesStackView.addArrangedSubview(dateLabel)
    }
    
    private func configureGenreLabel() {
        attributesStackView.addArrangedSubview(genreLabel)
    }
    
    private func configureRuntimeLabel() {
        attributesStackView.addArrangedSubview(runtimeLabel)
    }
    
    private func configureStatusLabel() {
        attributesStackView.addArrangedSubview(statusLabel)
    }
    
    private func configureRatingLabel() {
        attributesStackView.addArrangedSubview(ratingLabel)
    }
}
