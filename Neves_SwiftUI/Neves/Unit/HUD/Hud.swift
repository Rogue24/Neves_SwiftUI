//
//  Hud.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/2/6.
//

import SwiftUI

class Hud: ObservableObject {
    static var imageViewSize: CGSize = [100, 100]
    static var successImage: String = "checkmark.circle"
    static var warningImage: String = "exclamationmark.circle"
    static var errorImage: String = "xmark.circle"
    
    @Published var visible = false
    var config = TTProgressHUDConfig(type: .success,
                                     title: "(*´▽｀)ノノ",
                                     blurEffectStyle: .systemThinMaterial,
                                     foregroundColor: Color(.systemBackground).opacity(0.1),
                                     imageViewSize: .zero,
                                     shouldAutoHide: true,
                                     allowsTapToHide: false,
                                     autoHideInterval: 1,
                                     hapticsEnabled: false)
    
    func loading(_ title: String, isAllowsHitTesting: Bool = false) {
        Asyncs.main {
            self.config.type = .loading
            self.config.title = title
            // 设置背景为了让背景也能交互（手势能响应），同时希望这个背景是透明的
            // 如果设置为0，就无法交互（系统定义为隐藏），而设置为0.001，就能看不到，但实则存在，并且具有交互性
            // 也就是说，完全透明（opacity <= 0）的widget或区域，是无法交互的（手势无法响应）
            self.config.backgroundColor = isAllowsHitTesting ? Color.clear : Color.black.opacity(0.000000001)
            self.config.imageViewSize = Self.imageViewSize
            self.config.shouldAutoHide = false
            self.visible = true
        }
    }
    
    func success(_ title: String) {
        Asyncs.main {
            self.config.type = .success
            self.config.title = title
            self.config.backgroundColor = .clear
            self.config.imageViewSize = Self.imageViewSize
            self.config.shouldAutoHide = true
            self.visible = true
        }
    }
    
    func warning(_ title: String) {
        Asyncs.main {
            self.config.type = .warning
            self.config.title = title
            self.config.backgroundColor = .clear
            self.config.imageViewSize = Self.imageViewSize
            self.config.shouldAutoHide = true
            self.visible = true
        }
    }
    
    func error(_ title: String) {
        Asyncs.main {
            self.config.type = .error
            self.config.title = title
            self.config.backgroundColor = .clear
            self.config.imageViewSize = Self.imageViewSize
            self.config.shouldAutoHide = true
            self.visible = true
        }
    }
    
    func info(_ title: String) {
        Asyncs.main {
            self.config.title = title
            self.config.backgroundColor = .clear
            self.config.imageViewSize = .zero
            self.config.shouldAutoHide = true
            self.visible = true
        }
    }
    
    func hide() {
        Asyncs.main {
            self.visible = false
        }
    }
}
