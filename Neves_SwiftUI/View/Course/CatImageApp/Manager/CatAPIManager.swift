//
//  CatAPIManager.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/3/4.
//
//  API文档：https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t

import SwiftUI

final class CatAPIManager {
    private(set) var favoriteImages: [FavoriteItem] = []
    
    /// 提供`URLRequest`以决定如何获取`Data`的闭包
    /// - Note: 有默认处理，并且可供外部修改
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

// MARK: - 公开API
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
        do {
            _ = try await getData(.removeFromFavorite(id: id))
//            _ = try await getData(.removeFromFavorite(id: Int.random(in: 1...100))) // for error test
        } catch URLSession.APIError.invalidCode(400) {
            JPrint("请求错误：INVALID_ACCOUNT！这是不存在的最爱ID，默默略过该错误...")
        }
    }
}

// MARK: - 私有API
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
