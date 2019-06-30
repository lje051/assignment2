//
//  Article.swift
//  Assignment2
//
//  Created by Jeeeun Lim on 17/06/2019.
//  Copyright © 2019 ASPN. All rights reserved.
//

import Foundation
import UIKit

struct Article: Codable {
  
  var articleTitle = ""
  var articleDescription = ""
  var articleImageUrl = ""
  
    private enum CodingKeys: String, CodingKey {
        case articleTitle = "trackName"
        case articleDescription  = "artistName"
        case articleImageUrl = "artworkUrl100"

    }
 
  

   init(name: String, artist: String, previewURL: String) {
    self.articleTitle = name
    self.articleDescription = artist
    self.articleImageUrl = previewURL
  }
  
}
