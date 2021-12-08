//
//  MatchedGeometryEffectView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/8.
//

import SwiftUI

struct MatchedGeometryEffectView: View {
    /**
     * matchedGeometryEffect：匹配几何效果的Modifier
     * 能够对共享元素进行动画处理，实现两个视图之间无缝过渡的效果
     *
     * 使用这个Modifier，标记需要过渡的两个View，
     * 当一个View过渡到另一个View后，系统就不用重复显示两个“一样”的View了，
     * 能让系统知道这两个其实都是“同一个”View，从而底层进行优化。
     *
     * `id`：匹配的唯一标识
     * 要匹配的那两个View设置的这个id一定要一样
     *
     * `isSource`：是否源头
     * 两个View至少要有一个要设置该属性，好让系统知道是从哪个View开始过渡到另一个View
     * 所以要用状态值show，show之前为true，说明从这个View开始，show之后会false，说明从另一个View回来
     */
    @Namespace var namespace
    
    @State var show = false
    @State var selectedItem: Beauty? = nil
    @State var isDisabled = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(beauties) { beauty in
                        BeautyItem(beauty: beauty)
                            .matchedGeometryEffect(id: beauty.id, in: namespace, isSource: !show)
                            .frame(width: screenSize.width - 32, height: 270)
                            .onTapGesture {
                                // 使用withAnimation就可以实现【仅在点击时】才添加动画
                                withAnimation(.spring()) {
                                    show.toggle()
                                    selectedItem = beauty
                                    isDisabled = true
                                }
                            }
                    }
                }
                // 如果设置【绝对】宽度为无限是无效的，那样宽度是内容宽度（默认宽度是内容宽度）
                .frame(maxWidth: .infinity)
            }
            .disabled(isDisabled) // 防止铺满全屏的过程中点击了其他卡片造成错乱，点击后禁止卡片列表的交互
            
            if show {
                ZStack(alignment: .center) {
                    BlurView(style: .systemMaterial)
                        .frame(width: screenSize.width, height: screenSize.height)
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView {
                        VStack {
                            Spacer(minLength: 70)
                            BeautyItem(beauty: selectedItem!)
                                .matchedGeometryEffect(id: selectedItem!.id, in: namespace)
                                .frame(width: screenSize.width - 32,
                                       height: selectedItem!.fitSize(forWidth: screenSize.width - 32).height)
                                .onTapGesture {
                                    // 使用withAnimation就可以实现【仅在点击时】才添加动画
                                    withAnimation(.spring()) {
                                        show.toggle()
                                        selectedItem = nil
                                        // 防止返回卡片的过程中点击了其他卡片造成错乱，延时处理让动画完整进行后再开启卡片列表的交互
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            isDisabled = false
                                        }
                                    }
                                }
                            Spacer(minLength: 34)
                        }
                        .frame(maxWidth: .infinity,
                               minHeight: screenSize.height,
                               maxHeight: .infinity)
                        .transition(
                            // asymmetric 非对称过渡效果
                            // 例如1和2的过渡，1为源头，设置这两者之间的过渡动画效果
                            .asymmetric(
                                insertion: // 1 -> 2
                                    AnyTransition.opacity.animation(Animation.spring().delay(0.3)),
                                removal: // 2 -> 1
                                    AnyTransition.opacity.animation(Animation.spring())
                            )
                        )
                    }
                }
            }
        }
    }
}

struct MatchedGeometryEffectView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeometryEffectView()
    }
}
