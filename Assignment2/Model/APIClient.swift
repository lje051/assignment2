import Foundation
import RxSwift

class APIClient {
    private let baseURL = URL(string: "https://itunes.apple.com/search/country=kr&media=software")!
    
    func send<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let str = String(decoding: (data ?? nil)!, as: UTF8.self)
                    print(str)
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
