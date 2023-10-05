//
//  PersonHeaderVşew.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class PersonHeaderView: UIView {
    
    private var superContainerView: UIStackView!
    
    private let posterImageView = PosterImageView(frame: .zero)
    private let nameLabel = GFTitleLabel(textAlignment: .left, fontSize: 22)
    
    private let attributesStackView = UIStackView(frame: .zero)
    private let dateLabel = LabelWithImage()
    private let locationLabel = LabelWithImage()
    
    private let padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(superContainerView: UIStackView!, person: Person) {
        self.init(frame: .zero)
        self.superContainerView = superContainerView
        
        configureView()
        configurePosterImageView()
        configureNameLabel()
        configureAttributesStackView()
        
        setHeaderView(person: person)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHeaderView(person: Person) {
        posterImageView.downloadImage(urlString: ApiUrls.image(path: person._profilePath))
        
        nameLabel.text = person.name
        
        dateLabel.setLabelwithImage(text: person.birthDeathDay, systemImage: SystemImages.calendarImage)
        locationLabel.setLabelwithImage(text: person.birthLocation, systemImage: SystemImages.locationImage)
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
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top)
            make.leading.equalTo(posterImageView.snp.trailing).offset(2 * padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
    }
    
    private func configureAttributesStackView() {
        addSubview(attributesStackView)
        
        attributesStackView.axis = .vertical
        attributesStackView.spacing = padding / 2
        attributesStackView.distribution = .fill
        
        attributesStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2 * padding)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        attributesStackView.addArrangedSubview(dateLabel)
        attributesStackView.addArrangedSubview(locationLabel)
    }
}
