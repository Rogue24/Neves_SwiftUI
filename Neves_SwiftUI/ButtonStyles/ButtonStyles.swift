//
//  ButtonStyles.swift
//  Neves_SwiftUI
//
//  Created by aa on 2022/10/26.
//
//  ButtonStyle和PrimitiveButtonStyle的基本使用
//  学自：https://www.jianshu.com/p/45842ce53d34

import SwiftUI

struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {}, label: {
            HStack {
                Spacer()
                configuration.label.foregroundColor(.black)
                Spacer()
            }
        })
        // 使所有的轻击转到原来的按钮
        .allowsHitTesting(false)
        .padding()
        .background(Color.yellow.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ShadowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(
                color: configuration.isPressed ? Color.blue : Color.black,
                radius: 4, x: 0, y: 5
            )
    }
}

// 双击按钮动作就会触发
struct DoubleTapStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(configuration) // <- Button instead of configuration.label
            .onTapGesture(count: 2, perform: configuration.trigger)
    }
}

// 点击时触发(即使在按钮外终止)
struct SwipeButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(configuration)
            .gesture(
                DragGesture()
                    .onEnded { _ in
                        configuration.trigger()
                    }
            )
    }
}

struct PlainNoTapStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(configuration)
            .buttonStyle(PlainButtonStyle()) // 移除默认样式
            .allowsHitTesting(false)         // 取消事件触发
            .contentShape(Rectangle())       // 替换样式及交互 -> 重新规定了交互的响应区域（原本的被覆盖）
    }
}
