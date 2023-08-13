//
//  UserDefaults+Key.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/8/14.
//

import SwiftUI

extension UserDefaults {
    enum Key: String, CaseIterable {
        case isUseDarkMode
        case unit
        case startTab
    }
}
