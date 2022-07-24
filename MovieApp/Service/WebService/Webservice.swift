
import Alamofire

protocol ServiceProtocol {
    func fetchMovies(onSuccess : @escaping(Movies?) -> () , onError : @escaping (AFError) -> ())
}

final class Service : ServiceProtocol {
    func fetchMovies(onSuccess: @escaping (Movies?) -> (), onError: @escaping (AFError) -> ()) {
        ServiceManager.shared.fetch(path: Constant.ServiceEndPoint.moviesServiceEndPoint()) { (response : Movies) in
            onSuccess(response)
        } onError: { error in
            onError(error)
        }

    }
}
