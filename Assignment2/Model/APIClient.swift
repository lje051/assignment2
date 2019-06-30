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
                    
                    if let arr = dict?["results"] as? [[String: Any]] {
                       //print(arr[0])
                       
//                            let previewURLString = model["artworkUrl100"] as? String
//                            let name = model["trackName"] as? String
//                            let artist = model["artistName"] as? String
//                            let article = Article.init()
                     //  tracks.append(Article.init(name: name, artist: artist, previewURL: previewURLString))
                       
               //         let model: T = try JSONDecoder().decode(T.self, from: json)
                            
                        
                        
                        
                      
                    }
                    
                  
                  //  let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                  //  observer.onNext(model)
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
