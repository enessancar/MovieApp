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
    
    func donwloadContent(urlString: String, completion: @escaping(Result<[ContentResult], CustomError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let moviesData = try JSONDecoder().decode(Content.self, from: data)
                
                guard let results = moviesData.results else {
                    completion(.failure(.unableToComplete))
                    return
                }
                completion(.success(results))
            } catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }.resume()
    }
    
    func donwloadContentDetail(urlString: String, completion: @escaping(Result<ContentDetail, CustomError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let moviesDetail = try JSONDecoder().decode(ContentDetail.self, from: data)
                completion(.success(moviesDetail))
                
            } catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }.resume()
    }
    
    func donwloadContentBySearch(urlString: String, completion: @escaping(Result<[SearchResult], CustomError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let searchData = try JSONDecoder().decode(SearchModel.self ,from: data)
                
                guard let result = searchData.results else {
                    completion(.failure(.unableToComplete))
                    return
                }
                completion(.success(result.filter({ $0.mediaType == .movie || $0.mediaType == .tv })))
            } catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }.resume()
    }
    
    func downloadPerson(urlString: String, completion: @escaping (Result<Person, CustomError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(.success(person))
                
            } catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }.resume()
    }
    
    func downloadPersonContent(urlString: String, completion: @escaping (Result<[ContentResult], CustomError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let person = try JSONDecoder().decode(PersonContent.self, from: data)
                
                completion(.success(person.cast))
                
            } catch {
                completion(.failure(.unableToParseFromJSON))
            }
        }.resume()
    }
}
