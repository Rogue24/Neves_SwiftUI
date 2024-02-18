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
        }
    }
}



private extension CodableTestView {
    func doit() {
        let user = try! JSONDecoder().decode(User.self, from: jsonData1)
        let data = try! JSONEncoder().encode(user)
        text1 = String(data: data, encoding: .utf8)!
        
        let rsp: Response<[User2]> = try! JSONDecoder().decode(Response.self, from: jsonData2)
        text2 = "\(rsp)"
    }
}

// MARK: - 🌰1

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

// MARK: - 🌰2

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
    struct Response<T: Decodable>: Decodable {
        var status: Int
        var quota: Int
        var response: T
    }
    
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

// MARK: - 🌰3

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
                let frienndIDContainer = try friendContainer.nestedContainer(keyedBy: FriendKeys.self)
                fIDs.append(try frienndIDContainer.decode(Int.self, forKey: .id))
            }
            self.friendIDs = fIDs
        }
    }
}

#Preview {
    CodableTestView()
}
