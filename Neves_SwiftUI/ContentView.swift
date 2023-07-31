//
//  ContentView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/9/25.
//

import SwiftUI
import FunnyButton_SwiftUI

struct ContentView: View {
    @StateObject var router = NavigationRouter()
    @State var bindTag = 333
    @State var tagBox = JPTestTagBox()
    
    var body: some View {
        mainView
            // NavigationView在iPad端默认是左右两列的形式展示，需要手动设置回默认样式
            .navigationViewStyle(StackNavigationViewStyle())
            // 从这个根视图开始，打开的所有子视图都共享以下的环境变量（子视图无法重新定义）
            .environmentObject(router)
            .environment(\.testTag, 222)
            .environment(\.testBindTag, $bindTag)
            .environment(\.testTagBox, $tagBox)
            .environment(\.testAction, JPTestAction())
    }
    
    @ViewBuilder
    var mainView: some View {
        if #available(iOS 16.0, *) {
            NavigationStack(path: $router.path) {
                List(Demo.sections) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.demos) { demo in
                            NavigationLink(demo.title, value: demo)
                        }
                    }
                }
                .navigationBarTitle("Neves", displayMode: .large)
                .navigationDestination(for: Demo.self) { demo in
                    demo.body
                        .navigationBarTitle(demo.rawValue, displayMode: .inline)
                }
            }
        } else {
            NavigationView {
                List(Demo.sections) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.demos) { demo in
                            NavigationLink(destination: demo.body.navigationBarTitle(demo.rawValue, displayMode: .inline)) {
                                Text(demo.title)
                            }
                        }
                    }
                }
                .navigationBarTitle("Neves")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
