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

// MARK: - ShapeStyle / Color
extension ShapeStyle where Self == Color {
    static var sysBg: Color { Self(.systemBackground) }
    static var sysBg2: Color { Self(.secondarySystemBackground) }
    static var sysGb: Color { Self(.systemGroupedBackground) }
}

// MARK: - Animation
extension Animation {
    static let mySpring = Self.spring(dampingFraction: 0.55)
    static let myEase = Self.easeInOut(duration: 0.6)
}

// MARK: - Modifier
extension View {
    func mainButtonStyle(shape: ButtonBorderShape = .capsule) -> some View {
        self.buttonStyle(.borderedProminent)
            .buttonBorderShape(shape)
            .controlSize(.large)
    }
    
    func roundedRectBackground(radius: CGFloat = 8, fill: some ShapeStyle = .sysBg) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: radius)
                /// `Color`属于`ShapeStyle`的一种（遵守了`ShapeStyle`协议）
                /// `.foregroundColor(Color.red)`等价于`.foregroundStyle(Color.red)`
                /// 使用`ShapeStyle`作为参数类型，这样可以接收更多不同类型的选项。
//                .foregroundStyle(fill)
            
                /// `.foregroundStyle(XXX)`的背后是建立在`Shape`的`.fill(XXX)`之上，
                /// 所以对`Shape`最好直接使用`.fill(XXX)`，性能更好。
                .fill(fill)
                /// `RoundedRectangle`是属于`Shape`的一种。
                /// `.foregroundStyle(XXX)`如果使用的对象不是`Shape`（例如`Text`），
                /// 其实中间还做了一些裁剪的操作，最终还是对`Shape`进行了`.fill(XXX)`。
        )
    }
}

// MARK: - AnyLayout
extension AnyLayout {
    static func userVStack(if condition: Bool,
                           spacing: CGFloat = 0,
                           @ViewBuilder content: @escaping () -> some View) -> some View {
        let layout = condition ? AnyLayout(VStackLayout(spacing: spacing)) : AnyLayout(HStackLayout(spacing: spacing))
        // AnyLayout可以直接当作函数来调用，调用会执行它的尾随闭包来生成视图排版。
        // 可以在这个闭包里面来做视图构建（相当于把AnyLayout当作VStack和HStack的泛型来使用）。
        return layout(content)
    }
}
