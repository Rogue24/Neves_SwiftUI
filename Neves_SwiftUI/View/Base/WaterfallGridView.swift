//
//  WaterfallGridView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/2/27.
//

import SwiftUI

struct WaterfallGridView: View {
    @State var columns: Int = 3
    
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
    
    var body: some View {
        WaterfallGrid(columns: columns,
                      verSpacing: 5,
                      horSpacing: 5,
                      list: Girl.list) {
            GirlItem($0)
                .matchedGeometryEffect(id: $0.id, in: namespace)
        }
        .padding(.horizontal, 5)
        .navigationBarItems(
            trailing: Button(action: {
                guard columns > 1 else { return }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    columns -= 1
                }
            }) { Image(systemName: "minus") }
        )
        .navigationBarItems(
            trailing: Button(action: {
                guard columns < 5 else { return }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    columns += 1
                }
            }) { Image(systemName: "plus") }
        )
    }
}

private extension WaterfallGridView {
    struct Girl: Identifiable, Hashable {
        let id = UUID()
        let imgName: String
        
        static let list: [Girl] = {
            let girlList1 = Array(1...8).map { Girl(imgName: "Girl\($0)") }
            let girlList2 = Array(1...8).map { Girl(imgName: "Girl\($0)") }
            let girlList3 = Array(1...8).map { Girl(imgName: "Girl\($0)") }
            let girlList4 = Array(1...8).map { Girl(imgName: "Girl\($0)") }
            return girlList1.shuffled() + girlList2.shuffled() + girlList3.shuffled() + girlList4.shuffled()
        }()
    }
    
    struct GirlItem: View {
        var girl: Girl
        
        init(_ girl: Girl) {
            self.girl = girl
        }
        
        var body: some View {
            Image(uiImage: UIImage.jp.fromBundle(forName: girl.imgName, ofType: "jpg")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .frame(minWidth: 0, minHeight: 0, alignment: .top)
                .clipped()
        }
    }
}

struct WaterfallGridView_Previews: PreviewProvider {
    static var previews: some View {
        WaterfallGridView()
    }
}
