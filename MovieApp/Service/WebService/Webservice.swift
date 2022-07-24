
import Alamofire

protocol ServiceProtocol {
    func fetchMovies(onSuccess : @escaping(Movies?) -> () , onError : @escaping (AFError) -> ())
}

final class Service : ServiceProtocol {
    func fetchMovies(onSuccess: @escaping (Movies?) -> (), onError: @escaping (AFError) -> ()) {
        ServiceManager.shared.fetch(path: <#T##String#>, onSuccess: <#T##(Decodable & Encodable) -> ()#>, onError: <#T##(AFError) -> ()#>)
    }
}
