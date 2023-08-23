//
//  Food.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/13.
//

import Foundation

struct Food: Equatable, Identifiable {
    var id = UUID() // 由于解码的内容包括id，所以要换成var，使解码时可以修改这个值
    var name: String
    var image: String
    @Suffix(" 大卡") var calorie: Double = 0
    @Suffix(" g") var carb: Double = 0
    @Suffix(" g") var fat: Double = 0
    @Suffix(" g") var protein: Double = 0
    
    static let examples = [
        Food(name: "汉堡", image: "🍔", calorie: 294, carb: 14, fat: 24, protein: 17),
        Food(name: "沙拉", image: "🥗", calorie: 89, carb: 20, fat: 0, protein: 1.8),
        Food(name: "披萨", image: "🍕", calorie: 266, carb: 33, fat: 10, protein: 11),
        Food(name: "意大利面", image: "🍝", calorie: 339, carb: 74, fat: 1.1, protein: 12),
        Food(name: "鸡腿盒饭", image: "🍗🍱", calorie: 191, carb: 19, fat: 8.1, protein: 11.7),
        Food(name: "刀削面", image: "🍜", calorie: 256, carb: 56, fat: 1, protein: 8),
        Food(name: "火锅", image: "🍲", calorie: 233, carb: 26.5, fat: 17, protein: 22),
        Food(name: "牛肉面", image: "🐄🍜", calorie: 219, carb: 33, fat: 5, protein: 9),
        Food(name: "关东煮", image: "🥘", calorie: 80, carb: 4, fat: 4, protein: 6),
    ]
    
    static var new: Food { Food(name: "", image: "") }
}

extension Food: Codable {
    /// 遵守`Codable`，如果自己的所有属性都是`Codable`的，那么就不用自己去实现编码`endode`和解码`decode`。
    /// PS: `Swift`提供的基本类型都是`Codable`的，如`String`、`Int`，还有`Array`和`Dictionary`（只要存储的元素也是`Codable`的即可）。
}

/// 使用泛型增强通用性 ---> `Array+`
//extension [Food]: RawRepresentable {
//    /// 解码
//    public init?(rawValue: String) {
//        guard let data = rawValue.data(using: .utf8),
//              let foods = try? JSONDecoder().decode([Food].self, from: data)
//        else { return nil }
//        self = foods
//    }
//
//    /// 编码
//    public var rawValue: String {
//        guard let data = try? JSONEncoder().encode(self),
//              let str = String(data: data, encoding: .utf8)
//        else { return "" }
//        return str
//    }
//}
