//
//  EnvironmentTestView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/12.
//

import SwiftUI

struct EnvironmentTestView: View {
    @Environment(\.testTag) var testTag // 数值不可变
    @Environment(\.testBindTag) var bindTag // 数值可变
    @Environment(\.testTagBox) var tagBox // 数值可变
    @Environment(\.testAction) var action // 执行函数
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("testTag: \(testTag)")
            
            Text("testBindTag: \(bindTag.wrappedValue)")
            Button("add testBindTag") {
                bindTag.wrappedValue += 1 // 通过`wrappedValue`访问本体
            }
            
            Text("testTagBox: \(tagBox.wrappedValue.tag)")
            Button("add testTagBox") {
                tagBox.wrappedValue.add() // 通过`wrappedValue`访问本体
            }
            
            Button("testAction") {
                action() // 使用了callAsFunction的语法糖
            }
            
            NavigationLink(destination: EnvironmentTestView2()) {
                Text("go EnvironmentTestView2")
            }
            
            Button("go back") {
                mode.wrappedValue.dismiss()
            }
        }
    }
}

struct EnvironmentTestView2: View {
    @Environment(\.testTag) var testTag // 数值不可变
    @Environment(\.testBindTag) var bindTag // 数值可变
    @Environment(\.testTagBox) var tagBox // 数值可变
    @Environment(\.testAction) var action // 执行函数
    @Environment(\.presentationMode) var mode
    
    @State var myBindTag = 777
    @State var myTagBox = JPTestTagBox(tag: 99)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("testTag: \(testTag)")
            
            Text("testBindTag: \(bindTag.wrappedValue)")
            Button("add testBindTag") {
                bindTag.wrappedValue += 1 // 通过`wrappedValue`访问本体
            }
            
            Text("testTagBox: \(tagBox.wrappedValue.tag)")
            Button("add testTagBox") {
                tagBox.wrappedValue.add() // 通过`wrappedValue`访问本体
            }
            
            Button("testAction") {
                action() // 使用了callAsFunction的语法糖
            }
            
            NavigationLink(destination: EnvironmentTestView3()) {
                Text("go EnvironmentTestView3")
            }
            
            Button("go back") {
                mode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitle("EnvironmentTestView2", displayMode: .inline)
        // 注意：貌似`EnvironmentValue`如果已经有源头了，就无法中途更改。
        .environment(\.testTag, 444)
        .environment(\.testBindTag, $myBindTag)
        .environment(\.testTagBox, $myTagBox)
    }
}

struct EnvironmentTestView3: View {
    @Environment(\.testTag) var testTag // 数值不可变
    @Environment(\.testBindTag) var bindTag // 数值可变
    @Environment(\.testTagBox) var tagBox // 数值可变
    @Environment(\.testAction) var action // 执行函数
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("testTag: \(testTag)")
            
            Text("testBindTag: \(bindTag.wrappedValue)")
            Button("add testBindTag") {
                bindTag.wrappedValue += 1 // 通过`wrappedValue`访问本体
            }
            
            Text("testTagBox: \(tagBox.wrappedValue.tag)")
            Button("add testTagBox") {
                tagBox.wrappedValue.add() // 通过`wrappedValue`访问本体
            }
            
            Button("testAction") {
                action() // 使用了callAsFunction的语法糖
            }
            
            Button("go back") {
                mode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitle("EnvironmentTestView3", displayMode: .inline)
    }
}
