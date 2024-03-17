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
    
    static let preview = CatAPIManager {
        try? await Task.sleep(for: .seconds(1)) // 模拟网络请求：停1s再回传
        return $0.stub
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
}

extension CatAPIManager {
    func getImages() async throws -> [ImageResponse] {
        try await fetch(.images)
    }
    
    func getFavorites() async throws -> [FavoriteItem] {
        try await fetch(.favorites)
    }
    
    func addToFavorite(imageID: String) async throws -> Int {
        let body = ["image_id": imageID]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let response: FavoriteCreationResponse = try await fetch(.addToFavorite(bodyData: bodyData))
        return response.id
    }
    
    func removeFromFavorite(id: Int) async throws {
        _ = try await getData(.removeFromFavorite(id: id))
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
        
        // ------- look result 0 -------
//        let str = String(data: data, encoding: .utf8)
//        JPrint("请求结果：", str ?? "???")
        
//        do {
//            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
//            JPrint("请求结果：", dict ?? [:])
//        } catch {
//            JPrint("请求失败！", error)
//        }
        // ------- look result 1 -------
        
        let decoder = JSONDecoder()
        // 自定义日期解析格式（默认解析方式跟catServer的日期格式不匹配）
        decoder.dateDecodingStrategy = .formatted(Self.dateFormatter)
        return try decoder.decode(T.self, from: data)
    }
}
