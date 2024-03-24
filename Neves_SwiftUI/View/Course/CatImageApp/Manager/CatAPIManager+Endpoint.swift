//
//  CatAPIManager+Endpoint.swift
//  Neves_SwiftUI
//
//  Created by aa on 2024/3/24.
//

import SwiftUI

extension CatAPIManager {
    enum Endpoint {
        case images
        case addToFavorite(bodyData: Data)
        case favorites
        case removeFromFavorite(id: Int)
        
        var request: URLRequest {
            switch self {
            case .images:
                return URLRequest(url: "https://api.thecatapi.com/v1/images/search?limit=10")
                
            case let .addToFavorite(bodyData):
                var request = URLRequest(url: "https://api.thecatapi.com/v1/favourites")
                request.httpMethod = "POST"
                request.httpBody = bodyData
                // 声明`httpBody`的类型（让服务器那边知道如何解析）：是json格式
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                return request
                
            case .favorites:
                // TODO: 补上分页参数
                return URLRequest(url: "https://api.thecatapi.com/v1/favourites")
                
            case let .removeFromFavorite(id):
                var request = URLRequest(url: URL(string: "https://api.thecatapi.com/v1/favourites/\(id)")!)
                request.httpMethod = "DELETE" // 📢📢📢
                return request
            }
        }
    }
}
