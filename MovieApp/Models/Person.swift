//
//  Person.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import Foundation

struct Person: Decodable {
    let biography, birthday, deathday: String?
    let id: Int?
    let name, placeOfBirth, profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case biography, birthday, deathday, id, name
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
    }
    
    var birthDeathDay: String {
        guard let birthday else { return "N/A" }
        
        guard let deathday else {
            return birthday.replacingOccurrences(of: "-", with: "/")
        }
        
        return birthday.replacingOccurrences(of: "-", with: "/") + " - " + deathday.replacingOccurrences(of: "-", with: "/")
    }
    
    var birthLocation: String {
        guard let placeOfBirth else {
            return "N/A"
        }
        return placeOfBirth
    }
    
    var _profilePath: String {
        profilePath ?? "N/A"
    }
}
