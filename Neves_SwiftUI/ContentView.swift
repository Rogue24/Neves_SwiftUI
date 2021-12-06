//
//  ContentView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/9/25.
//

import SwiftUI

struct ContentView: View {
    
    let myData = Array(0...50)
    
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
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
