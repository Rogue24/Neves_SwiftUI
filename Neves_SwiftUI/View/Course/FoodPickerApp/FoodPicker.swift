//
//  FoodPicker.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/11.
//

import SwiftUI

struct FoodPicker: View {
    @State private var selectedFood: Food?
    @State private var isShowInfo: Bool = false
    
    let foods = Food.examples
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                foodImage
                
                Text("今天吃啥？").bold()
                
                selectedFoodView
                
                /// 📢【2】
                /// `Spacer`的大小类型是`Expanding`，`HStack`的大小类型是`Neutral`。
                ///
                /// `Neutral`优先级比`Expanding`高，所以优先让`HStack`决定高度。
                /// - 而这里父视图给到的高度【不明确】，这样`HStack`内部的`Divider`会先占满剩余空间
                ///
                /// 所以在这里提高`Spacer`的布局优先级，先让`Spacer`决定高度（占满剩余空间）。
                Spacer().layoutPriority(1)
                
                selectButton
                
                resetButton
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height - 140)
            .font(.title)
            .mainButtonStyle()
            // 在这里添加的话，点击的那个button反而不受这里的动画控制，得使用withAnimation
//            .animation(.myEase, value: selectedFood)
        }
        .background(Color.sysBg2)
    }
}

// MARK: - Subviews
private extension FoodPicker {
    var foodImage: some View {
        Group {
            if let selectedFood {
                Text(selectedFood.image)
                    .font(.system(size: 200))
                    // 当【显示的区域】容不下【文本内容所需大小】时，会对文本内容进行缩放至适当大小
                    .minimumScaleFactor(0.1) // 最多能缩小至百分之多少
                    .lineLimit(1)
            } else {
                Image("dinner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(height: 250)
    }
    
    @ViewBuilder
    var selectedFoodView: some View {
        if let selectedFood {
            foodNameView(selectedFood)
            
            Text("热量 " + selectedFood.$calorie).font(.title2)
            
            foodInfoView(selectedFood)
        } // 默认else返回EmptyView
    }
    
    func foodNameView(_ selectedFood: Food) -> some View {
        HStack {
            Text(selectedFood.name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.orange)
                // 如果selectedFood本身就存在，并且修改selectedFood的值（不是空值），
                // 那么这种情况就是同一个View，默认是做变形动画，
                // 但是SwiftUI不会文字的变形动画，所以会用淡入淡出动画来代替，
                // 加上下面这句的效果是：使用不同的id，那就是不同的View，让SwiftUI做转场动画！
                .id(selectedFood.name)
                // 使用自定义的转场效果（transition：在【转场动画】中才有效）
                .transition( .delayInsertionOpacity)
            
            Button {
                withAnimation(.mySpring) {
                    isShowInfo.toggle()
                }
            } label: {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
    }
    
    func foodInfoView(_ selectedFood: Food) -> some View {
        /// 📢【1】
        /// 分隔线`Divider`在交叉轴方向默认的大小类型是`Expanding`，
        /// 如果父视图给定了【明确的高度】，它就会尽可能沾满剩余空间。
        ///
        /// `HStack`的大小类型是`Neutral`，高度根据`子View`决定。
        /// 如果父视图给到【明确的高度】，就根据`Divider`的`Expanding`
        /// 如果父视图没有【明确的高度】，就根据其他`子View`决定（这里是`Text`）
        ///
        /// 说人话就是：
        /// 父视图会先告诉`HStack`它有多少高度可以给你使用，
        /// 有固定的高度的话，`HStack`就会尽可能占满；
        /// 不固定的话，`HStack`的高度就用`子View`的，不然难道是无限高咩。
        ///
        /// 而这里套了一层`ScrollView`，高度是【不明确】的，
        /// 这种情况`HStack`就根据`Text`决定。
        /// 如果`HStack`没有其他`子View`，则是`Divider`的最小高度：10。
        ///
        /// 验证：
        /// 给`HStack`的`minHeight`一个明确高度，会`Expanding`，不给则是`Neutral`。
//                HStack {
//                    VStack(spacing: 12) {
//                        Text("蛋白质")
//                        Text(selectedFood.protein.formatted() + "g")
//                    }
//
//                    Divider().frame(width: 1).padding(.horizontal)
//
//                    VStack(spacing: 12) {
//                        Text("脂肪")
//                        Text(selectedFood.fat.formatted() + "g")
//                    }
//
//                    // 给分隔线添加宽度，是因为分隔线跟Text一样，当空间不够时会对自身进行挤压缩放，
//                    // 所以给分隔线一个明确的宽度，别被压没了。
//                    Divider().frame(width: 1).padding(.horizontal)
//
//                    VStack(spacing: 12) {
//                        Text("碳水")
//                        Text(selectedFood.carb.formatted() + "g")
//                    }
//                }
//                .font(.title3)
//                .padding(.horizontal)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .foregroundColor(Color(.systemBackground))
//                )
        
        /// 使用`VStack`将其包裹的原因：
        /// 为了让`Grid`做转场动画时，显示不会超出原来的区域（不然会跟上面的`View`重叠）。
        VStack {
            if isShowInfo {
                /// 📢【3】
                /// 这里改成用`Grid`代替`HStack`，而这个`Grid`是固定高度的，
                /// 所以此时`Spacer`不设置优先级也可以哦。
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    GridRow {
                        Text("蛋白质")
                        Text("脂肪")
                        Text("碳水")
                    }
                    // Grid整体是对齐的，所以只需要对一个子View设置宽度就好了
                    .frame(minWidth: 60)
                    // 如果有其他子View也设置了宽度，那就拿最大的宽度。
                    
                    Divider()
                        // 不分配空间给分隔线，否则默认会撑满可用空间
                        // 保持跟【其他子View综合给到的合适宽度】一致
                        .gridCellUnsizedAxes(.horizontal)
                        .padding(.horizontal, -10)
                    
                    GridRow {
                        Text(selectedFood.$protein)
                        Text(selectedFood.$fat)
                        Text(selectedFood.$carb)
                    }
                }
                .font(.title3)
                .padding(.horizontal)
                .padding()
                .roundedRectBackground()
                .transition(.moveUpWithOpacity)
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
    }
    
    var selectButton: some View {
        Button {
            withAnimation(.myEase) {
                selectedFood = foods.randomElement()
            }
        } label: {
            Text(selectedFood == .none ? "Tell me" : "Change one")
                .frame(width: 200)
                .animation(.none, value: selectedFood)
                .transformEffect(.identity)
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, -15)
    }
    
    var resetButton: some View {
        Button {
            withAnimation(.myEase) {
                selectedFood = .none
                isShowInfo = false
            }
        } label: {
            Text("Reset")
                .frame(width: 200)
        }
    }
}

// MARK: - Initializer
extension FoodPicker {
    init(selectedFood: Food? = nil) {
        _selectedFood = State(wrappedValue: selectedFood)
    }
}
