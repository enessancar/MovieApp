//
//  PosterImageView.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit

final class PosterImageView: UIImageView {
    
    var dataTask: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleToFill
        backgroundColor = .secondarySystemBackground
    }
    
    func downloadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        image = nil
        
        if let cacheImage = NetworkingManager.shared.cache.object(forKey: urlString as NSString) {
            self.image = cacheImage
            return
        }
        
        self.dataTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, _, error) in
            guard let self,
                  let data,
                  let image = UIImage(data: data) else {
                return
            }
            NetworkingManager.shared.cache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                self.image = image
            }
        })
        dataTask?.resume()
    }
    
    func cancelDownloading() {
        dataTask?.cancel()
        dataTask = nil
    }
}
