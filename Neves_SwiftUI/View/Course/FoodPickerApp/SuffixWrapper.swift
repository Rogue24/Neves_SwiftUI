//
//  SuffixWrapper.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/13.
//

import Foundation

@propertyWrapper
struct Suffix: Equatable {
    var wrappedValue: Double
    private let suffix: String
    
    init(wrappedValue: Double, _ suffix: String) {
        self.wrappedValue = wrappedValue
        self.suffix = suffix
    }
    
    var projectedValue: String {
        wrappedValue.formatted() + suffix
    }
}
