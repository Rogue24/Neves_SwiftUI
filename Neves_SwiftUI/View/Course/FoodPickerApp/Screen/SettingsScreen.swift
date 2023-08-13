//
//  SettingsScreen.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/8/6.
//

import SwiftUI

struct SettingsScreen: View {
    @AppStorage(.isUseDarkMode) private var isUseDarkMode = false
    @AppStorage(.unit) private var unit: Unit = .gram
    @AppStorage(.startTab) private var startTab: HomeScreen.Tab = .picker
    @State private var confirmDialog: Dialog = .inactive
    
    private var isShowDialog: Binding<Bool> {
        Binding(
            get: { confirmDialog != .inactive },
            set: { _ in
                confirmDialog = .inactive
            }
        )
    }
    
    var body: some View {
        Form {
            Section("基本设置") {
                Toggle(isOn: $isUseDarkMode) {
                    Label("深色模式", sfs: .moonFill)
                }
                
                Picker(selection: $unit) {
                    ForEach(Unit.allCases, id: \.self) { $0 }
                } label: {
                    Label("单位", sfs: .numbersign)
                }
                
                Picker(selection: $startTab) {
                    Text("随机食物")
                        .tag(HomeScreen.Tab.picker)
                    Text("食物清单")
                        .tag(HomeScreen.Tab.list)
                } label: {
                    Label("启动页面", sfs: .houseFill)
                }
            }
            
            Section("其他设置") {
                ForEach(Dialog.allCases) { dialog in
                    Button(dialog.rawValue) {
                        confirmDialog = dialog
                    }
                    .tint(Color(.label))
                }
            }
            .confirmationDialog(confirmDialog.rawValue, isPresented: isShowDialog, titleVisibility: .visible) {
                Button("确定", role: .destructive, action: confirmDialog.action)
                Button("取消", role: .cancel) {}
            } message: {
                Text(confirmDialog.message)
            }
        }
    }
}

private enum Dialog: String {
    case resetSettings = "重置设定"
    case resetFoodList = "重置食物清单"
    case inactive
    
    var message: String {
        switch self {
        case .resetSettings:
            return "将重置颜色、单位等设置，\n此操作将无法复原，是否确定？"
        case .resetFoodList:
            return "将重置食物清单，\n此操作将无法复原，是否确定？"
        default:
            return ""
        }
    }
    
    func action() {
        switch self {
        case .resetSettings:
            UserDefaults.Key.allCases.forEach {
                UserDefaults.standard.removeObject(forKey: $0.rawValue)
            }
            
        case .resetFoodList:
            break
            
        default:
            break
        }
    }
}

extension Dialog: CaseIterable {
    static var allCases: [Self] { [.resetSettings, .resetFoodList] }
}

extension Dialog: Identifiable {
    var id: Self { self }
}
