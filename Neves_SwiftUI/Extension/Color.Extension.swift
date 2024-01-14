//
//  Color.Extension.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/6.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var randomColor: Color { randomColor() }
    static func randomColor(_ a: Double = 1.0) -> Color {
        Color(.sRGB,
              red: Double(arc4random_uniform(256)) / 255,
              green: Double(arc4random_uniform(256)) / 255,
              blue: Double(arc4random_uniform(256)) / 255,
              opacity: a)
    }
}
