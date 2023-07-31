//
//  AnyLayout+.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/31.
//

import SwiftUI

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
