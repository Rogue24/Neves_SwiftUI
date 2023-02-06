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
    @StateObject var hud = Hud()
    @StateObject var funny = Funny()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(hud)
                .overlay(TTProgressHUD($hud.visible, config: hud.config))
                .environmentObject(funny)
                .overlay(FunnyView())
                .onOpenURL { url in
                    hud.info(url.absoluteString)
                }
        }
    }
}
