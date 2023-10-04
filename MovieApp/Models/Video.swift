//
//  Video.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import Foundation

struct Video: Codable {
    let results: [VideoResult]?
}

struct VideoResult: Codable {
    let key: String?
    let type: String?
}
