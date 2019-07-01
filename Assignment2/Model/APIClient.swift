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

//    func requestArticle() -> Observable<[Article]> {
//        APIClient().send(apiRequest: <#T##ApiRequest#>)
//    }

    func send(apiRequest: ApiRequest) -> Observable<[Article]> {
        return Observable<[Article]>.create { observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let str = String(decoding: (data ?? nil)!, as: UTF8.self)
                   // print(str)

                    let model =  try? JSONDecoder().decode(ArticleResult.self, from: data ?? Data())
                    observer.onNext(model?.articeList ?? [])

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
