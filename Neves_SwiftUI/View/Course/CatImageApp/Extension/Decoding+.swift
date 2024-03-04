//
//  Decoding+.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import Foundation

struct DecodingKey: CodingKey {
    // CodingKey:
    // Int -> String 肯定可以的，所以`stringValue`是确定类型
    // String -> Int 不一定可以，所以`intValue`是可选类型
    
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}

// 直接String创建 -> let key: DecodingKey = "hello"
extension DecodingKey: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        stringValue = value
        intValue = Int(value)
    }
}

// 直接Int创建 -> let key: DecodingKey = 123
extension DecodingKey: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        intValue = value
        stringValue = "\(value)"
    }
}

extension Decoder {
    func container() throws -> KeyedDecodingContainer<DecodingKey> {
        try self.container(keyedBy: DecodingKey.self)
    }
}

extension KeyedDecodingContainer {
    subscript<Value: Decodable>(_ key: Key) -> Value {
        get throws {
            try self.decode(Value.self, forKey: key)
        }
    }
    
    func nestedContainer(key: Key) throws -> KeyedDecodingContainer<DecodingKey> {
        try self.nestedContainer(keyedBy: DecodingKey.self, forKey: key)
    }
}
