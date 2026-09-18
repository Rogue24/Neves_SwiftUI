//
//  StateInitialView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2026/9/18.
//

import SwiftUI

private func GetCount() -> Int {
    let x = Int.random(in: 10...30)
    print("mroibowbno GetCount --- \(x)")
    return x
}

struct StateInitialView: View {
    @State var showCounter = false
    
    var body: some View {
        CounterView()
            .opacity(showCounter ? 1 : 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .ignoresSafeArea()
            .onTapGesture {
                showCounter.toggle()
            }
    }
}

/*
 参考：https://chatgpt.com/share/6aad1472-d054-83ee-a65f-f1849dc79a88
 
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
 
 */

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
