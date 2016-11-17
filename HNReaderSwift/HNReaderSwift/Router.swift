//
//  Router.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import Foundation
import Alamofire

enum GetRouter: URLRequestConvertible {
    static let baseURLString = "https://hacker-news.firebaseio.com/"

    case getItem(String)
    case getList()

    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
                return .get
        }

        let params: ([String: Any]?) = {
                return nil
        }()

        let url:URL = {
            let relativePath:String?
            switch self {
            case .getItem(let path):
                relativePath = path
            case .getList:
                relativePath = TopStoriesPath
            }

            var url = URL(string: GetRouter.baseURLString)!
            if let relativePath = relativePath {
                url = url.appendingPathComponent(relativePath)
            }
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
