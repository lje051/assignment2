//
//  Article.swift
//  Assignment2
//
//  Created by Jeeeun Lim on 17/06/2019.
//  Copyright © 2019 ASPN. All rights reserved.
//

import Foundation
import UIKit

struct Article {
  
  var articleTitle :String
  var articleDescription :String
  var articleImageUrl :String
  
   
  

   init(name: String, artist: String, previewURL: String) {
    self.articleTitle = name
    self.articleDescription = artist
    self.articleImageUrl = previewURL
  }
  
}; extension Article: Decodable {
    enum CodingKeys: String, CodingKey {
        case articleTitle = "trackName"
        case articleDescription  = "artistName"
        case articleImageUrl = "artworkUrl100"
        
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
        let name: String = try container.decode(String.self, forKey: .articleTitle) // extracting the data
        let desc: String = try container.decode(String.self, forKey: .articleDescription) // extracting the data
        let articleurl: String = try container.decode(String.self, forKey: .articleImageUrl) // extracting the data
        
        self.init(name: name, artist: desc, previewURL: articleurl) // initializing our struct
    }
}
