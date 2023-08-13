//
//  FoodDetailSheet.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/30.
//

import SwiftUI

extension FoodListScreen {
    private struct DetailSheetHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 300
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct FoodDetailSheet: View {
        @Environment(\.dynamicTypeSize) var textSize
        @State private var detailHeight: CGFloat = DetailSheetHeightKey.defaultValue
        
        let food: Food
        
        var body: some View {
            // 是否使用`VStack`：
            // 默认使用`HStack`，
            // 但「辅助模式（大字号）」或「emoji数量大于1」的情况下，使用`VStack`。
            // 因为`HStack`放不下，会被挤压成两行。
            let shouldUseVStack = textSize.isAccessibilitySize || food.image.count > 1
            
            // 相当于把AnyLayout当作VStack和HStack的泛型来使用
            AnyLayout.userVStack(if: shouldUseVStack, spacing: 30) {
                Text(food.image)
                    .font(.system(size: 100))
                    .lineLimit(1)
                    // 当【显示的区域】容不下【文本内容所需大小】时，会对文本内容进行缩放至适当大小
                    .minimumScaleFactor(shouldUseVStack ? 1 : 0.5) // 最多能缩小至百分之多少
                
                Grid(horizontalSpacing: 30, verticalSpacing: 12) {
                    buildNutritionView(title: "热量", value: food.$calorie)
                    buildNutritionView(title: "蛋白质", value: food.$protein)
                    buildNutritionView(title: "脂肪", value: food.$fat)
                    buildNutritionView(title: "碳水", value: food.$carb)
                }
            }
            .padding()
            .padding(.vertical)
            .maxWidth()
            .background(.sysGb2)
            // 读取这一句之前上面这部分的视图大小
            .readGeometry(\.size.height, key: DetailSheetHeightKey.self)
            .onPreferenceChange(DetailSheetHeightKey.self) {
                detailHeight = $0
            }
            // 自定义present形式：
            // .medium：只占屏幕一半高度
            // .height(500)：最大高度（如果比medium小，最大高度则是半屏）
//            .presentationDetents([.medium, .height(500)])
//            .presentationDetents([.medium])
            .presentationDetents([.height(detailHeight)])
        }
        
        private func buildNutritionView(title: String, value: String) -> some View {
            GridRow {
                Text(title)
                    .gridCellAnchor(.leading)
                Text(value)
                    .gridCellAnchor(.trailing)
            }
        }
    }
}
