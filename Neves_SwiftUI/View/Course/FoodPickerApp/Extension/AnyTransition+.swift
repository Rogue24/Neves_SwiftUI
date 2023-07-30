//
//  AnyTransition+.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/31.
//

import SwiftUI

extension AnyTransition {
    // 缩放+左滑
    static let scaleWithLeftSlide = Self.scale.combined(with: .slide)
    
    // 上挪+透明
    static let moveUpWithOpacity = Self.move(edge: .top).combined(with: .opacity)
    
    // 进场延后
    static let delayInsertionOpacity = Self.asymmetric(
        insertion: .opacity.animation(
            .easeInOut(duration: 0.5).delay(0.2)
        ),
        removal: .opacity.animation(
            .easeInOut(duration: 0.4)
        )
    )
}
