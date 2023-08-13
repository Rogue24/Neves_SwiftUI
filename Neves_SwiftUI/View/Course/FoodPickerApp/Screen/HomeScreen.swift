//
//  HomeScreen.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/8/6.
//

import SwiftUI

struct HomeScreen: View {
    @AppStorage(.isUseDarkMode) private var isUseDarkMode = false
    @State var tab: Tab = {
        // 从`UserDefaults`中获取启动tab：
        // 方式1：
//        guard let tabName = UserDefaults.standard.string(forKey: UserDefaults.Key.startTab.rawValue),
//              let tab = Tab(rawValue: tabName) else { return .picker }
        // 方式2：
        @AppStorage(.startTab) var tab = HomeScreen.Tab.picker
        return tab
    }()
    
    var body: some View {
        TabView(selection: $tab) {
            ForEach(Tab.allCases, id: \.self) { $0 }
        }
        /// 使用`environment`修改颜色模式，只会影响当前这棵树的View，
        /// 而`sheet`出来的（也就是`present`出来的）不是同一棵树之下，所以颜色模式无法共用。
//        .environment(\.colorScheme, isUseDarkMode ? .dark : .light)
        /// 使用`preferredColorScheme`就可以修改【当前`View`离得最近】的`presentation`之下的所有`View`的颜色模式（会不断往上传递，直到找到最近的`presentation`），
        /// `presentation`就是第一个使用`present`的根`View`，这样就能影响【当前这棵树】跟【`present`出来的另一棵树】的所有`View`了。
        .preferredColorScheme(isUseDarkMode ? .dark : .light)
        /// 📢：但是当前【`TabView`的这棵树】和【`present`出来的另一棵树】不是同一个`presentation`之下，使用`preferredColorScheme`也无济于事，
        /// 解决方法：将`TabView`包裹在`NavigationStack`之下，这样【`TabView`的这棵树】和【`present`出来的另一棵树】都隶属于【`NavigationStack`这个`presentation`】之下，从而实现修改全部`View`的颜色模式。
        /// PS：这里`HomeScreen`已经是在`NavigationStack`之下了（外面用的），无须再包裹一层。
    }
}

extension HomeScreen {
    enum Tab: String, View, CaseIterable {
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
