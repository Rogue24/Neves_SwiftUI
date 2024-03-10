//
//  CatAPIManager.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/3/4.
//
//  API文档：https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t

import SwiftUI

final class CatAPIManager {
    /// 提供`URLRequest`以决定如何获取`Data`的闭包
    /// - Note: 有默认处理，可供外部更改
    var getData: (Endpoint) async throws -> Data
    
    static let shared = CatAPIManager {
        try await URLSession.cat_imageSession.jp_data(for: $0.request)
    }
    
    static let stub = CatAPIManager { $0.stub }
    
    private init(getData: @escaping (Endpoint) async throws -> Data) {
        self.getData = getData
    }
}

extension CatAPIManager {
    enum Endpoint {
        case images
        case addToFavorite(bodyData: Data)
        case favorites
        
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
                
            }
        }
    }
}

extension CatAPIManager {
    struct ImageResponse: Decodable {
        let id: String
        let url: URL
        let width: CGFloat
        let height: CGFloat
    }
    
    struct FavoriteCreationResponse: Decodable {
        let id: Int
    }
    
    struct FavoriteResponse: Decodable {
        let id: Int
        let imageID: String
        let createdAt: Date
        let imageURL: URL

        enum CodingKeys: String, CodingKey {
            case id
            case imageID = "image_id"
            case createdAt = "created_at"
            case image
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container[.id]
            self.imageID = try container[.imageID]
            self.createdAt = try container[.createdAt]
            self.imageURL = try container.nestedContainer(key: .image)["url"]
        }
        
//        "id":100038507,
//        "image_id":"E8dL1Pqpz",
//        "sub_id":null,
//        "created_at":"2022-07-10T12:24:39.000Z",
//        "image":{
//            "id":"E8dL1Pqpz",
//            "url":"https://cdn2.thecatapi.com/images/E8dL1Pqpz.jpg"
//            }
//        },
    }
}

extension CatAPIManager {
    func getImages() async throws -> [ImageResponse] {
        try await fetch(.images)
    }
    
    func getFavorites() async throws -> [FavoriteResponse] {
        try await fetch(.favorites)
    }
    
    func addToFavorite(imageID: String) async throws -> Int {
        let body = ["image_id": imageID]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let response: FavoriteCreationResponse = try await fetch(.addToFavorite(bodyData: bodyData))
        return response.id
    }
}

private extension CatAPIManager {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T{
        let data = try await getData(endpoint)
        let decoder = JSONDecoder()
        // 自定义日期解析格式（默认解析方式跟catServer的日期格式不匹配）
        decoder.dateDecodingStrategy = .formatted(Self.dateFormatter)
        return try decoder.decode(T.self, from: data)
    }
}
