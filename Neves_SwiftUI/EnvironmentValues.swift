//
//  EnvironmentValues.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/12.
//

import SwiftUI

struct JPTestTagKey: EnvironmentKey {
    static var defaultValue = 111
}

struct JPTestTagBindKey: EnvironmentKey {
    static var defaultValue = Binding.constant(999)
}

struct JPTestTagBox {
    private(set) var tag = 0
    mutating func add() {
        tag += 1
    }
}
struct JPTestTagBoxKey: EnvironmentKey {
    static var defaultValue = Binding.constant(JPTestTagBox())
}

class JPTestAction {
    private var callCount = 0
    // 如果使用`struct`定义，想在`callAsFunction`中修改属性值则需要添加`mutating`，
    // 这样`callAsFunction`就失去语法糖效果，并且需要使用`Binding`类型。
    // 使用`struct`的话，建议`callAsFunction`里面不做任何属性的写操作（这里只是测试才使用`class`）。
    func callAsFunction() {
        callCount += 1
        print("jpjpjp Hi, I'm ZhouShuaige, you had call me \(callCount) times.")
    }
}
struct JPTestActionKey: EnvironmentKey {
    static var defaultValue = JPTestAction()
}

extension EnvironmentValues {
    var testTag: Int {
        set { self[JPTestTagKey.self] = newValue }
        get { self[JPTestTagKey.self] }
    }
    
    var testBindTag: Binding<Int> {
        set { self[JPTestTagBindKey.self] = newValue }
        get { self[JPTestTagBindKey.self] }
    }
    
    var testTagBox: Binding<JPTestTagBox> {
        set { self[JPTestTagBoxKey.self] = newValue }
        get { self[JPTestTagBoxKey.self] }
    }
    
    var testAction: JPTestAction {
        set { self[JPTestActionKey.self] = newValue }
        get { self[JPTestActionKey.self] }
    }
}
