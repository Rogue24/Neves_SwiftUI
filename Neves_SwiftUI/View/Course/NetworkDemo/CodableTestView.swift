//
//  CodableTestView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/2/16.
//

import SwiftUI

struct CodableTestView: View {
    @State var text1: String = ""
    @State var text2: String = ""
    @State var text3: String = ""
    @State var text4: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Do it!") {
                doit()
            }
            
            if text1.count > 0 {
                Text(text1)
            }
            
            if text2.count > 0 {
                Text(text2)
            }
            
            if text3.count > 0 {
                Text(text3)
            }
            
            if text4.count > 0 {
                Text(text4)
            }
        }
    }
}

private struct MyResponse<T: Decodable>: Decodable {
    var status: Int
    var quota: Int
    var response: T
}

private extension CodableTestView {
    func doit() {
        do {
            let user = try JSONDecoder().decode(User.self, from: jsonData1)
            let data = try JSONEncoder().encode(user)
            text1 = String(data: data, encoding: .utf8)!
            
            let rsp1: MyResponse<[User2]> = try JSONDecoder().decode(MyResponse.self, from: jsonData2)
            text2 = "\(rsp1)"
            
            let rsp2: MyResponse<User3> = try JSONDecoder().decode(MyResponse.self, from: jsonData3)
            text3 = "\(rsp2)"
            
            let rsp3: MyResponse<User4> = try JSONDecoder().decode(MyResponse.self, from: jsonData3)
            text4 = "\(rsp3)"
        } catch {
            text1 = "\(error.localizedDescription)"
            text2 = ""
            text3 = ""
            text4 = ""
        }
    }
}

// MARK: - 🌰1 使用Enum的RawVallue声明不同名称

private let jsonData1 = Data(
"""
{
"id": 13,
"fullName": "JianPing",
}
""".utf8)

private extension CodableTestView {
    struct User {
        var id: Int
        var name: String
        
        enum CodingKeys: String, CodingKey {
            case id
            // 本地属性名跟服务器数据名不一样的情况：
            case name = "fullName" // 使用case的名字作为属性名，`rawValue`作为服务器数据对应的key
        }
    }
}

extension CodableTestView.User: Decodable {
    init(from decoder: Decoder) throws {
        // 1.建立一个 Container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 2.通过 CodingKey 从 Container 拿到对应的数据
        // 3.把数据存入属性，启动类型
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

extension CodableTestView.User: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

// MARK: - 🌰2 处理不同的命名惯用法（蛇形 <-> 驼峰）
/// 备忘录中的`Course5_03`

// MARK: - 🌰3 Nested数据（嵌套数据的处理）

private let jsonData2 = Data(
"""
{
"status": 200,
"quota": 100,
"response": [
    {"id": 13, "firstName": "Jian", "lastName": "Ping",},
    {"id": 49, "firstName": "Mei", "lastName": "Nan",},
],
}
""".utf8)

private extension CodableTestView {
    struct User2: Decodable {
        var id: Int
        var name: String
        
        enum MyKeys: CodingKey {
            case id, firstName, lastName
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MyKeys.self)
            
            self.id = try container.decode(Int.self, forKey: .id)
            
            let firstName = try container.decode(String.self, forKey: .firstName)
            let lastName = try container.decode(String.self, forKey: .lastName)
            self.name = firstName + " " + lastName
        }
    }
}

// MARK: - 🌰4 解析 UnkeyedContainer（【字典】<->【数组】）

private let jsonData3 = Data(
"""
{
"status": 200,
"quota": 100,
"response": {
    "id": 13,
    "firstName": "Jian",
    "lastName": "Ping",
    "friends":[
        {"id": 38},
        {"id": 46},
    ],
},
}
""".utf8)

private extension CodableTestView {
    struct User3: Decodable {
        var id: Int
        var name: String
        var friendIDs: [Int]
        
        enum MyKeys: CodingKey {
            case id, firstName, lastName, friends
        }
        
        enum FriendKeys: CodingKey {
            case id
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MyKeys.self)
            
            self.id = try container.decode(Int.self, forKey: .id)
            
            let firstName = try container.decode(String.self, forKey: .firstName)
            let lastName = try container.decode(String.self, forKey: .lastName)
            self.name = firstName + " " + lastName
            
            // 现在的`container`是【字典】的形状，转成【数组】形状的`friendContainer`去遍历数据
            // `nestedUnkeyedContainer(forKey:)`：【字典】->【数组】
            // `nestedContainer(keyedBy:)`：【数组】->【字典】
            var friendContainer = try container.nestedUnkeyedContainer(forKey: .friends)
            var fIDs: [Int] = []
            while !friendContainer.isAtEnd {
                print("count: \(friendContainer.count ?? 0), currentIndex: \(friendContainer.currentIndex)")
                /// 📢 注意1：
                /// 由于`nestedContainer`是相当于【数组】->【字典】的类型变换操作，会改变`friendContainer`自身的数据结构，
                /// 所以不能用`let`引用`friendContainer`，要用`var`。
                let frienndIDContainer = try friendContainer.nestedContainer(keyedBy: FriendKeys.self)
                fIDs.append(try frienndIDContainer.decode(Int.self, forKey: .id))
                
                /// 📢 注意2：
                /// 这里通过判断`isAtEnd`来进行循环，【必须确保】有对`friendContainer`进行【解码】相关的操作，
                /// 例如`nestedContainer`或`decode`等（`UnkeyedDecodingContainer`中有`mutating`声明的方法），
                /// 每进行一次【解码】相关的操作`currentIndex`就会+1，直至`currentIndex`达到`count`所需次数，`isAtEnd`才变为`true`。
                /// 可以打开以下注释即可观察区别：
//                print("count: \(friendContainer.count ?? 0), currentIndex: \(friendContainer.currentIndex)")
//                _ = try friendContainer.decode([String: Int].self)
//                print("count: \(friendContainer.count ?? 0), currentIndex: \(friendContainer.currentIndex)")
                /// 否则如果对`friendContainer`什么都不做，就会死循环！
            }
            self.friendIDs = fIDs
        }
    }
}

// MARK: - 🌰5

private extension KeyedDecodingContainerProtocol {
    // subscript的语法类似于实例方法、计算属性，本质就是方法(函数)
    // subscript可以没有set方法，但必须要有get方法
    
    // associatedtype Key : CodingKey
    subscript<T: Decodable>(_ key: Key) -> T { // ❌ -> throws T，subscript不能在函数的返回添加throws。
        // 当需要在subscript或是属性中「抛出错误」，或者做「async」的时候，
        // 必须要在里面去定义ta的【get】方法：
        get throws {
            try decode(T.self, forKey: key)
        }
    }
}

private extension UnkeyedDecodingContainer {
    mutating func map<T>(_ transform: (Decoder) throws -> T) throws -> [T] {
        var items: [T] = []
        while !isAtEnd {
            let item = try transform(superDecoder())
            items.append(item)
        }
        return items
    }
}

private extension CodableTestView {
    struct User4: Decodable {
        var id: Int
        var name: String
        var friendIDs: [Int]
        
        enum MyKeys: CodingKey {
            case id, firstName, lastName, friends
        }
        
        enum FriendKeys: CodingKey {
            case id
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MyKeys.self)
            
            
            self.id = try container[.id]
            
            let firstName: String = try container[.firstName]
            let lastName: String = try container[.lastName]
            self.name = firstName + " " + lastName
            
            // 现在的`container`是【字典】的形状，转成【数组】形状的`friendContainer`去遍历数据
            // `nestedUnkeyedContainer(forKey:)`：【字典】->【数组】
            var friendContainer = try container.nestedUnkeyedContainer(forKey: .friends)
            self.friendIDs = try friendContainer.map { 
//                friendDecoder in
//                let frienndIDContainer = try friendDecoder.container(keyedBy: FriendKeys.self)
//                return try frienndIDContainer[.id]
                try $0.container(keyedBy: FriendKeys.self)[.id]
            }
            
//            container.superDecoder().container(keyedBy: )
            
//            self.friendIDs = try container.decode([[String:Int]].self, forKey: .friends).map({ $0["id"] ?? 0 })
            
            
            
        }
    }
}


#Preview {
    CodableTestView()
}
