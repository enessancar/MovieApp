//
//  CastModel.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import Foundation

struct CastModel: Codable {
    let cast: [Cast]?
}

struct Cast: Codable {
    let id: Int?
    let name: String?
    let profilePath: String?
    let character: String?
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case profilePath = "profile_path"
        case character
    }
    
    var _profilePath: String {
        profilePath ?? "N/A"
    }
}
