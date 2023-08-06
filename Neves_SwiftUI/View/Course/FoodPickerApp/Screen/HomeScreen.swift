//
//  HomeScreen.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/8/6.
//

import SwiftUI

struct HomeScreen: View {
    @State var tab: Tab = .settings
    
    var body: some View {
        TabView(selection: $tab) {
            ForEach(Tab.allCases, id: \.self) { $0 }
        }
    }
}

extension HomeScreen {
    enum Tab: View, CaseIterable {
        case picker
        case list
        case settings
        
        var body: some View {
            content.tabItem {
                tabLabel
                    .labelStyle(.iconOnly)
            }
        }
        
        @ViewBuilder
        private var content: some View {
            switch self {
            case .picker: FoodPickerScreen()
            case .list: FoodListScreen(isInTab: true)
            case .settings: SettingsScreen()
            }
        }
        
        private var tabLabel: some View {
            switch self {
            case .picker:
                return Label("Home", sfs: .houseFill)
            case .list:
                return Label("List", sfs: .listBullet)
            case .settings:
                return Label("Settings", sfs: .gearShape)
            }
        }
    }
}
