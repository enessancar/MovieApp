//
//  ContentDetail.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import Foundation

struct ContentDetail: Decodable {
    let id: Int?
    let title, name, overview, posterPath, releaseDate: String?
    let numberOfSeasons: Int?
    let firstAirDate, lastAirDate, status: String?
    let runtime: Int?
    let genres: [Genre]?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, name, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case numberOfSeasons = "number_of_seasons"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case status, runtime, genres
        case voteAverage = "vote_average"
    }
    
    var isMovie: Bool {
        title != nil && name == nil
    }
    
    var asContentResult: ContentResult {
        ContentResult(id: id, overview: overview, posterPath: posterPath, releaseDate: releaseDate, title: title, name: name, voteAverage: voteAverage)
    }
    
    var genresString: String {
        guard let genres else { return "N/A" }
        let names = genres.map { $0.name ?? "" }
        return names.joined(separator: ",")
    }
    
    var runtimeString: String {
        guard let runtime else { return "N/A" }
        
        let hour = runtime / 60
        let minute = runtime % 60
        
        let hourString = hour == 0 ? "" : "\(hour)h"
        let minuteString = minute == 0 ? "" : "\(minute)m"
        
        return hourString + minuteString
    }
    
    var releaseDateString: String {
        guard let releaseDate else { return "N/A" }
        return releaseDate.replacingOccurrences(of: "-", with: "/")
    }
    
    var startEndDate: String {
        guard let firstAirDate else { return "N/A" }
        guard let lastAirDate else { return String(firstAirDate.prefix(4)) }
        
        return firstAirDate.prefix(4) + "-" + lastAirDate.prefix(4)
    }
    
    var season: String {
        guard let numberOfSeasons else { return "N/A"}
        return "\(numberOfSeasons) Season"
    }
    
    var rating: String {
        guard let voteAverage else { return "N/A" }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter.string(from: NSNumber(value: voteAverage)) ?? "N/A"
    }
}

struct Genre: Decodable {
    let id: Int?
    let name: String?
}
