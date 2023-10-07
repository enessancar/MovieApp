//
//  ContentDetailVC.swift
//  MovieApp
//
//  Created by Enes Sancar on 5.10.2023.
//

import UIKit
import SnapKit
import WebKit

final class ContentDetailVC: DataLoadingVC, WKUIDelegate {
    
    private var scrollView: UIScrollView!
    private var containerStackView: UIStackView!
    
    private var headerView: HeaderView!
    private var overviewLabel: GFBodyLabel!
    private var castView: CastView!
    private var similarSectionView: SectionView!
    
    private let padding: CGFloat = 16
    
    private var contentDetail: ContentDetail!
    private var cast: [Cast] = []
    private var videoResult: VideoResult?
    
    private var similarContents: [ContentResult] = []
    
    private var emptyView: UIView!
    
    private var webView: WKWebView!
    
    private var isSaved: Bool {
        Store.isSaved(content: contentDetail)
    }
    
    init(contentDetail: ContentDetail, videoResult: VideoResult?) {
        super.init(nibName: nil, bundle: nil)
        self.contentDetail = contentDetail
        self.videoResult = videoResult
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        
        title = contentDetail.isMovie ? contentDetail.title : contentDetail.name
        
        configureScrollView()
        configureContainerStackView()
        
        configureHeaderView()
        configureOverviewLabel()
        configureWebView()
        configureCastView()
        configureSimilarSectionView()
        
        setViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        updateRightBarButton()
    }
    
    @objc private func updateContent() {
        Store.update(content: contentDetail)
        
        updateRightBarButton()
    }
    
    private func updateRightBarButton() {
        if isSaved {
            let chechmarkButton = UIBarButtonItem(image: UIImage(systemName: "chechmark"), style: .done, target: self, action: #selector(updateContent))
            navigationItem.rightBarButtonItem = chechmarkButton
        }
        else {
            let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(updateContent))
            navigationItem.rightBarButtonItem = plusButton
        }
    }
}

extension ContentDetailVC {
    private func getCast() {
        let urlString = contentDetail.isMovie ? ApiUrls.movieCredits(id: contentDetail.id?.description ?? "") : ApiUrls.showCredits(id: contentDetail.id?.description ?? "")
        
        NetworkingManager.shared.downloadCast(urlString: urlString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cast):
                if cast.isEmpty {
                    self.configureEmptyView(superStackView: self.castView, collectionView: castView.collectionView, message: "No cast info")
                    return
                }
                if cast.count > 10 {
                    self.cast = Array(cast.prefix(upTo: 10))
                } else {
                    self.cast = cast
                }
                DispatchQueue.main.async {
                    self.castView.collectionView.reloadData()
                }
            case .failure(let failure):
                self.configureEmptyView(superStackView: self.castView, collectionView: castView.collectionView, message: "No cast info")
                print(failure.localizedDescription)
            }
        }
    }
    
    private func getSimilarContents() {
        let urlString = contentDetail.isMovie ? ApiUrls.similarMovies(movieId: contentDetail.id?.description ?? "", page: 1) : ApiUrls.similarShows(showId: contentDetail.id?.description ?? "", page: 1)
        
        NetworkingManager.shared.donwloadContent(urlString: urlString) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let similaryContents):
                if similaryContents.isEmpty {
                    self.configureEmptyView(superStackView: self.similarSectionView, collectionView: self.similarSectionView.collectionView, message: "No similar movies info")
                    return
                }
                self.similarContents = similaryContents
                DispatchQueue.main.async {
                    self.similarSectionView.collectionView.reloadData()
                }
            case .failure(let failure):
                self.configureEmptyView(superStackView: self.similarSectionView, collectionView: self.similarSectionView.collectionView, message: "No similar movies info")
                print(failure.localizedDescription)
            }
        }
    }
    
    private func getContentDetail(urlString: String) {
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
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ContentDetailVC(contentDetail: contentDetail, videoResult: videoResult), animated: true)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.view.safeAreaInsets.top), animated: true)
                        if !self.cast.isEmpty {
                            self.castView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                        }
                        if !self.similarContents.isEmpty {
                            self.similarSectionView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
                        }
                    }
                }
                
            case .failure(let failure):
                printContent(failure.localizedDescription)
            }
        }
    }
    
    private func getPersonDetail(urlString: String) {
        showLoadingView()
        
        NetworkingManager.shared.downloadPerson(urlString: urlString) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let person):
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(PersonDetailVC(actor: person), animated: true)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
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

extension ContentDetailVC {
    private func configureHeaderView() {
        headerView = HeaderView(superContainerView: containerStackView)
    }
    
    private func configureOverviewLabel() {
        overviewLabel = GFBodyLabel(textAlignment: .left)
        containerStackView.addArrangedSubview(overviewLabel)
    }
    
    private func configureCastView() {
        castView = CastView(superContainerView: containerStackView)
        castView.collectionView.delegate = self
        castView.collectionView.dataSource = self
    }
    
    private func configureSimilarSectionView() {
        similarSectionView = SectionView(containerStackView: containerStackView, title: contentDetail.isMovie ? "Similar Movies" : "Similar Shows")
        similarSectionView.collectionView.delegate = self
        similarSectionView.collectionView.dataSource = self
    }
    
    private func configureEmptyView(superStackView: UIStackView, collectionView: UICollectionView, message: String) {
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
    
    private func configureWebView() {
        guard let videoResult else { return }
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        containerStackView.addArrangedSubview(webView)
        
        webView.uiDelegate = self
        webView.scrollView.isScrollEnabled = false
        
        let myURL = URL(string:"https://www.youtube.com/embed/\(videoResult.key ?? "")")
        let request = URLRequest(url: myURL!)
        webView.load(request)
        
        webView.snp.makeConstraints { make in
            make.height.equalTo((UIScreen.main.bounds.width - (2 * padding)) * 0.562)
        }
        webView.backgroundColor = .red
    }
    
    private func setViewData() {
        headerView.setHeaderView(contentDetail: contentDetail)
        overviewLabel.text = contentDetail.overview
        
        getCast()
        getSimilarContents()
    }
}

extension ContentDetailVC {
    private func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureContainerStackView() {
        containerStackView = UIStackView(frame: .zero)
        scrollView.addSubview(containerStackView)
        
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(top: 2 * padding, left: padding, bottom: 2 * padding, right: padding)
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        containerStackView.spacing = 20
        
        containerStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
}

//MARK: - Collection View
extension ContentDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castView.collectionView {
            return cast.count
        } else if collectionView == similarSectionView.collectionView {
            return similarContents.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopBilledCell.identifier, for: indexPath) as? TopBilledCell else {
                return UICollectionViewCell()
            }
            cell.set(cast[indexPath.item])
            return cell
        } else if collectionView == similarSectionView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as? ContentCell else {
                return UICollectionViewCell()
            }
            cell.set(content: similarContents[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarSectionView.collectionView {
            let urlString = contentDetail.isMovie ? ApiUrls.movieDetail(id: similarContents[indexPath.item].id?.description ?? "") :
            ApiUrls.showDetail(id: similarContents[indexPath.item].id?.description ?? "")
            self.getContentDetail(urlString: urlString)
        }
        else if collectionView == castView.collectionView {
            guard let personID = cast[indexPath.item].id?.description else { return }
            let urlString = ApiUrls.person(id: personID)
            self.getPersonDetail(urlString: urlString)
        }
    }
}
