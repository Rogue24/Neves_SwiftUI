//
//  ShapeStyle+.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/31.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var sysBg: Color { Self(.systemBackground) }
    static var sysBg2: Color { Self(.secondarySystemBackground) }
    static var sysGb: Color { Self(.systemGroupedBackground) }
}
