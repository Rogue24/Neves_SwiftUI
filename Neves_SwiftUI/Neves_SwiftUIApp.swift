//
//  Neves_SwiftUIApp.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/9/25.
//

import SwiftUI
import FunnyButton_SwiftUI

@main
struct Neves_SwiftUIApp: App {
    @StateObject var funny = Funny()
    
    @State var hudVisible = false
    @State var hudConfig = TTProgressHUDConfig(type: .success, shouldAutoHide: true, allowsTapToHide: false, autoHideInterval: 1, hapticsEnabled: false)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(funny)
                .overlay(FunnyView())
                .overlay(TTProgressHUD($hudVisible, config: hudConfig))
                .onOpenURL { url in
                    hudConfig.title = url.absoluteString
                    hudVisible.toggle()
                }
        }
    }
}
