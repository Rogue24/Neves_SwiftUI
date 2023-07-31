//
//  StateObjectTestView.swift
//  JPDesignCode_iOS15
//
//  Created by 周健平 on 2022/6/20.
//
//  参考1：https://zhuanlan.zhihu.com/p/151286558
//  参考2：https://onevcat.com/2020/06/stateobject

/// `@StateObject`和`@ObservedObject`的区别就是实例对象是否【被创建其的View】所持有，其生命周期是否完全可控。
/// `@StateObject`的生命周期跟随【被创建其的View】，而`@ObservedObject`并不跟随，其生命周期存在不确定性；
/// 对于`View`自己创建的`ObservableObject`状态对象来说，极大概率你可能需要使用新的`@StateObject`来让它的存储和生命周期更合理，
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
    @State var showRealName = false
    var body: some View {
        List {
            HStack {
                Button("Toggle Name") {
                    showRealName.toggle()
                }
                Text("\(showRealName ? "Zhou Jian Ping" : "shuaigeping")")
            }
            
            // `@StateObject`的另一个重要特性是和`@State`的“生命周期”保持统一，
            // 让`SwiftUI`全面接管背后的存储，也可以避免一些不必要的bug。
            NavigationLink("@StateObject", destination: CountViewState())
            
            // `@ObservedObject`只是在`View`和`Model`之间添加订阅关系，而不影响存储。
            // 使用`@ObservedObject`的话，SwiftUI将不再能够帮助我们进行状态管理，除非通过`Toggle`按钮刷新整个`StateObjectTestView`
            // 否则【使用`@ObservedObject`声明的状态】在再次展示时将保留原来的状态。
            NavigationLink("@ObservedObject", destination: CountViewObserved())
            /**
             * 当`StateObjectTestView`中的状态发生变化，
             * `StateObjectTestView.body`被重新求值时，
             * `CountViewObserved.state`就会被【重新生成】。
             */
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
