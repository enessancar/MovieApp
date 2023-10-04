//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit

final class NetworkingManager {
    static let shared = NetworkingManager()
    private init() {}
    
    let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 250
        return cache
    }()
    
    
}
