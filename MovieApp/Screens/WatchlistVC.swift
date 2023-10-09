//
//  WatchlistVC.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit
import SnapKit

final class WatchlistVC: DataLoadingVC {
    
    private var contents: [ContentDetail] = []
    private var collectionView: UICollectionView!
    private var emptyWatchlistView: EmptyWatchlistView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureEmptyWatchlistView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedContents()
    }
    
    private func getSavedContents() {
        Store.retrieveContents { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let contents):
                if contents.isEmpty {
                    self.collectionView.isHidden = true
                    self.emptyWatchlistView.isHidden = false
                    return
                }
                self.collectionView.isHidden = false
                self.emptyWatchlistView.isHidden = true
                
                self.contents = contents
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension WatchlistVC {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIhelper.createWatchlistFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureEmptyWatchlistView() {
        emptyWatchlistView = EmptyWatchlistView(frame: .zero)
        view.addSubview(emptyWatchlistView)
        
        emptyWatchlistView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
    }
}

extension WatchlistVC {
    private func getContentDetail(urlString: String, completion: @escaping(ContentDetail?) -> ()) {
        showLoadingView()
        
        NetworkingManager.shared.donwloadContentDetail(urlString: urlString) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let contentDetail):
                completion(contentDetail)
            case .failure(let failure):
                print(failure)
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

//MARK: - Collection View
extension WatchlistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as? ContentCell else {
            fatalError()
        }
        cell.set(content: contents[indexPath.row].asContentResult)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = contents[indexPath.item]
        
        let urlString = content.isMovie ? ApiUrls.movieDetail(id: content.id?.description ?? "") : ApiUrls.showDetail(id: content.id?.description ?? "")
        
        getContentDetail(urlString: urlString) { [weak self] contentDetail in
            guard let self else { return }
            guard let contentDetail else { return }
            
            guard let id = contentDetail.id?.description else { return }
            let urlString = contentDetail.isMovie ? ApiUrls.movieVideo(id: id) : ApiUrls.showVideo(id: id)
            
            self.getVideo(urlString: urlString) { [weak self] videoResult in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView else {
            fatalError()
        }
        header.setHeader(text: "My Movies & Shows")
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: 0, height: 70)
    }
}
