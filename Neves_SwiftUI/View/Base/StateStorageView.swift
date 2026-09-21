//
//  StateStorageView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2026/9/18.
//
//  参考：https://chatgpt.com/share/6aad1472-d054-83ee-a65f-f1849dc79a88
//

import SwiftUI

/*
 CounterView
 ┌──────────────┐
 │              │
 │  @State ──────────────┐
 └──────────────┘        │
                         ↓
                  SwiftUI 的“小盒子”
                  ┌──────────────┐
                  │ count = 0    │
                  └──────────────┘
 
 ┌─────────────────────────┐
 │       View struct       │
 │                         │
 │  @State var count       │
 │       │                 │
 └───────┼─────────────────┘
         │
         │ 对应
         ↓
 ┌─────────────────────────┐
 │    SwiftUI State        │
 │       Storage           │
 │                         │
 │      count = 123        │
 └─────────────────────────┘
 
 重点：
 1.SwiftUI的`View`更像是一张：“我现在应该长什么样”的说明书。SwiftUI可能会不断地创建和销毁`View`，所以`View struct`本身并不是SwiftUI用来保存状态的地方。
 2.数据真正需要持续保存的是下面那个“小盒子”。而`CounterView`只是：“我要使用这个小盒子里的count”，所以`View`被重新创建，`State`仍然可以存在。
 3.`@State`的存储生命周期和`View struct`的生命周期不是一回事。
 
 View struct
 特点：
 - 可能频繁创建
 - 可能频繁销毁
 - 是值类型
 - 主要描述 UI
 
 State Storage
 特点：
 - 由 SwiftUI 管理
 - 和 View identity 关联
 - 用来保存状态
 - 不会因为 View struct 的普通重建就简单丢失
 
 那什么时候 State Storage 才会真的消失？
 - 不是：`View struct`被重新创建 → `State`消失，而更接近：SwiftUI认为这个`View`的`identity`已经不存在了 → 对应的`State storage`才会被销毁。
 */

struct StateStorageView: View {
    @State var showCounter = true
    
    var body: some View {
        // 🌰：`View`被重新创建，`State`仍然可以存在
        // 1.当`showCounter`为false时：
        //  `CounterView`只是隐藏了，并没有从SwiftUI的视图层级中消失，因此对应的`State storage`没有被销毁。
        // 2.当`showCounter`为true时：
        //  SwiftUI会重新创建了一个新的`CounterView`（跟隐藏的那个是两个不同的`struct`），
        //  但是它们在SwiftUI的视角下，对应的是同一个`State`存储位置。
        CounterView()
            .opacity(showCounter ? 1 : 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .ignoresSafeArea()
            .onTapGesture {
                showCounter.toggle()
            }
        
        // 🌰：`View`和`State`都被重新创建
        // 1.当`showCounter`为false时：
        //  `CounterView`从SwiftUI的视图层级中消失，所以对应的`State storage`也随之结束生命周期。
        // 2.当`showCounter`为true时：
        //  SwiftUI会重新创建了一个新的`CounterView`和新的`State Storage`。
//        ZStack {
//            Color.red
//            if showCounter {
//                CounterView()
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .ignoresSafeArea()
//        .onTapGesture {
//            showCounter.toggle()
//        }
    }
}

private struct CounterView: View {
    @State var count: Int = GetCount()
    
    /// init 初始化的是新的`View struct`；
    /// @State 的实际状态存储由 SwiftUI 持有，并根据 View 的 identity 与这个 View 关联。
    init() {
//        _count = State(initialValue: GetCount())
        print("mroibowbno CounterView 初始化了 --- \(count)")
    }
    
    /*
     ***第一次创建***
     CounterView.init()
         ↓
     GetCount() -> 24       ← 执行
         ↓
     State(initialValue: 24)
         ↓
     State Storage 第一次建立
         ↓
     count = GetCount() 的结果
     
     ***点击按钮后***
     count += 25
     
     ***隐藏再显示，会重新创建***
     CounterView.init()
         ↓
     GetCount() -> 19        ← ⚠️ 还是会执行！
         ↓
     State(initialValue: 19)
         ↓
     SwiftUI 发现这个 State Storage 已经存在
         ↓
     不会用 19 覆盖原来的 25
         ↓
     最终 count 还是 25
     */
    
    var body: some View {
        Text("\(count)")
            .foregroundColor(.yellow)
            .font(.system(size: CGFloat(count), weight: .bold))
            .onTapGesture {
                withAnimation {
                    count += 1
                }
            }
    }
}

private func GetCount() -> Int {
    let x = Int.random(in: 10...30)
    print("mroibowbno GetCount --- \(x)")
    return x
}
