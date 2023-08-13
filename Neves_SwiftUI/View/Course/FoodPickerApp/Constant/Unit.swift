//
//  Unit.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/8/14.
//

import SwiftUI

enum Unit: String, CaseIterable, Identifiable, View {
    case gram = "g"
    case pound = "lb"
    
    var id: Self { self }
    
    var body: some View {
        Text(rawValue)
    }
}
