//
//  AnimatableModifiers.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/8.
//
//  学自：https://blog.csdn.net/Forever_wj/article/details/123298793

import SwiftUI

struct AnimatableFontModifier: AnimatableModifier {
    var size: Double
    let weight: Font.Weight
    let design: Font.Design
    
    // 设置`animatableData`跟`size`绑定：
    // 当`size`发生变化时则会带有动画的过渡效果。
    var animatableData: Double {
        set { size = newValue }
        get { size }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

struct AnimatableForegroundColorModifier: AnimatableModifier {
    let fromRgba: UIColor.RGBA
    let toRgba: UIColor.RGBA
    var progress: CGFloat
    
    init(from: UIColor, to: UIColor, progress: CGFloat) {
        self.fromRgba = from.rgba
        self.toRgba = to.rgba
        self.progress = progress
    }
    
    var animatableData: CGFloat {
        set {
            if newValue < 0 {
                progress = 0
            } else if newValue > 1 {
                progress = 1
            } else {
                progress = newValue
            }
        }
        get { progress }
    }

    func body(content: Content) -> some View {
        content
            .foregroundColor(colorMixer())
    }
    
    func colorMixer() -> Color {
        let rgba = UIColor.RGBA.fromSourceRgba(fromRgba, toTargetRgba: toRgba, progress: progress)
        return Color(red: rgba.r / 255, green: rgba.g / 255, blue: rgba.b / 255, opacity: rgba.a)
    }
}

extension View {
    func animatableFont(size: CGFloat,
                        weight: Font.Weight = .regular,
                        design: Font.Design = .default) -> some View {
        modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
    }
    
    func animatableForegroundColor(from: UIColor,
                                   to: UIColor,
                                   progress: CGFloat) -> some View {
        modifier(AnimatableForegroundColorModifier(from: from, to: to, progress: progress))
    }
}
