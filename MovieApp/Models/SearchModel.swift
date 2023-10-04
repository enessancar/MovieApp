//
//  SearchModel.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import Foundation

struct SearchModel: Decodable {
    let page: Int?
    let results: [SearchResult]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SearchResult: Decodable {
    let firstAirDate: String?
    let id: Int?
    let mediaType: MediaType?
    let name: String?
    let posterPath: String?
    let releaseDate, title: String?

    enum CodingKeys: String, CodingKey {
        case firstAirDate = "first_air_date"
        case id
        case mediaType = "media_type"
        case name
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
    
    var releaseDateString: String {
        guard let releaseDate else { return "N/A" }
        return String(releaseDate.prefix(4))
    }
    
    var fistAirDateString: String {
        guard let firstAirDate else { return "N/A" }
        return String(firstAirDate.prefix(4))
    }
}

enum MediaType: String, Decodable {
    case movie = "movie"
    case tv = "tv"
    case person = "person"
}
