//
//  AnimTestView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/11.
//

import SwiftUI

/// `SwiftUI`有两种过渡动画：
///   1. 转场动画（默认淡入淡出）
///   2. 变形动画
///
/// 转场动画：会有变化前后的两个View做转场动画
/// 默认做淡入淡出动画：
///   - 变化前的View保持在初始位置，淡出（alpha 1 --> 0）
///   - 变化后的View直接在最终位置，淡入（alpha 0 --> 1）
/// 出现场景：变化前后不是同一个View：
///   - `@ViewBuilder`中结构位置不一样的View：`if {} else {}`
///   - `@ViewBuilder`中结构位置一样但`id`不一样的View
///
/// 变形动画：对同一个View做变形动画
/// 当SwiftUI不知道怎么做变形动画，会用默认的转场动画（淡入淡出）来代替，
///   - 例如SwiftUI不会做文字的变形，就会有两个Text淡入淡出

struct AnimTestView: View {
    @State var name: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Image("Dilraba")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            if let name {
                Text(name)
                    .font(.largeTitle)
                    .bold()
            }
            
            // 转场动画
//            if selectedFood == .none {
//                Color.red
//            } else {
//                Color.blue
//            }
            
            // 变形动画
//            selectedFood == .none ? Color.red : Color.blue
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    name = name == .none ? "迪丽热巴" : .none
                }
            } label: {
                Text(name == .none ? "这是谁？" : "返回")
                    .font(.title2)
                    .frame(width: 100)
                    // 2.移除淡入淡出动画
                    // 必须要在添加`transformEffect`前面移除，否则就会连位置变形动画也一起移除
//                    .animation(.none, value: name)
                    // 1.当SwiftUI遇到不会的变形动画，会用淡入淡出动画（类似默认的转场动画）来代替，并且会忽略其他所有它可以掌握的变形
                    // 例如Text的文字变化，SwiftUI本身能掌握这个Text的位置变形，但由于不会文字变形，所以会用类似默认的转场动画（淡入淡出）代替变形动画，并且把位置的变形动画也一起忽略掉：直接用两个前后变化的Text做淡入淡出的动画
                    // 加上下面这句的效果是：强制不让SwiftUI忽略掉其他的变形动画，要带上！
                    .transformEffect(.identity) // 文字保持淡入淡出（不移除的话），其他能变形的都变形（位置）
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
        }
        .padding()
    }
}
