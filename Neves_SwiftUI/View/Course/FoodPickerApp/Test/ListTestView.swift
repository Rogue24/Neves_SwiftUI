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
    
    @State var str: String = ""
    @State var isShowStr = false
    
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
            
            Button {
                // `@State`可以直接修改值
//                isShowStr.toggle()
                
                // `$isShowStr`获取包装后的类型：`Binding<Bool>`，修改绑定值需要通过`wrappedValue`
                let iss = $isShowStr
                iss.wrappedValue.toggle()
                
            } label: {
                Text("str: \(str)")
            }
            .padding()
            
            if isShowStr {
                Test(str: $str)
                    .padding()
            }
        }
        .onAppear() {
            str = "\(Int(Date().timeIntervalSince1970))"
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

private extension ListTestView {
    struct Test: View {
        @Binding var str: String
        
        var body: some View {
            Text(str)
                .frame(width: 200, height: 40)
                .background(.randomColor)
                .onTapGesture {
                    // `@Binding`可以直接修改绑定值
//                    str = "\(Int(Date().timeIntervalSince1970))"
                    
                    // `$str`获取原类型：`Binding<String>`，修改绑定值则需要通过`wrappedValue`
                    let s = $str
                    s.wrappedValue = "\(Int(Date().timeIntervalSince1970))"
                }
            
        }
    }
}

struct ListTestView_Previews: PreviewProvider {
    static var previews: some View {
        ListTestView()
    }
}
