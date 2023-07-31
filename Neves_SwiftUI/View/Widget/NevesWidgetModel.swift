//
//  NevesWidgetModel.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/10.
//

struct NevesWidgetModel: Codable, Identifiable {
    var id = UUID()
    var content: String
    var imageFilePath: String
    var image: UIImage? { UIImage(contentsOfFile: imageFilePath) }
    
    enum CodingKeys: String, CodingKey {
        case content, imageFilePath
    }
    
    init(content: String, imageFilePath: String) {
        self.content = content
        self.imageFilePath = imageFilePath
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        content = try c.decode(String.self, forKey: .content)
        imageFilePath = try c.decode(String.self, forKey: .imageFilePath)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(content, forKey: .content)
        try c.encode(imageFilePath, forKey: .imageFilePath)
    }
}

extension NevesWidgetModel {
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
    static func decode(_ data: Data?) -> NevesWidgetModel? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(NevesWidgetModel.self, from: data)
    }
}
