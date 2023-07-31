//
//  Test3View.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/6.
//

import SwiftUI

struct Test3View: View {
    @State var isA = true
    
    // @ViewBuilder：允许闭包中提供多个View
    var body: some View {
        RedBackgroundAndCornerView {
            // 使用`@ViewBuilder，就可以使用`if`或者`switch`选择性返回哪个`View`
            // 如果不使用`@ViewBuilder`修饰，那么闭包里面只能返回一个`View`，这里就会报错
            if isA {
                Text("123")
                    .padding()
            } else {
                Text("456")
                    .padding()
            }
            
            Color.randomColor
                .frame(width: 60, height: 30)
            
            Rectangle()
                .frame(width: 100, height: 80)
            
            Text("2")
                .padding()
            
            Text("456999999999")
                .padding()
        }
        .onTapGesture {
            isA.toggle()
        }
    }
}

struct RedBackgroundAndCornerView<Content: View>: View {
    let content: Content
    @State var needHidden: Bool = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.red)
            .cornerRadius(5)
    }
}

struct Test3View_Previews: PreviewProvider {
    static var previews: some View {
        Test3View()
    }
}
