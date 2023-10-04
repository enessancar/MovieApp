//
//  PersonContent.swift
//  MovieApp
//
//  Created by Enes Sancar on 4.10.2023.
//

import Foundation

struct PersonContent: Decodable {
    let cast, crew: [ContentResult]
}
