//
//  AppStorage+.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/8/14.
//

import SwiftUI

extension AppStorage {
    init(wrappedValue: Value, _ key: UserDefaults.Key, store: UserDefaults? = nil) where Value == Bool {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
    init(wrappedValue: Value, _ key: UserDefaults.Key, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
}

extension AppStorage where Value: JPUnitCompatible {
    init(wrappedValue: Value = .defaultUnit, _ key: UserDefaults.Key, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
}
