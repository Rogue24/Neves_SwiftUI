//
//  FoodListView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/9.
//

import SwiftUI

struct FoodListView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.dynamicTypeSize) var textSize
    @State private var foods = Food.examples
    @State private var selectedFoods = Set<Food.ID>()
    @State private var isShowDetail = false
    @State private var detailHeight: CGFloat = DetailSheetHeightKey.defaultValue
    
    // 是否正在编辑
    var isEditing: Bool { editMode?.wrappedValue == .active }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleBar
            
            List($foods, editActions: .all, selection: $selectedFoods) { $food in
                HStack {
                    Text(food.name)
                        .padding(.vertical, 10)
                        // =========== 给整行添加点击事件 ===========
                        // 📢 注意：如果直接添加`onTapGesture`，那响应范围就只有【文本】的范围，解决方法：
                        // 1.把`Text`的范围拉到最大
                        .frame(maxWidth: .infinity, alignment: .leading)
                        // 只把范围拉大也是无法响应，因为除文本以外的地方就只是一个空间，并不是个实体
                        // 2.为了能让其余地方也能被点击，还得强制放入一个明确定义的、可以点击的形状
                        .contentShape(Rectangle()) // contentShape: Defines the content shape for hit testing.
                        // 放入一个矩形，就是整一块空间都可以响应点击事件了。
                        .onTapGesture {
                            guard !isEditing else { return }
                            isShowDetail = true
                        }
                    
                    if isEditing {
                        Image(systemName: "pencil")
                            .font(.title2.bold())
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .listStyle(.plain)
            .padding(.horizontal)
        }
        .background(.sysGb)
        // 往底部安全区域放入View：
        // 放入后，底部安全区域 += Button的高度
//        .safeAreaInset(edge: .bottom, alignment: isEditing ? .center : .trailing) {
//            if isEditing {
//                deleteButton
//            } else {
//                addButton
//            }
//        }
        // 由于两个Button的高度不一致，会导致切换时上面的视图发生抖动，
        // 为了保持这个底部高度一致，那就让这两个Button一直存在：
        // Tips: 把这两个Button一起放到ZStack中，ZStack高度则会【固定】是高度比较大的那个，
        // 并且能设置这两个Button水平对齐（alignment: .center，默认就是）。
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(isPresented: $isShowDetail) {
            let food = foods.randomElement()!
            
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
            // 读取`overlay`上面这部分的视图大小
            .overlay {
                GeometryReader { proxy in
                    //【注意】：不可以直接在【子视图内部】刷新父视图的State属性
//                    detailHeight = proxy.size.height
                    
                    // `detailHeight`是父视图的State属性，
                    // 改变该属性就会影响里面子视图的布局，
                    // 然后此处子视图的布局只要发生改变，又会改变这个State属性，
                    // 从而又会让父视图重复去改变里面子视图的布局，周而复始，导致死循环。
                    // 参考：https://zhuanlan.zhihu.com/p/447836445
                    
                    // 解决方案：使用`PreferenceKey` ---【能够在视图之间传递值】
                    // PS：需要在`GeometryReader`里面放入一个视图才能读取到其坐标变化值，
                    // 因此放一个透明颜色，同时也可以防止遮挡到底下视图。
                    Color.clear
                        .preference(key: DetailSheetHeightKey.self, // PreferenceKey类型
                                    value: proxy.size.height) // 监听的值
                }
            }
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
    }
}

private extension FoodListView {
    struct DetailSheetHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 300
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

private extension FoodListView {
    var titleBar: some View {
        HStack {
            Label("食物清单", systemImage: "fork.knife")
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            EditButton()
                .buttonStyle(.bordered)
//                .environment(\.locale, .init(identifier: "zh-cn")) // 使用中文
        }
        .padding()
    }
    
    var addButton: some View {
        Button {
            
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .padding()
                // 使用色盘模式：可以设置主色和次色（去「SF字符」App查看）
                .symbolRenderingMode(.palette)
                // 依次设置色盘颜色：主色、次色
                .foregroundStyle(.white, Color.accentColor.gradient)
        }
    }
    
    var deleteButton: some View {
        Button {
            withAnimation {
                foods = foods.filter { !selectedFoods.contains($0.id) }
            }
        } label: {
            Text("删除已选项目")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .mainButtonStyle(shape: .roundedRectangle(radius: 8))
        .padding(.horizontal, 50)
    }
    
    func buildFloatButton() -> some View {
        ZStack {
            deleteButton
                .opacity(isEditing ? 1 : 0)
                // 自定会转场效果
                .transition(
                    .move(edge: .leading) // 从左侧进场
                    .combined(with: .opacity) // 透明渐变
                    .animation(.easeInOut)
                )
                .id(isEditing)
            
            addButton
                .opacity(isEditing ? 0 : 1)
                .scaleEffect(isEditing ? 0.3 : 1)
                .animation(.easeInOut, value: isEditing)
                // 最后再设置frame是为了让动画只影响addButton（以上的部分），否则是整个区域都会缩放
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    func buildNutritionView(title: String, value: String) -> some View {
        GridRow {
            Text(title)
                .gridCellAnchor(.leading)
            Text(value)
                .gridCellAnchor(.trailing)
        }
    }
}

struct FoodList_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
