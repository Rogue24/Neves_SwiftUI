//
//  StateObjectTestView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/20.
//
//  参考：https://zhuanlan.zhihu.com/p/151286558

/// `@StateObject`和`@ObservedObject`的区别就是实例对象是否【被创建其的View】所持有，其生命周期是否完全可控。
/// `@StateObject`的生命周期跟随【被创建其的View】，而`@ObservedObject`并不跟随，其生命周期存在不确定性；
/// 因此更加推荐使用`@StateObject`来消除代码运行的不确定性。

// MARK: - 使用【模拟器或真机】测试

import SwiftUI

//class BaseObject {
//    let type: String
//    let id: Int
//    var count = 0
//
//    init(type: String) {
//        self.type = type
//        self.id = Int.random(in: 0...1000)
//        print("type: \(type), id: \(id) --- init")
//    }
//
//    deinit {
//        print("type: \(type), id: \(id) --- deinit")
//    }
//}

class MyStateObject: ObservableObject {
    let type: String
    let id: Int
    @Published var count = 0
    
    init(type: String) {
        self.type = type
        self.id = Int.random(in: 0...1000)
        print("type: \(type), id: \(id) --- init")
    }
    
    deinit {
        print("type: \(type), id: \(id) --- deinit")
    }
}

struct CountViewState: View {
//    var state = BaseObject(type: "StateObject")
    @StateObject var state = MyStateObject(type: "StateObject")
    
    var body: some View {
        VStack {
            Text("@StateObject count: \(state.count)")
            
            Button("+1") {
                state.count += 1
            }
        }
    }
}

struct CountViewObserved: View {
//    var state = BaseObject(type: "ObservedObject")
    @ObservedObject var state = MyStateObject(type: "ObservedObject")
    
    var body: some View {
        VStack {
            Text("@ObservedObject count: \(state.count)")
            
            Button("+1") {
                state.count += 1
            }
        }
    }
}

struct StateObjectTestView: View {
    
    // MARK: - Test1
//    @State var count = 0
//    var body: some View {
//        VStack {
//            Text("刷新CounterView计数: \(count)")
//            Button("刷新") {
//                count += 1
//            }
//            
//            CountViewState()
//                .padding()
//            
//            CountViewObserved()
//                .padding()
//        }
//    }
    
    // MARK: - Test2
    var body: some View {
        NavigationView {
            List {
                NavigationLink("@StateObject", destination: CountViewState())
                NavigationLink("@ObservedObject", destination: CountViewObserved())
            }
        }
    }
    
    // MARK: - Test3
//    @State var showStateObjectSheet = false
//    @State var showObservedObjectSheet = false
//    var body: some View {
//        List{
//            Button("Show StateObject Sheet") {
//                showStateObjectSheet.toggle()
//            }
//            .sheet(isPresented: $showStateObjectSheet) {
//                CountViewState()
//            }
//
//            Button("Show ObservedObject Sheet") {
//                showObservedObjectSheet.toggle()
//            }
//            .sheet(isPresented: $showObservedObjectSheet) {
//                CountViewObserved()
//            }
//        }
//    }
}

struct StateObjectTestView_Previews: PreviewProvider {
    static var previews: some View {
        StateObjectTestView()
    }
}
