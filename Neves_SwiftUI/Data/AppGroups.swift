//
//  AppGroups.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/9.
//

enum AppGroups {
    static let identifier: String = "group.com.zhoujianping.Neves"
}

extension AppGroups {
    static var directoryPath: String {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroups.identifier)!.path
    }
    
    static func getFilePath(_ fileName: String) -> String {
        guard !fileName.isEmpty else { return "" }
        return directoryPath + "/" + fileName
    }
}

extension AppGroups {
    @propertyWrapper
    struct UserDefault<T> {
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
}
