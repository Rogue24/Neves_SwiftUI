//
//  AppGroups.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/9.
//

enum AppGroups {
    static let identifier: String = "group.com.zhoujianping.Neves"
    
    @propertyWrapper struct UserDefault<T> {
        let key: String
        
        var wrappedValue: T? {
            set {
                UserDefaults(suiteName: AppGroups.identifier)?.set(newValue, forKey: key)
                UserDefaults(suiteName: AppGroups.identifier)?.synchronize()
            }
            get {
                UserDefaults(suiteName: AppGroups.identifier)?.object(forKey: key) as? T
            }
        }
    }
    
    func getFilePath(_ fileName: String) -> String {
        guard fileName.count > 0 else { return "" }
        var filePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroups.identifier)!.path
        filePath += "/"
        filePath += fileName
        return filePath
    }
}
