//
//  Array+.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/8/21.
//

import Foundation

extension Array: RawRepresentable where Element: Codable {
    /// 解码
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let foods = try? JSONDecoder().decode(Self.self, from: data)
        else { return nil }
        self = foods
    }
    
    /// 编码
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let str = String(data: data, encoding: .utf8)
        else { return "" }
        return str
    }
}
