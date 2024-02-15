//
//  JSONTestView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/9/11.
//

import SwiftUI

struct JSONTestView: View {
    @AppStorage("ppperson") private var person: MyPerson = MyPerson(name: "Zhoujianping", age: 3)
    
    var body: some View {
        Text("Hello, \(person.name)")
            .onTapGesture {
                look()
            }
    }
    
    func look() {
        var person = MyPerson(name: "Zhoujianping_\(Int.random(in: 1...10))",
                              age: Int.random(in: 10..<30))
        
        let rawValue = person.rawValue
        print("jpjpjp person.rawValue - \(rawValue)")
        
        person = MyPerson(rawValue: rawValue)!
        print("jpjpjp person - \(person)")
        
        self.person = person
    }
}

/**
 * 📢 注意：
 * 想使用`AppStorage`存储自定义的类型，该类型要遵守`RawRepresentable`且`RawValue`要为`String`（或`Int`）；
 * 而想其`rawValue`为`String`，就得使用`JSONEncoder`进行编码（和`JSONDecoder`进行解码），因此还得遵守`Codable`；
 * 由于`JSONEncoder`进行编码时会调用`RawRepresentable`默认实现的`encode`方法，里面访问了`rawValue`，会造成【死循环】，
 * 所以要重新实现`Encodable`的`encode`方法（覆盖掉`RawRepresentable`的默认实现），并且确保里面不会访问`rawValue`。
 */

struct MyPerson {
    var name: String
    var age: Int
}

extension MyPerson: Codable {
    enum CodingKeys: String, CodingKey {
        case name, age
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        age = try c.decode(Int.self, forKey: .age)
    }
    
    /// 如果遵守了`RawRepresentable`，那么`rawValue`的默认实现会调用`encode`，
    /// 同时`encode`的默认实现则会调用`rawValue`，因此会造成【死循环】！！
    /// 所以要不重写`rawValue`内部不执行`encode`，要不重写`encode`内部不执行`rawValue`。
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(age, forKey: .age)
    }
}

extension MyPerson: RawRepresentable {
    var rawValue: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
    
    init?(rawValue: String) {
        let data = rawValue.data(using: .utf8)!
        self = try! JSONDecoder().decode(Self.self, from: data)
    }
}

struct JSONTestView_Previews: PreviewProvider {
    static var previews: some View {
        JSONTestView()
    }
}
