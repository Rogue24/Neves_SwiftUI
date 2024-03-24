//
//  FavoriteItem.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/3/18.
//

import SwiftUI

struct FavoriteItem: Decodable {
    let id: Int
    let imageID: String // 相当于CatImageViewModel的id
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
    
    init(catImage: CatImageViewModel, id: Int) {
        self.id = id
        self.imageID = catImage.id
        self.createdAt = .now
        self.imageURL = catImage.url
    }
}

extension FavoriteItem: Equatable {
    
}

extension [FavoriteItem] {
    mutating func add(_ cat: CatImageViewModel, apiManager: CatAPIManager) async throws {
        JPrint("即将添加cat：", cat.id)
        let id = try await apiManager.addToFavorite(imageID: cat.id)
        append(FavoriteItem(catImage: cat, id: id))
    }
    
    mutating func remove(at index: Int, apiManager: CatAPIManager) async throws {
        JPrint("即将删除cat：", self[index].imageID)
        try await apiManager.removeFromFavorite(id: self[index].id)
        remove(at: index)
        // TODO:  send update to the server
    }
}
