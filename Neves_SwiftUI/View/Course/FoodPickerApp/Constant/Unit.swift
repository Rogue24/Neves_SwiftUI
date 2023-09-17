//
//  Unit.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/8/14.
//

import Foundation

// MARK: - Custom Unit

// 能量单位
enum JPEnergyUnit: String, JPUnitCompatible {
    case cal = "大卡"
    
    static let userDefaultsKey: UserDefaults.Key = .preferredEnergyUnit
    static let defaultUnit: JPEnergyUnit = .cal
    
    var dimension: UnitEnergy {
        switch self {
        case .cal:
            return .calories
        }
    }
}

// 重量单位
enum JPWeightUnit: String, JPUnitCompatible {
    case gram = "g"
    case ounce
    case pound = "lb"
    
    static let userDefaultsKey: UserDefaults.Key = .preferredWeightUnit
    static let defaultUnit: JPWeightUnit = .gram
    
    var dimension: UnitMass {
        switch self {
        case .gram:
            return .grams
        case .ounce:
            return .ounces
        case .pound:
            return .pounds
        }
    }
}
