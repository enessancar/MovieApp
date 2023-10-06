//
//  PersonDetailVC.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit

final class PersonDetailVC: DataLoadingVC {
    
    private let scrollView = UIScrollView(frame: .zero)
    private let containerStackView = UIStackView(frame: .zero)
    
    private var headerView: PersonHeaderView!
    private let biographyLabel = GFBodyLabel(textAlignment: .left)
    private var showMoreButton: UIButton!
    private var moviesSectionView: SectionView!
    private var showsSectionView: SectionView!
    
    private var emptyView: UIView!
    private var person: Person!
    
    private var movies: [ContentResult] = []
    private var shows: [ContentResult] = []
    
    private let padding: CGFloat = 10
    private var isShowingMore: Bool = false
    
    init(actor: Person) {
        super.init(nibName: nil, bundle: nil)
        self.person = actor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        title = person.name
        
        configureScrollView()
        configureContainerStackView()
        
        configureHeaderView()
        configureBiograpyLabel()
        configureShowMoreButton()
        
        configureMoviesSectionView()
        configureShowsSectionView()
        
        getPersonShows()
        getPersonMovies()
    }
}

extension PersonDetailVC {
    private func getPersonShows() {
        guard let personID = person.id?.description else { return }
        let urlString = ApiUrls.personShows(personId: personID)
        
        NetworkingManager.shared.downloadPersonContent(urlString: urlString) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let contents):
                if contents.isEmpty {
                    self.configureEmptyStateView(superStackView: self.containerStackView, collectionView: self.showsSectionView.collectionView, message: "The person haven't played in a show so far")
                    return
                }
                self.shows = contents
                DispatchQueue.main.async {
                    self.showsSectionView.collectionView.reloadData()
                }
            case .failure(let failure):
                self.configureEmptyStateView(superStackView: self.containerStackView, collectionView: self.showsSectionView.collectionView, message: "The person haven't played in a show so far.")
                print(failure.localizedDescription)
            }
        }
    }
    
    private func getPersonMovies() {
        guard let personID = person.id?.description else { return }
        let urlString = ApiUrls.personMovies(personId: personID)
        
        NetworkingManager.shared.downloadPersonContent(urlString: urlString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let contents):
                if contents.isEmpty {
                    self.configureEmptyStateView(superStackView: self.containerStackView, collectionView: self.moviesSectionView.collectionView, message: "The person haven't played in a movie so far.")
                }
                self.movies = contents
                DispatchQueue.main.async {
                    self.moviesSectionView.collectionView.reloadData()
                }
            case .failure(let failure):
                self.configureEmptyStateView(superStackView: self.containerStackView, collectionView: self.moviesSectionView.collectionView, message: "The person haven't played in a movie so far.")
                printContent(failure.localizedDescription)
            }
        }
    }
}

extension PersonDetailVC {
    private func configureHeaderView() {
        headerView = PersonHeaderView(superContainerView: containerStackView, person: person)
    }
    
    private func configureBiograpyLabel() {
        containerStackView.addArrangedSubview(biographyLabel)
        biographyLabel.text = person.biography
    }
}

//MARK: - ShowMore Button
extension PersonDetailVC {
    private func configureShowMoreButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.biographyLabel.lineCount > 5 {
                self.biographyLabel.numberOfLines = 5
            } else {
                self.showMoreButton.isHidden = true
                self.containerStackView.setCustomSpacing(2 * self.padding, after: self.biographyLabel)
            }
        }
        showMoreButton = UIButton(frame: .zero)
        containerStackView.addArrangedSubview(showMoreButton)
        containerStackView.setCustomSpacing(0, after: biographyLabel)
        
        showMoreButton.setTitle("Read more...", for: .normal)
        showMoreButton.contentHorizontalAlignment = .left
        showMoreButton.setTitleColor(.link, for: .normal)
        
        showMoreButton.addTarget(self, action: #selector(showMoreButtonAction), for: .touchUpInside)
    }

    @objc private func showMoreButtonAction() {
        if !isShowingMore {
            showMoreButton.setTitle("Less", for: .normal)
            biographyLabel.numberOfLines = 0
            isShowingMore = true
        } else {
            showMoreButton.setTitle("Read more...", for: .normal)
            biographyLabel.numberOfLines = 5
            isShowingMore = false
        }
    }
}

//MARK: - Movie, Shows Section
extension PersonDetailVC {
    private func configureMoviesSectionView() {
        moviesSectionView = SectionView(containerStackView: containerStackView, title: "Movies")
        moviesSectionView.collectionView.delegate = self
        moviesSectionView.collectionView.dataSource = self
    }
    
    private func configureShowsSectionView() {
        showsSectionView = SectionView(containerStackView: containerStackView, title: "Shows")
        showsSectionView.collectionView.delegate = self
        showsSectionView.collectionView.dataSource = self
    }
}

//MARK: - Empty View
extension PersonDetailVC {
    private func configureEmptyStateView(superStackView: UIStackView, collectionView: UICollectionView, message: String) {
        DispatchQueue.main.async {
            collectionView.removeFromSuperview()
            
            self.emptyView = UIView(frame: .zero)
            superStackView.addArrangedSubview(self.emptyView)
            
            self.emptyView.backgroundColor = .systemBackground
            self.emptyView.snp.makeConstraints { make in
                make.height.equalTo(30)
            }
            let messageLabel = GFBodyLabel(textAlignment: .left)
            self.emptyView.addSubview(messageLabel)
            messageLabel.text = message
            messageLabel.snp.makeConstraints { make in
                make.edges.equalTo(self.emptyView)
            }
        }
    }
}

extension PersonDetailVC {
    private func getContent(urlString: String) {
        showLoadingView()
        NetworkingManager.shared.donwloadContentDetail(urlString: urlString) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let contentDetail):
                guard let id = contentDetail.id?.description else { return }
                let urlString = contentDetail.isMovie ? ApiUrls.movieVideo(id: id) : ApiUrls.showVideo(id: id)
                
                self.getVideo(urlString: urlString) { [weak self] videoResult in
                    guard let self else { return }
                   
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func getVideo(urlString: String, completion: @escaping(VideoResult?) -> ()) {
        NetworkingManager.shared.downloadVideo(urlString: urlString) { [weak self]
            result in
            guard let self else { return }
            completion(result)
        }
    }
}

extension PersonDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviesSectionView.collectionView {
            return movies.count
        } else {
            return shows.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as? ContentCell else {
            fatalError()
        }
        if collectionView == moviesSectionView.collectionView {
            cell.set(content: movies[indexPath.item])
            return cell
        }
        cell.set(content: shows[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == moviesSectionView.collectionView {
            guard let contentID = movies[indexPath.item].id?.description else {
                return
            }
            let urlString = ApiUrls.movieDetail(id: contentID)
            getContent(urlString: urlString)
        }
        else if collectionView == showsSectionView.collectionView {
            guard let contentID = shows[indexPath.item].id?.description else { return}
            let urlString = ApiUrls.showDetail(id: contentID)
            getContent(urlString: urlString)
        }
    }
}

//MARK: - Scroll View, Container StackView
extension PersonDetailVC {
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureContainerStackView() {
        scrollView.addSubview(containerStackView)
        
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(top: 2 * padding, left: padding, bottom: 2 * padding, right: padding)
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        containerStackView.spacing = 2 * padding
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
}
