//
//  ContentView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/9/25.
//

import SwiftUI

struct ContentView: View {
    @State var bindTag = 333
    @State var tagBox = JPTestTagBox()
    
    var body: some View {
        NavigationView {
            List(Demo.sections) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.items) { item in
                        NavigationLink(destination: item.body) {
                            Text(item.title)
                        }
                    }
                }
            }
            .navigationBarTitle("Neves")
        }
        // NavigationView在iPad端默认是左右两列的形式展示，需要手动设置回默认样式
        .navigationViewStyle(StackNavigationViewStyle())
        // 从这个根视图开始，打开的所有子视图都共享以下的环境变量（子视图无法重新定义）
        .environment(\.testTag, 222)
        .environment(\.testBindTag, $bindTag)
        .environment(\.testTagBox, $tagBox)
        .environment(\.testAction, JPTestAction())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
