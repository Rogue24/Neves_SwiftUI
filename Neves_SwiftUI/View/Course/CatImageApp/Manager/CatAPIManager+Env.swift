//
//  CatAPIManager+Env.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/3/4.
//

import SwiftUI

struct CatAPIManagerKey: EnvironmentKey {
    // 遵守`EnvironmentKey`必须要提供默认值
    static var defaultValue = CatAPIManager.shared
}

extension EnvironmentValues {
    var catApiManager: CatAPIManager {
        get { self[CatAPIManagerKey.self] }
        set { self[CatAPIManagerKey.self] = newValue }
    }
}
