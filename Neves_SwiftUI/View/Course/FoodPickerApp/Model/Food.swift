//
//  Food.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/13.
//

import Foundation
import SwiftUI

typealias Energy = Suffix<JPEnergyUnit>
typealias Weight = Suffix<JPWeightUnit>

struct Food: Equatable, Identifiable {
    var id = UUID() // 由于解码的内容包括id，所以要换成var，使解码时可以修改这个值
    var name: String
    var image: String
    @Energy var calorie: Double
    @Weight var carb: Double
    @Weight var fat: Double
    @Weight var protein: Double
}

extension Food: Codable {
    /// 遵守`Codable`，如果自己的所有属性都是`Codable`的，那么就不用自己去实现编码`endode`和解码`decode`。
    /// PS: `Swift`提供的基本类型都是`Codable`的，如`String`、`Int`，还有`Array`和`Dictionary`（只要存储的元素也是`Codable`的即可）。
}

/// `AppStorage`本身不支持数组的存储，如果想使用`AppStorage`存储`Food`数组，
/// 就要让`Food`数组遵循`RawRepresentable`，并且`RawValue`要为`String`类型：
/// - `rawValue`使用`JSONEncoder`转换，把`Food`数组转成【一串字符串】给`AppStorage`存储
/// - 使用泛型增强通用性 ==> `Array+`
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

extension Food {
    private init(id: UUID = UUID(), name: String, image: String, calorie: Double, carb: Double, fat: Double, protein: Double) {
        self.id = id
        self.name = name
        self.image = image
        self._calorie = .init(wrappedValue: calorie, .cal)
        self._carb =    .init(wrappedValue: carb, .gram)
        self._fat =     .init(wrappedValue: fat, .gram)
        self._protein = .init(wrappedValue: protein, .gram)
    }
    
    static var new: Food {
        // 新建一个Food实例，要使用用户预设好（当前）的单位
        let preferredWeightUnit = JPWeightUnit.getPreferredUnit()
        let preferredEnergyUnit = JPEnergyUnit.getPreferredUnit()
        
        // 使用默认实现的构造器
        return Food(name: "",
                    image: "",
                    calorie:    .init(wrappedValue: 0, preferredEnergyUnit),
                    carb:       .init(wrappedValue: 0, preferredWeightUnit),
                    fat:        .init(wrappedValue: 0, preferredWeightUnit),
                    protein:    .init(wrappedValue: 0, preferredWeightUnit))
    }
    
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
}
