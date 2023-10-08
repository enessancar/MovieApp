//
//  SearchVC.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit
import SnapKit

final class SearchVC: DataLoadingVC {
    
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    
    private var exploreContent: [ContentResult] = []
    private var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.backButtonTitle = "Search"
        
        configureSearchBar()
        configureCollectionView()
        getExploreContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureSearchBar() {
        searchBar = UISearchBar(frame: .zero)
        view.addSubview(searchBar)
        
        searchBar.placeholder = "Search movie or show"
        searchBar.tintColor = .red
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIhelper.createExploreFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchVC {
    private func getExploreContent() {
        showLoadingView()
        var reloadControl = false
        
        NetworkingManager.shared.donwloadContent(urlString: ApiUrls.trendMovies()) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let exploreMovies):
                self.exploreContent.append(contentsOf: exploreMovies)
                if reloadControl {
                    self.exploreContent.shuffle()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.dismissLoadingView()
                }
                reloadControl = true
            case .failure(let failure):
                print(failure)
            }
        }
        
        NetworkingManager.shared.donwloadContent(urlString: ApiUrls.trendShows()) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let exploreMovies):
                self.exploreContent.append(contentsOf: exploreMovies)
                if reloadControl {
                    self.exploreContent.shuffle()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.dismissLoadingView()
                }
                reloadControl = true
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func getContentDetail(urlString: String, completion: @escaping(ContentDetail?) -> ()) {
        showLoadingView()
        
        NetworkingManager.shared.donwloadContentDetail(urlString: urlString) { [weak self] result in
            guard let self else { return }
            
            self.dismissLoadingView()
            switch result {
            case .success(let movieDetail):
                completion(movieDetail)
            case .failure(let failure):
                print(failure)
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

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exploreContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as? ContentCell else {
            fatalError()
        }
        cell.set(content: exploreContent[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if exploreContent[indexPath.row].name != nil {
            guard let id = exploreContent[indexPath.row].id?.description else { return }
            let urlString = ApiUrls.showDetail(id: id)
            getContentDetail(urlString: urlString) { [weak self] contentDetail in
                guard let self = self, let contentDetail = contentDetail else { return }
                
                guard let id = contentDetail.id?.description else { return }
                let urlString = ApiUrls.showVideo(id: id)
                
                self.getVideo(urlString: urlString) { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                }
            }
        } else {
            guard let id = exploreContent[indexPath.row].id?.description else { return }
            let urlString = ApiUrls.movieDetail(id: id)
            getContentDetail(urlString: urlString) { [weak self] contentDetail in
                guard let self = self, let contentDetail = contentDetail else { return }
                
                guard let id = contentDetail.id?.description else { return }
                let urlString = ApiUrls.movieVideo(id: id)
                
                self.getVideo(urlString: urlString) { [weak self] videoResult in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView else {
            fatalError()
        }
        header.setHeader(text: "Explore")
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.bounds.width, height: 70)
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text!
        searchText = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "%20")
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
        
        getSearchedContents(query: searchText)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension SearchVC {
    private func getSearchedContents(query: String) {
        showLoadingView()
        NetworkingManager.shared.donwloadContentBySearch(urlString: ApiUrls.multiSearch(query: query)) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let contents):
                guard !contents.isEmpty else { return }
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(SearchResultVC(contents: contents, query: query.capitalized.replacingOccurrences(of: "%20", with: " ")), animated: true)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
