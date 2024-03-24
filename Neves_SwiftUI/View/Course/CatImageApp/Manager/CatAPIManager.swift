//
//  CatAPIManager.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/3/4.
//
//  API文档：https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t

import SwiftUI

final class CatAPIManager {
    private(set) var favorites: [FavoriteItem] = []
    
    /// 提供`URLRequest`以决定如何获取`Data`的闭包
    /// - Note: 有默认处理，并且可供外部修改
    var getData: (Endpoint) async throws -> Data
    
    static let shared = CatAPIManager {
        try await URLSession.cat_imageSession.jp_data(for: $0.request)
    }
    
    static let preview = CatAPIManager(favorites: [CatImageViewModel].stub.enumerated().map {
        FavoriteItem(catImage: $0.element, id: $0.offset)
    }) {
        try? await Task.sleep(for: .seconds(1)) // 模拟网络请求：停1s再回传
        return $0.stub
    }
    
    init(favorites: [FavoriteItem] = [], getData: @escaping (Endpoint) async throws -> Data) {
        self.favorites = favorites
        self.getData = getData
    }
}

// MARK: - 公开API
extension CatAPIManager {
    func getImages() async throws -> [ImageResponse] {
        try await fetch(.images)
    }
    
    func getFavorites() async throws {
        favorites = try await fetch(.favorites)
    }
    
    func addToFavorite(_ cat: CatImageViewModel) async throws {
        JPrint("请求【添加】cat：", cat.id)
        let body = ["image_id": cat.id]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let response: FavoriteCreationResponse = try await fetch(.addToFavorite(bodyData: bodyData))
        favorites.append(FavoriteItem(catImage: cat, id: response.id))
    }
    
    func removeFromFavorite(id: Int) async throws {
        guard let index = favorites.firstIndex(where: \.id == id) else { return }
        try await removeFromFavorite(at: index)
    }
    
    func toggleFavorite(_ cat: CatImageViewModel) async throws {
        if let index = favorites.firstIndex(where: \.imageID == cat.id) {
            try await removeFromFavorite(at: index)
        } else {
            try await addToFavorite(cat)
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
    
    func removeFromFavorite(at index: Int) async throws {
        let favorite = favorites[index]
        JPrint("请求【删除】cat：", favorite.imageID)
        do {
            _ = try await getData(.removeFromFavorite(id: favorite.id))
//            _ = try await getData(.removeFromFavorite(id: Int.random(in: 1...100))) // for error test
            favorites.remove(at: index)
        } catch URLSession.APIError.invalidCode(400) {
            JPrint("请求错误：INVALID_ACCOUNT！这是不存在的最爱ID，默默略过该错误...")
        }
    }
}
