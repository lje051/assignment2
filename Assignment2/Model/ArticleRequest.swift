//
//  APIRequest.swift
//  Assignment2
//
//  Created by Jeeeun Lim on 30/06/2019.
//  Copyright © 2019 ASPN. All rights reserved.
//

import Foundation
class ArticleRequest: ApiRequest {
    var method = RequestType.GET
    var path = ""
    var parameters = [String: String]()
    
    init(name: String) {
        parameters["term"] = name
    }
}
