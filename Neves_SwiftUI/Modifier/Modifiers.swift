//
//  Modifiers.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/7/3.
//
//  自定义Modifier

import SwiftUI

struct BaseShadowModifier: ViewModifier {
    let color: SwiftUI.Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 6, x: 0, y: 3)
            .shadow(color: color, radius: 1, x: 0, y: 1)
    }
}

struct BaseStrokeStyle: ViewModifier {
    let cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        .linearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.1 : 0.3),
                                .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blendMode(.overlay)
            )
    }
}

@available(iOS 15.0.0, *)
struct IconStyle: ViewModifier {
    let size: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.body.weight(.bold))
            .frame(width: size, height: size)
            .foregroundColor(.primary)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .baseStrokeStyle(cornerRadius: cornerRadius)
    }
}

extension View {
    func baseShadow(color: SwiftUI.Color = .black.opacity(0.3)) -> some View {
        modifier(BaseShadowModifier(color: color))
    }
    
    func baseStrokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(BaseStrokeStyle(cornerRadius: cornerRadius))
    }
    
    @available(iOS 15.0.0, *)
    func iconStyle(size: CGFloat, cornerRadius: CGFloat) -> some View {
        modifier(IconStyle(size: size, cornerRadius: cornerRadius))
    }
}
