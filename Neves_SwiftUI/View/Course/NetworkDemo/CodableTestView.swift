//
//  CodableTestView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/2/16.
//

import SwiftUI

struct CodableTestView: View {
    @State var text0: String = ""
    @State var text1: String = ""
    @State var text2: String = ""
    @State var text3: String = ""
    @State var text4: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Do it!") {
                doit()
            }
            
            if text0.count > 0 {
                Text(text0)
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
        .padding(.horizontal, 10)
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
            text0 = String(data: data, encoding: .utf8)!
        } catch {
            print("error0: \(error.localizedDescription)")
            text0 = "error0: \(error.localizedDescription)"
        }
        
        do {
            let user = try JSONDecoder().decode(User1.self, from: jsonData1)
            text1 = "\(user)"
        } catch {
            print("error1: \(error.localizedDescription)")
            text1 = "error1: \(error.localizedDescription)"
        }
        
        do {
            let rsp: MyResponse<[User2]> = try JSONDecoder().decode(MyResponse.self, from: jsonData2)
            text2 = "\(rsp)"
        } catch {
            print("error2: \(error.localizedDescription)")
            text2 = "error2: \(error.localizedDescription)"
        }
        
        do {
            let rsp: MyResponse<User3> = try JSONDecoder().decode(MyResponse.self, from: jsonData3)
            text3 = "\(rsp)"
        } catch {
            print("error3: \(error.localizedDescription)")
            text3 = "error3: \(error.localizedDescription)"
        }
        
        do {
            let rsp: MyResponse<User4> = try JSONDecoder().decode(MyResponse.self, from: jsonData4)
            text4 = "\(rsp)"
        } catch {
            print("error4: \(error.localizedDescription)")
            text4 = "error4: \(error.localizedDescription)"
        }
    }
}

// MARK: - 🌰0 使用Enum的RawVallue声明不同名称

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

// MARK: - 🌰1 数据中可能没有某个属性的情况

private extension CodableTestView {
    struct User1: Decodable {
        var id: Int
        var fullName: String
        // 📢 如果data中可能没有对应的某个属性，那就让该属性成为可选类型，解码时会自动置nil，否则会throw error
        var address: Int?
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

private let jsonData4 = Data(
"""
{
"status": 200,
"quota": 100,
"response": {
    "id": 775,
    "firstName": "Shuai",
    "lastName": "Ge",
    "friends":[
        {"id": 97, "666": "sss"},
        {"id": 23, "666": "bbb"},
    ],
    "bestFriend": {"id": 43, "666": "kkk"}
},
}
""".utf8)

private extension KeyedDecodingContainerProtocol {
    // subscript的语法类似于实例方法、计算属性，本质就是方法(函数)
    // subscript可以没有set方法，但必须要有get方法
    
    // associatedtype Key : CodingKey
    subscript<T: Decodable>(_ key: Key) -> T { // ❌ -> throws T，subscript不能在【函数的返回】添加「throws」。
        // 当需要在subscript或是属性中「抛出错误」，或者做「async」的时候，
        // 必须要在里面去定义ta的【get】方法：
        get throws {
            try decode(T.self, forKey: key)
        }
    }
}

/// `UnkeyedDecodingContainer`顾名思义就是没有`key`的`Container`，相当于是「指向数组第x个元素的起始指针」，
/// 🌰：
///
///     "friends":[
///         {"id": 97, "666": "sss"},
///         {"id": 23, "666": "bbb"},
///     ]
///
/// 此时第一个`UnkeyedDecodingContainer`就是`{"id": 97, "666": "sss"}`，但ta并不是一个字典，没办法通过`key`获取对应的`value`，只是一个指向数组第一个元素的 “指针”。
/// 接着通过`superDecoder`，获取到当前这一个`{"id": 97, "666": "sss"}`的`Decoder`（注意并不是整个`friends`的，而是第一个元素的），
/// 这里把`superDecoder`抛出去，让外部自行决定如何解码，例如将该`Decoder`转成`KeyedDecodingContainer`，即可通过`key`获取对应的`value`了。
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
        var bestFriendID: Int
        
        enum MyKeys: CodingKey {
            case id, firstName, lastName, friends, bestFriend
        }
        
//        enum FriendKeys: CodingKey {
//            case id
//        }
        
//        enum BestFriendKeys: CodingKey {
//            case id
//        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MyKeys.self)
            
            // container.superDecoder() 拿到的也就是 decoder
            // container <==> container.superDecoder().container(keyedBy: MyKeys.self)
            
            self.id = try container[.id]
            
            let firstName: String = try container[.firstName]
            let lastName: String = try container[.lastName]
            self.name = firstName + " " + lastName
            
            // 现在的`container`是【字典】的形状，转成【数组】形状的`friendContainer`去遍历数据
            // `nestedUnkeyedContainer(forKey:)`：【字典】->【数组】
            var friendContainer = try container.nestedUnkeyedContainer(forKey: .friends) 
            // --> get "response.friends" -> [[String: Any]]
            self.friendIDs = try friendContainer.map { // friendDecoder in
                // --> get "friends[x]" -> {"id": xx, "666": "xx"}
                
                // 方式一
//                let frienndIDContainer = try friendDecoder.container(keyedBy: FriendKeys.self)
//                return try frienndIDContainer[.id]
                
                // 方式二
//                return try $0.container(keyedBy: FriendKeys.self)[.id]
                
                // ~~~~~~ test ~~~~~~
                // 兼容Int类型的key
                let abc: String = try $0.container()[666]
                print(abc)
                // ~~~~~~ test ~~~~~~
                
                // 方式三
                // 获取可通过`String`和`Int`类型key解码的Container：
                // Decoding+：container() -> KeyedDecodingContainer<DecodingKey>
                return try $0.container()["id"]
                
//                var aaaaa: Int = try $0.container()[111]
//                aaaaa += 3
//                return aaaaa
            }
            // 相当于：
//            self.friendIDs = try container.decode([[String:Int]].self, forKey: .friends).map({ $0["id"] ?? 0 })
            
            let bestFriendContainer = try container.nestedContainer(key: .bestFriend)
            self.bestFriendID = try bestFriendContainer["id"]
            // 相当于：
//            let bestFriendContainer = try container.nestedContainer(keyedBy: BestFriendKeys.self, forKey: .bestFriend)
//            self.bestFriendID = try bestFriendContainer.decode(Int.self, forKey: .id)
        }
    }
}


#Preview {
    CodableTestView()
}
