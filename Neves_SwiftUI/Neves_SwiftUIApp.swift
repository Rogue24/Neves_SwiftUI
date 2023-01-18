//
//  Neves_SwiftUIApp.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/9/25.
//

import SwiftUI

@main
struct Neves_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay(FunnyView())
        }
    }
}
