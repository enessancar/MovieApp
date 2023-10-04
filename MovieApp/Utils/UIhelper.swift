//
//  UIhelper.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import UIKit

enum UIhelper {
    static func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
        let itemWidth = width / 2.15
        
        flowlayout.itemSize = .init(width: itemWidth, height: itemWidth * 1.5)
        flowlayout.scrollDirection = .horizontal
        return flowlayout
    }
    
    static func createCastFlowLayout() -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        
        flowlayout.itemSize = .init(width: 160, height: 290)
        flowlayout.scrollDirection = .horizontal
        return flowlayout
    }
    
    static func createExploreFlowLayout() -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
        let itemWidth = width / 2.15
        
        flowlayout.sectionInset = .init(top: 10, left: 10, bottom: 30, right: 10)
        flowlayout.itemSize = .init(width: itemWidth, height: itemWidth * 1.5)
        flowlayout.scrollDirection = .vertical
        
        return flowlayout
    }
    
    static func createWatchlistFlowLayout() -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
        let itemWidth = width / 3.3
        
        flowlayout.sectionInset = .init(top: 10, left: 10, bottom: 30, right: 10)
        flowlayout.itemSize = .init(width: itemWidth, height: itemWidth * 1.5)
        flowlayout.scrollDirection = .vertical
        
        return flowlayout
    }
}
