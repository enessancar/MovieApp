//
//  CastModel.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import Foundation

struct CastModel: Decodable {
    let cast: [Cast]?
}

struct Cast {
    let id: Int?
    let name: String?
    let profilePath: String?
    let character: String?
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case profilePath = "profile_path"
        case character
    }
}
