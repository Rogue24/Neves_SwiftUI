//
//  NevesWidgetStore.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/9.
//

class NevesWidgetStore: ObservableObject {
    static var directoryPath: String { AppGroups.getFilePath("NevesWidget") }
    
    static var modelFileName = "widget_model"
    static var modelCachePath: String { directoryPath + "/" + modelFileName }
    static var modelCacheURL: URL {
        if #available(iOS 16.0, *) {
            return URL(filePath: modelCachePath)
        } else {
            return URL(fileURLWithPath: modelCachePath)
        }
    }
    
    static var imageFileName = "widget_image"
    static var imageCachePath: String { directoryPath + "/" + imageFileName }
    static var imageCacheURL: URL {
        if #available(iOS 16.0, *) {
            return URL(filePath: imageCachePath)
        } else {
            return URL(fileURLWithPath: imageCachePath)
        }
    }
    
    @Published var model: NevesWidgetModel {
        didSet {
            guard let data = model.encode() else { return }
            try? data.write(to: NevesWidgetStore.modelCacheURL)
        }
    }
    
    var content: String {
        set {
            var model = self.model
            guard model.content != newValue else { return }
            model.content = newValue
            self.model = model
        }
        get { model.content }
    }
    
    var imageFilePath: String {
        set {
            var model = self.model
            guard model.imageFilePath != newValue else { return }
            model.imageFilePath = newValue
            self.model = model
        }
        get { model.imageFilePath }
    }
    
    var image: UIImage? { model.image }
    
    init() {
        print("NevesWidgetStore 被创建了")
        
        let directoryPath = NevesWidgetStore.directoryPath
        if !FileManager.default.fileExists(atPath: directoryPath) {
            try? FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        if let data = try? Data(contentsOf: NevesWidgetStore.modelCacheURL),
           let model = NevesWidgetModel.decode(data) {
            self.model = model
        } else {
            self.model = NevesWidgetModel(content: "😢", imageFilePath: "")
        }
    }
}

extension NevesWidgetStore {
    
}
