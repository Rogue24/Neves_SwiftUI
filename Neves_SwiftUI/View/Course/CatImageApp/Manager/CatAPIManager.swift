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
    var getData: (URLRequest) async throws -> Data
    
    static let shared = {
        let session = URLSession.cat_imageSession
        return CatAPIManager(getData: session.data)
    }()
    
    private let session = URLSession.cat_imageSession
    
    private init(getData: @escaping (URLRequest) async throws -> Data) {
        self.getData = getData
    }
}

extension CatAPIManager {
    func getImages() async throws -> [ImageResponse] {
        let data = try await getData(URLRequest(url: "https://api.thecatapi.com/v1/images/search?limit=10"))
        return try JSONDecoder().decode([ImageResponse].self, from: data)
    }
}

extension CatAPIManager {
    struct ImageResponse: Decodable {
        let id: String
        let url: URL
        let width: CGFloat
        let height: CGFloat
    }
}

// MARK: - For Test
extension CatAPIManager {
    static let stub = CatAPIManager { _ in
        Data("""
        [{"id":"6st","url":"https://cdn2.thecatapi.com/images/6st.jpg","width":1024,"height":684},{"id":"9qi","url":"https://cdn2.thecatapi.com/images/9qi.jpg","width":894,"height":894},{"id":"apd","url":"https://cdn2.thecatapi.com/images/apd.jpg","width":3888,"height":2592},{"id":"bd5","url":"https://cdn2.thecatapi.com/images/bd5.png","width":413,"height":414},{"id":"bd8","url":"https://cdn2.thecatapi.com/images/bd8.png","width":500,"height":333},{"id":"cif","url":"https://cdn2.thecatapi.com/images/cif.jpg","width":500,"height":334},{"id":"d5k","url":"https://cdn2.thecatapi.com/images/d5k.gif","width":480,"height":272},{"id":"MTYzMDM2OQ","url":"https://cdn2.thecatapi.com/images/MTYzMDM2OQ.jpg","width":1936,"height":2592},{"id":"wQz67QCme","url":"https://cdn2.thecatapi.com/images/wQz67QCme.jpg","width":750,"height":937},{"id":"TYQKhQ3mn","url":"https://cdn2.thecatapi.com/images/TYQKhQ3mn.jpg","width":1440,"height":1440}]
        """.utf8)
    }
}
