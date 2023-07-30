//
//  ShapeTestView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/13.
//
//  参考：https://www.fatbobman.com/posts/centering_the_View_in_SwiftUI

import SwiftUI
import FunnyButton_SwiftUI

struct ShapeTestView: View {
    @State var isShapeTest = true
    
    @State var str: String? = nil
    
    @State var shows = [
        "左上": true,
        "右上": true,
        "左下": true,
        "右下": true,
    ]
    
    var body: some View {
        Group {
            if isShapeTest {
                shapeTestView
            } else {
                zIndexView
            }
        }
        .funnyAction {
            isShapeTest.toggle()
        }
        
        // 虽然`VStack`的大小类型是`Neutral`（高度根据`子View`决定），
        // 但是可以通过设置frame来固定大小。
//        VStack {
//            VStack {
//                if isShapeTest {
//                    Text("trtttt")
//                }
//            }
//            .frame(height: 80)
//            .background(.randomColor)
//
//            Text("haaa")
//        }
//        .funnyAction {
//            isShapeTest.toggle()
//        }
    }
}

// MARK: - shapeTestView
private extension ShapeTestView {
    var shapeTestView: some View {
        VStack(spacing: 0) {
            Circle().fill(.indigo)
                .frame(height: 200)
            
            if let str {
                Text(str)
                    .font(.largeTitle)
                    /// ⁉️【1】
                    /// 明明有足够的剩余空间，为啥`Text`会显示不全？
                    ///
                    /// `Text`可以有多种表现方式：一种是完整显示，另一种是后面被切掉用`...`代替。
                    ///
                    /// 由于下面那个`Circle()`的大小类型是`Expanding`，此时`VStack`会这样认为：
                    /// 既然`Text`能切掉后面，减少剩余高度的占用，那就用被切掉的表现方式吧，
                    /// 让出更多的高度给下面的`Circle()`，尽可能均分剩余高度。
                    ///
                    /// 解决方法：使用`.fixedSize(xxx)`，强制让`View`使用自己最理想的大小。
                    /// 这里是让`Text`在宽度固定的情况下，在垂直方向使用最理想的高度，确保能【完整显示】文本。
                    .fixedSize(horizontal: false, vertical: true) // 只需要垂直方向强制使用
                    .multilineTextAlignment(.center)
                    .lineSpacing(15)
                    .frame(width: 120)
                    .background(.red)
            }
            
            /// 上面的`Text`使用了`.fixedSize(xxx)`，为了能完整显示文本，会减少`Circle()`的高度占用。
            Circle().fill(.orange)
            
            ZStack {
                Circle().fill(.teal)
                Circle().fill(.image(Image("dinner"), scale: 0.2))
                Text("Hello")
                    .font(.system(size: 80).bold())
                    .foregroundStyle(.linearGradient(colors: [.red, .purple], startPoint: .leading, endPoint: .trailing))
                    /// ⁉️【2】
                    /// `.background(xxx)`的参数只能是`ShapeStyle`类型，
                    /// 但是只要使用了`scaleEffect`之后，那么返回的是`View`，类型不符合。
                    /// 解决方法：换成`.background { xxx }`，在里面返回一个`View`当作背景。
//                    .background(.sysBg.scaleEffect(1.3))
                    .background {
                        Color.sysBg
                            .scaleEffect(x: 1.5, y: 1.1) // 横向和纵向都放大一点
                            .blur(radius: 20) // 模糊一下
                    }
            }
            .frame(height: 300)
        }
        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height - 140)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                str = "What the hell?"
            }
        }
        .onDisappear() {
            str = nil
        }
    }
}

// MARK: - zIndexView
private extension ShapeTestView {
    /// ⁉️【3】
    /// 某个`View`消失/出现，其他`View`的`Z-Position`都会发生改变，
    /// 使用动画会有异常：消失会立马看不见，没有动画效果（出现时没事）。
    /// 解决方法：只要把`zIndex`都设置成【非0】即可，目前还不知道为啥。
    var zIndexView: some View {
        ZStack {
            buildTextView("左上", .topLeading).zIndex(1)
            buildTextView("右上", .topTrailing).zIndex(1)
            buildTextView("左下", .bottomLeading).zIndex(1)
            buildTextView("右下", .bottomTrailing).zIndex(1)
        }
        .animation(.easeInOut, value: shows)
    }
    
    @ViewBuilder
    func buildTextView(_ text: String, _ pos: Alignment) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.primary)
            .frame(width: 180, height: 140)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: pos)
            .onTapGesture {
                shows[text]?.toggle()
            }
        
        if shows[text] ?? false {
            Text(text)
                .font(.largeTitle.bold())
                .foregroundColor(.mint)
                .background(.blue)
                .padding(30)
                /// ⁉️【4】
                /// `background`使用`ShapeStyle`时，
                /// 可以通过`ignoresSafeAreaEdges`参数设置是否忽略安全区域，默认为`.all`（忽略全部）。
                /// 因此当视图放置在`XStack`的【边上】时，`background`会连同安全区域一并渲染。
                /// 解决方法：`.background(xxx, ignoresSafeAreaEdges: [])`，不要忽略安全区域。
                .background(.red, ignoresSafeAreaEdges: [])
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: pos)
                .allowsHitTesting(false)
        }
    }
}

struct ShapeTestView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeTestView()
    }
}
