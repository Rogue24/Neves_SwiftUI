//
//  URLSession+.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import Foundation

extension URLSession {
    static var cat_imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = .cat_imageCache
        
        // 由于该session主要都是请求catServer，而这个server的接口基本都需要apiKey，
        // 因此每次请求都得在URLRequest中设置header信息：
        // var request = URLRequest(url: "https://xxx")
        // request.addValue(JPSecret.catApiKey, forHTTPHeaderField: "x-api-key")
        
        // 统一设置请求头信息：
        var headers = config.httpAdditionalHeaders ?? [:]
        headers["x-api-key"] = JPSecret.catApiKey
        config.httpAdditionalHeaders = headers
        // 这样只要使用该session发起的请求都会自动带上apiKey，
        // 不用每次请求都得设置一下URLRequest了。
        
        return URLSession(configuration: config)
    }()
}

extension URLSession {
    enum APIError: Error {
        case invalidURL
        case invalidCode(_ code: Int)
        case invalidData
    }
    
    func jp_data(for urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await self.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidURL
        }
        
        guard 200...299 ~= response.statusCode else {
            assertionFailure(String(format: "请求错误：%@", String(data: data, encoding: .utf8) ?? "unknow failure"))
            throw APIError.invalidCode(response.statusCode)
        }
        
        return data
    }
}
