//
//  JPUnitCompatible.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/9/18.
//

import SwiftUI

// 为了能使用在ForEach，需要遵守这些协议和条件：Identifiable, CaseIterable, View where AllCases: RandomAccessCollection
protocol JPUnitCompatible: Codable, Identifiable, CaseIterable, View, RawRepresentable where RawValue == String, AllCases: RandomAccessCollection {
    /// 遵守`Codable`，如果自己的所有属性都是`Codable`的，那么就不用自己去实现编码`endode`和解码`decode`。
    /// PS: `Swift`提供的基本类型都是`Codable`的，如`String`、`Int`，还有`Array`和`Dictionary`（只要存储的元素也是`Codable`的即可）。
    /**
     * 其中`RawRepresentable`的`RawValue`为`String`的话，默认就实现了`Codable`：
     * - `extension RawRepresentable where Self : Encodable, Self.RawValue == String { ... }`
     * - `extension RawRepresentable where Self : Decodable, Self.RawValue == String { ... }`
     */
    
    static var userDefaultsKey: UserDefaults.Key { get }
    static var defaultUnit: Self { get }
    
    // 使用泛型，确保`dimension`返回的是同一种（属于`Dimension`的）类型
    associatedtype T: Dimension
    var dimension: T { get }
}

// MARK: - <Identifiable>
extension JPUnitCompatible {
    var id: Self { self }
}

// MARK: - <View>
extension JPUnitCompatible {
    var body: some View {
        Text(localizedSymbol)
    }
}

extension JPUnitCompatible {
    /// 获取预设单位
    static func getPreferredUnit(from store: UserDefaults = .standard) -> Self {
        // 方式1：
        AppStorage(userDefaultsKey, store: store).wrappedValue
        
        // 方式2：
//        @AppStorage(userDefaultsKey) var preferredUnit: Self
//        return preferredUnit
    }
    
    /// 获取单位符号
    var localizedSymbol: String {
        MeasurementFormatter().string(from: dimension)
    }
}
