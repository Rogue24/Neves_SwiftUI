//
//  Test1View.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/6.
//

import SwiftUI

struct Test1View: View {
    @State var isA = true
    @State(initialValue: "123") var testStr
    
    // @ViewBuilder：允许闭包中提供多个View
    var body: some View {
        // `View`的`body`就是使用`@ViewBuilder`修饰的：`@ViewBuilder var body: Self.Body { get }`
        // 所以可以直接在这里面使用`if`或者`switch`选择性返回哪个`View`
        if isA {
            ZStack {
                Color.yellow
                Text(testStr)
                    .onTapGesture {
                        testStr = "456"
                        isA = false
                    }
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Text("\(String(format: "%.2lf", geometry.frame(in: .global).maxY))")
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .edgesIgnoringSafeArea(.all)
        } else {
            Text(testStr)
                .padding()
                .background(Color.green) // 如果在padding前面加背景色，那么这个背景色则是添加padding前的大小
                .onTapGesture {
                    testStr = "123"
                    isA = true
                }
        }
    }
}

struct Test1View_Previews: PreviewProvider {
    static var previews: some View {
        Test1View()
        // 添加不同设备进行预览
//        Group {
//            TestView().previewDevice("iPhone 8")
//            TestView().previewDevice("iPhone XR")
//        }
    }
}
