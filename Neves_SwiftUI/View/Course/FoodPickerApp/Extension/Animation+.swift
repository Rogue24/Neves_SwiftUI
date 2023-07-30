//
//  Animation+.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/31.
//

import SwiftUI

extension Animation {
    static let mySpring = Self.spring(dampingFraction: 0.55)
    static let myEase = Self.easeInOut(duration: 0.6)
}
