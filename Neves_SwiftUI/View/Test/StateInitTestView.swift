//
//  StateInitTestView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/7.
//
// 【从外部给State初始化的注意点】
//  学自：https://onevcat.com/2021/01/swiftui-state

import SwiftUI

struct StateInitTestView: View {
    @State private var value = 99
    
    var identifier: String {
        value < 105 ? "id1" : "id2"
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Text("me: \(value)")
                Button("+") { value += 1 }
            }
            
            DetailView0(number: value) // 99 -> 100（以前会报错，现在不会）
            
            DetailView1(number: value) // 99 -> 0（需掌握为什么）
            
            DetailView2(number: value) // 99 -> 100（需掌握为什么）
            
            DetailView3(number: value) // 99 -> 0 -> 100
                .id(identifier)
            /// 被`id modifier`修饰后：
            /// 每次`body`求值时，如果`identifier`出现不一致，原来的 DetailView3 将被废弃，所有状态将被清除，并被重新创建；
            /// 最新的`value值`将被重新通过初始化方法设置到`DetailView3.tempNumber`，
            /// `DetailView3`的`onAppear`也会被触发，最终显示最新的`value值`。
        }
    }
}

// MARK: - 从外部给确定类型的State初始化
struct DetailView0: View {
    @State private var number: Int
    /// 对于`@State`的声明，会在当前`View`中带来一个【自动生成】的私有存储属性，来存储真实的`State struct`值
//    private var _number: State<Int>
    
    /// 以前会报错，因为在调用`self.number`的时候，底层`_number`是没有完成初始化的。
    /// 在最新的Xcode中已经不会报错了：对于初始化方法中【类型匹配】的情况，
    /// - 不匹配的情况：例如`DetailView1`中的`Int?`和`Int`
    /// Swift 编译时会将其映射到内部底层存储的值，并完成设置（相当于直接赋值：`_number._value = value`）。
    init(number: Int) {
        self.number = number + 1
        print("000: init \(self.number)") // -> 100
    }
    
    var body: some View {
        print("000: body \(number)")
        return HStack(spacing: 10) {
            Text("000: \(number)")
            Button("+") { number += 1 }
        }
    }
}

// MARK: - 从外部给可选类型的State初始化（无法初始化）
struct DetailView1: View {
    @State private var number: Int?
    /// 对于`@State`的声明，会在当前`View`中带来一个【自动生成】的私有存储属性，来存储真实的`State struct`值
//    private var _number: State<Int?>

    /// `Int?`的声明在初始化时会默认赋值为`nil`，让`_number`完成初始化：`_number = State<Optional<Int>>(_value: nil, _location: nil))`
    /// 此时对`self.number`进行赋值是无效的，根据`State<Value>`的内部实现得知：
    /// 想通过`self.number`进行赋值的前提是`_graph`不为`nil`，而`_graph`是在`init`【之后】、`body`求值前才被赋值。
    /// PS: `_graph`相当于这个`State`要去渲染的那个`View`。
    /// 因此无法在`init`中对`number`进行初始化。
    init(number: Int) {
        self.number = number + 1
        print("111: init \(self.number ?? 0)") // -> 0
    }
    /// 📢：对于初始化方法中【类型匹配】的情况（例如`DetailView0`），Swift 编译时会将其映射到内部底层存储的值，并完成设置。
    /// 不过，对于【类型不匹配】的情况（例如`Int?`和`Int`），这个映射依旧不成立，所以无法通过这种方式完成初始化。
    
    /// - `init`【之后】
    /// * 此时`_graph`才被赋值，有值之后`_number`才能通过`self.number`进行赋值
    /// - `body`【之前】
    
    var body: some View {
        print("111: body \(number ?? 0)")
        return HStack(spacing: 10) {
            Text("111: \(number ?? 0)")
            Button("+") { number = (number ?? 0) + 1 }
        }
    }
}

// MARK: - 从外部给可选类型的State初始化（解决方案1）【推荐】
struct DetailView2: View {
    @State private var number: Int?
    /// 对于`@State`的声明，会在当前`View`中带来一个【自动生成】的私有存储属性，来存储真实的`State struct`值
//    private var _number: State<Int?>

    /// 由于`Int?`的声明在初始化时会默认赋值为`nil`，同时也让`_number`完成了初始化，
    /// 因此可以直接操作`_number`，对其完成初始化。
    init(number: Int) {
        _number = State(wrappedValue: number + 1)
        print("222: init \(self.number ?? 0)") // -> 100
    }

    var body: some View {
        print("222: body \(number ?? 0)")
        return HStack(spacing: 10) {
            Text("222: \(number ?? 0)")
            Button("+") { number = (number ?? 0) + 1 }
        }
    }
}

// MARK: - 从外部给可选类型的State初始化（解决方案2）
struct DetailView3: View {
    @State private var number: Int?
    /// 对于`@State`的声明，会在当前`View`中带来一个【自动生成】的私有存储属性，来存储真实的`State struct`值
//    private var _number: State<Int?>
    
    private var tempNumber: Int

    /// 将`init`中获取的`number值`先暂存，然后在`onAppear`中将初始值赋值给`number`。
    /// PS:  `onAppear`只在最初出现在屏幕上时被调用一次，可以通过特定方式（如`id modifier`）使其再次调用，因此要注意。
    init(number: Int) {
        self.tempNumber = number + 1
        print("333: init \(self.number ?? 0)") // -> 0
    }

    var body: some View {
        print("333: body \(number ?? 0)")
        return HStack(spacing: 10) {
            Text("333: \(number ?? 0)")
            Button("+") { number = (number ?? 0) + 1 }
        }.onAppear {
            number = tempNumber // -> 100
        }
    }
}

// MARK: - State<Value>内部的大概实现
/*
struct State<Value> : DynamicProperty {
    var _value: Value
    var _location: StoredLocation<Value>?
    
    var _graph: ViewGraph?
    
    var wrappedValue: Value {
        get { _value }
        set {
            updateValue(newValue)
        }
    }
    
    // 发生在 init 后，body 求值前。
    func _linkToGraph(graph: ViewGraph) {
        if _location == nil {
            _location = graph.getLocation(self)
        }
        if _location == nil {
            _location = graph.createAndStore(self)
        }
        _graph = graph
    }
    
    func _renderView(_ value: Value) {
        if let graph = _graph {
            // 有效的 State 值
            _value = value
            graph.triggerRender(self)
        }
    }
}
*/

struct StateInitTestView_Previews: PreviewProvider {
    static var previews: some View {
        StateInitTestView()
    }
}

