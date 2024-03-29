//
//  ShowsVC.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit
import SnapKit

final class ShowsVC: DataLoadingVC {
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    private var popularShows: [ContentResult] = []
    private var airingTodayShows: [ContentResult] = []
    private var onTVShows: [ContentResult] = []
    private var topRatedShows: [ContentResult] = []
        
    private var popularShowsPagination = PaginationControl()
    private var airingTodayShowsPagination = PaginationControl()
    private var onTVShowsPagination = PaginationControl()
    private var topRatedShowsPagination = PaginationControl()
    
    private var popularSectionView: SectionView!
    private var airingTodaySectionView: SectionView!
    private var onTVSectionView: SectionView!
    private var topRatedSectionView: SectionView!
    
    private let padding: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        configureStackView()
        
        configurePopularSectionView()
        configureAiringTodaySectionView()
        configureOnTVSectionView()
        configureTopRatedSectionView()
        
        getPopularShows(page: popularShowsPagination.page)
        getAiringTodayShows(page: airingTodayShowsPagination.page)
        getOnTVShows(page: onTVShowsPagination.page)
        getTopRatedShows(page: topRatedShowsPagination.page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVC()
    }
}

//MARK: SECTION VIEWS
extension ShowsVC {
    private func configurePopularSectionView() {
        popularSectionView = SectionView(containerStackView: stackView, title: "Popular")
        popularSectionView.collectionView.delegate = self
        popularSectionView.collectionView.dataSource = self
    }
    
    private func configureAiringTodaySectionView() {
        airingTodaySectionView = SectionView(containerStackView: stackView, title: "Airing Today")
        airingTodaySectionView.collectionView.delegate = self
        airingTodaySectionView.collectionView.dataSource = self
    }
    
    private func configureOnTVSectionView() {
        onTVSectionView = SectionView(containerStackView: stackView, title: "Now Playing")
        onTVSectionView.collectionView.delegate = self
        onTVSectionView.collectionView.dataSource = self
    }
    
    private func configureTopRatedSectionView() {
        topRatedSectionView = SectionView(containerStackView: stackView, title: "Top Rated")
        topRatedSectionView.collectionView.delegate = self
        topRatedSectionView.collectionView.dataSource = self
    }
}

// MARK: DELEGATE, DATASOURCE
extension ShowsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularSectionView.collectionView {
            return popularShows.count
        } else if collectionView == airingTodaySectionView.collectionView {
            return airingTodayShows.count
        } else if collectionView == onTVSectionView.collectionView {
            return onTVShows.count
        } else if collectionView == topRatedSectionView.collectionView {
            return topRatedShows.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.set(content: popularShows[indexPath.row])
            
            return cell
        } else if collectionView == airingTodaySectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.set(content: airingTodayShows[indexPath.row])
            
            return cell
        } else if collectionView == onTVSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.set(content: onTVShows[indexPath.row])
            
            return cell
        } else if collectionView == topRatedSectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
            cell.set(content: topRatedShows[indexPath.row])
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let width = scrollView.frame.width

        if offsetX >= contentWidth - (width * 3) {
            if scrollView == popularSectionView.collectionView && popularShowsPagination.shouldDownloadMore {
                self.popularShowsPagination.shouldDownloadMore = false
                self.popularShowsPagination.page += 1
                
                self.getPopularShows(page: self.popularShowsPagination.page)
            } else if scrollView == airingTodaySectionView.collectionView && airingTodayShowsPagination.shouldDownloadMore {
                self.airingTodayShowsPagination.shouldDownloadMore = false
                self.airingTodayShowsPagination.page += 1
                
                self.getAiringTodayShows(page: self.airingTodayShowsPagination.page)
            } else if scrollView == onTVSectionView.collectionView && onTVShowsPagination.shouldDownloadMore {
                self.onTVShowsPagination.shouldDownloadMore = false
                self.onTVShowsPagination.page += 1
                
                self.getOnTVShows(page: self.onTVShowsPagination.page)
            } else if scrollView == topRatedSectionView.collectionView && topRatedShowsPagination.shouldDownloadMore {
                self.topRatedShowsPagination.shouldDownloadMore = false
                self.topRatedShowsPagination.page += 1
                
                self.getTopRatedShows(page: self.topRatedShowsPagination.page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == popularSectionView.collectionView {
            
            getShowDetail(id: popularShows[indexPath.row].id?.description ?? "") { [weak self] contentDetail in
                guard let self = self else { return }
                guard let contentDetail = contentDetail else { return }
                
                let trailerUrlString = ApiUrls.showVideo(id: contentDetail.id?.description ?? "")
                
                self.getVideo(urlString: trailerUrlString, completion: { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                })
            }
            
        } else if collectionView == airingTodaySectionView.collectionView {
        
            getShowDetail(id: airingTodayShows[indexPath.row].id?.description ?? "") { [weak self] contentDetail in
                guard let self = self else { return }
                guard let contentDetail = contentDetail else { return }
                
                let trailerUrlString = ApiUrls.showVideo(id: contentDetail.id?.description ?? "")
                
                self.getVideo(urlString: trailerUrlString, completion: { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                })
            }
        
        } else if collectionView == onTVSectionView.collectionView {
        
            getShowDetail(id: onTVShows[indexPath.row].id?.description ?? "") { [weak self] contentDetail in
                guard let self = self else { return }
                guard let contentDetail = contentDetail else { return }
                
                let trailerUrlString = ApiUrls.showVideo(id: contentDetail.id?.description ?? "")
                
                self.getVideo(urlString: trailerUrlString, completion: { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                })
            }
        
        } else if collectionView == topRatedSectionView.collectionView {
        
            getShowDetail(id: topRatedShows[indexPath.row].id?.description ?? "") { [weak self] contentDetail in
                guard let self = self else { return }
                guard let contentDetail = contentDetail else { return }
                
                let trailerUrlString = ApiUrls.showVideo(id: contentDetail.id?.description ?? "")
                
                self.getVideo(urlString: trailerUrlString, completion: { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                })
            }
        
        }
    }
}

// MARK: GET METHODS
extension ShowsVC {
    private func getPopularShows(page: Int) {
        NetworkingManager.shared.donwloadContent(urlString: ApiUrls.popularShows(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.popularShowsPagination.shouldDownloadMore = true
            
            switch result {
            case .success(let popularMovies):
                self.popularShows.append(contentsOf: popularMovies.filter({$0.posterPath != nil}))
                DispatchQueue.main.async {
                    self.popularSectionView.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getAiringTodayShows(page: Int) {
        NetworkingManager.shared.donwloadContent(urlString: ApiUrls.airingTodayShows(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.airingTodayShowsPagination.shouldDownloadMore = true
            
            switch result {
            case .success(let nowPlayingMovies):
                self.airingTodayShows.append(contentsOf: nowPlayingMovies.filter({$0.posterPath != nil}))
                DispatchQueue.main.async {
                    self.airingTodaySectionView.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getOnTVShows(page: Int) {
        NetworkingManager.shared.donwloadContent(urlString: ApiUrls.onTheAirShows(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.onTVShowsPagination.shouldDownloadMore = true
            
            switch result {
            case .success(let upcomingMovies):
                self.onTVShows.append(contentsOf: upcomingMovies.filter({$0.posterPath != nil}))
                DispatchQueue.main.async {
                    self.onTVSectionView.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getTopRatedShows(page: Int) {
        NetworkingManager.shared.donwloadContent(urlString: ApiUrls.topRatedShows(page: page)) { [weak self] result in
            guard let self = self else { return }
            self.topRatedShowsPagination.shouldDownloadMore = true
            
            switch result {
            case .success(let topRatedMovies):
                self.topRatedShows.append(contentsOf: topRatedMovies.filter({$0.posterPath != nil}))
                DispatchQueue.main.async {
                    self.topRatedSectionView.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getShowDetail(id: String, completion: @escaping (ContentDetail?) -> ()) {
        self.showLoadingView()
        NetworkingManager.shared.donwloadContentDetail(urlString: ApiUrls.showDetail(id: id)) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let movieDetail):
                completion(movieDetail)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    private func getVideo(urlString: String, completion: @escaping(VideoResult?) -> ()) {
        NetworkingManager.shared.downloadVideo(urlString: urlString) { [weak self] result in
            
            guard let _ = self else { completion(nil); return }
            
            completion(result)
        }
    }
}

// MARK: configureScrollView, configureStackView
extension ShowsVC {
    private func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureStackView() {
        stackView = UIStackView()
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 3 * padding, left: padding, bottom: 3 * padding, right: padding)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 3 * padding
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
}

// MARK: configureVC
extension ShowsVC {
    private func configureVC() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = "Shows"
    }
}

