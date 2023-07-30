//
//  FoodListScreen.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/9.
//

import SwiftUI

struct FoodListScreen: View {
    @Environment(\.editMode) var editMode
    
    @State private var foods = Food.examples
    @State private var selectedFoodIDs = Set<Food.ID>()
    
    @State private var sheet: Sheet?
    
    // 是否正在编辑
    var isEditing: Bool { editMode?.wrappedValue == .active }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleBar
            
            // `rowContent`是个闭包，而这个闭包里面给到的参数是个`Binding`。
            // 如果闭包参数是个`Binding`，那么只要在参数名前面加上`$`，就代表使用的是这个`Binding`所包装的值：{ $food in ... }
            // - 不使用`$`，`food`就是个`Binding`，访问属性就得：`food.wrappedValue.name`
            // - 使用了`$`，`food`就是`Binding`所包装的值，相当于`Binding`使用了`wrappedValue`，可以直接访问属性：`food.name`
            List($foods, editActions: .all, selection: $selectedFoodIDs, rowContent: buildFoodRow)
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
        // 并且能设置这两个Button水平对齐（alignment: .center，默认就是这个）。
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(item: $sheet)
    }
}

private extension FoodListScreen {
    var titleBar: some View {
        HStack {
            Label("食物清单", sfs: .forkKnife)
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .xPush(to: .leading)
            
            EditButton()
                .buttonStyle(.bordered)
//                .environment(\.locale, .init(identifier: "zh-cn")) // 使用中文
        }
        .padding()
    }
    
    var addButton: some View {
        Button {
            sheet = .newFood { foods.append($0) }
        } label: {
            SFSymbol.plusCircleFill
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
                foods = foods.filter { !selectedFoodIDs.contains($0.id) }
            }
        } label: {
            Text("删除已选项目")
                .font(.title2.bold())
                .maxWidth()
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
                // 1.最后再设置frame是为了让动画只影响addButton（以上的部分），否则是整个区域都会缩放
                .xPush(to: .trailing)
                // 2.又或者把整个`addButton`放入到`HStack`中再加个`Spacer()`也可以实现同样效果
        }
    }
    
    func buildFoodRow(_ foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name)
                .padding(.vertical, 10)
                // =========== 给整行添加点击事件 ===========
                // 📢 注意：如果直接添加`onTapGesture`，那响应范围就只有【文本】的范围，解决方法：
                // 1.把`Text`的范围拉到最大
                .xPush(to: .leading)
                // 只把范围拉大也是无法响应，因为除文本以外的地方就只是一个空间，并不是个实体
                // 2.为了能让其余地方也能被点击，还得强制放入一个明确定义的、可以点击的形状
                .contentShape(Rectangle()) // contentShape: Defines the content shape for hit testing.
                // 放入一个矩形，就是整一块空间都可以响应点击事件了。
                .onTapGesture {
                    guard isEditing else {
                        sheet = .foodDetail(food)
                        return
                    }
                    
                    if selectedFoodIDs.contains(food.id) {
                        selectedFoodIDs.remove(food.id)
                    } else {
                        selectedFoodIDs.insert(food.id)
                    }
                }
            
            if isEditing {
                SFSymbol.pencil
                    .font(.title2.bold())
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        sheet = .editFood(foodBinding)
                    }
            }
        }
    }
}

struct FoodList_Previews: PreviewProvider {
    static var previews: some View {
        FoodListScreen()
    }
}
