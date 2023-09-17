//
//  SuffixWrapper.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/13.
//

import Foundation

@propertyWrapper
struct Suffix<Unit: JPUnitCompatible & Equatable>: Equatable {
    var wrappedValue: Double
    var unit: Unit
    
    init(wrappedValue: Double, _ unit: Unit) {
        self.wrappedValue = wrappedValue
        self.unit = unit
    }
    
    // 想通过$xxx进行自己本身的存取的话，就得加上set方法
    var projectedValue: Self {
        get { self }
        set { self = newValue }
    }
    
    var description: String {
        // 1.获取预设的单位
        let preferredUnit = Unit.getPreferredUnit()
        // 2.获取存储的数值及其对应的单位
        let measurement = Measurement(value: wrappedValue, unit: unit.dimension)
        // 3.将存储的数值转成预设的单位对应的数值
        let converted = measurement.converted(to: preferredUnit.dimension)
        
//        return converted.formatted(.measurement(width: .abbreviated, usage: .asProvided, numberFormatStyle: .number.precision(.fractionLength(0...1))))
        
        // 使用自定义的格式
        return converted.value.formatted(.number.precision(.fractionLength(0...1))) // 设置精准度：最多到小数点0~1位（四舍五入）
        + " "
        + preferredUnit.dimension.localizedSymbol
    }
}

extension Suffix: Codable {
    /// 遵守`Codable`，如果自己的所有属性都是`Codable`的，那么就不用自己去实现编码`endode`和解码`decode`。
    /// PS: `Swift`提供的基本类型都是`Codable`的，如`String`、`Int`，还有`Array`和`Dictionary`（只要存储的元素也是`Codable`的即可）。
}
