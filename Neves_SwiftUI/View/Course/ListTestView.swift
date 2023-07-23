//
//  ListTestView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/6/26.
//

import SwiftUI

struct Dog: Identifiable {
    var name: String
    var age: Int
    
    var id: String { name }
}

struct ListTestView: View {
    
    @State var dogs = [
        Dog(name: "大白", age: 3),
        Dog(name: "Dottie", age: 7),
        Dog(name: "小宝", age: 99),
        Dog(name: "二卷", age: 4),
        Dog(name: "枸杞", age: 2),
    ]
    
    @State var selectedDogs = Set<Dog.ID>()
    
    var body: some View {
        VStack {
            List($dogs, editActions: .all, selection: $selectedDogs) { $dog in
                Text("\(dog.name) - \(dog.age)岁")
            }
            .listStyle(.insetGrouped)
            
            /// 用于切换编辑模式：
            /// 本来只能单选，编辑模式下可以多选（同时也可以删除和移动）。
            /// 也就是说可以让`selectedDogs`存放多个数据。
            EditButton()
                .padding()
            
            Button {
                JPrint(dogs)
            } label: {
                Text("look all dogs")
            }
            .padding()
            
            Button {
                JPrint(selectedDogs)
            } label: {
                Text("look selected dogs")
            }
            .padding()
        }
    }
    
    
    func aaa() {
        var a = 7
        
        let b = Binding(get: { a }, set: { a = $0 })
        b.wrappedValue += 3
        
        JPrint(b.wrappedValue)
        JPrint(a)
    }
}

struct ListTestView_Previews: PreviewProvider {
    static var previews: some View {
        ListTestView()
    }
}
