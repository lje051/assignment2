import Foundation
import RxSwift

class APIClient {
    private let baseURL = URL(string: "https://itunes.apple.com/search/country=kr&media=software")!
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
     var tracks: [Article] = []
    func send<Article>(apiRequest: ApiRequest) -> Observable<Article> {
        return Observable<Article>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let str = String(decoding: (data ?? nil)!, as: UTF8.self)
                    print(str)
                    let dict = self.convertToDictionary(text: str)
                    var a = dict!["results"]! as! Array ;
                    let arr = a.map({($1).value})
                    let encodedData =  arr.data(using: .utf8)
                   
                    
                  
                    let model =  try? JSONDecoder().decode(Article.self, from: encodedData ?? Data())
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
