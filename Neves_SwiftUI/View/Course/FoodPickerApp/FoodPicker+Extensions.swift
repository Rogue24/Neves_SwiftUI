//
//  FoodPicker+Extensions.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/13.
//

import SwiftUI

// MARK: - Transition
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

// MARK: - Color
extension Color {
    static let sysBg = Self(.systemBackground)
    static let sysBg2 = Self(.secondarySystemBackground)
}

// MARK: - Animation
extension Animation {
    static let mySpring = Self.spring(dampingFraction: 0.55)
    static let myEase = Self.easeInOut(duration: 0.6)
}

// MARK: - Modifier
extension View {
    func mainButtonStyle() -> some View {
        self.buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
    }
    
    func roundedRectBackground(radius: CGFloat = 8, fill: some ShapeStyle = Color.sysBg) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: radius)
                /// `Color`属于`ShapeStyle`的一种（遵守了`ShapeStyle`协议）
                /// `.foregroundColor(Color.red)`等价于`.foregroundStyle(Color.red)`
                /// 使用`ShapeStyle`作为参数类型，这样可以接收更多不同类型的选项。
                .foregroundStyle(fill)
        )
    }
}
