//
//  LazyGridView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2021/12/26.
//

import SwiftUI

struct LazyGridView: View {
    @Namespace var namespace
    
    @State var show = false
    @State var selectedItem: Beauty? = nil
    @State var isDisabled = false
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: [GridItem()]) {
                    ForEach(beauties) { beauty in
                        BeautyItem(beauty: beauty)
                            .matchedGeometryEffect(id: beauty.id, in: namespace, isSource: !show)
                            .frame(width: screenSize.width - 40, height: 270)
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

struct LazyGridView_Previews: PreviewProvider {
    static var previews: some View {
        LazyGridView()
    }
}
