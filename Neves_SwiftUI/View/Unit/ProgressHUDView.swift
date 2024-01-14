//
//  ProgressHUDView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2022/1/26.
//

import SwiftUI
import FunnyButton_SwiftUI

struct ProgressHUDView: View {
    @EnvironmentObject var hud: Hud
    
    var body: some View {
        Text("Hello, World!")
            .funnyAction {
                if hud.visible {
                    hud.hide()
                    return
                }
                let v = Int.random(in: 0...4)
                switch v {
                case 0:
                    hud.loading("loading")
                case 1:
                    hud.success("success")
                case 2:
                    hud.warning("warning")
                case 3:
                    hud.error("error")
                default:
                    hud.info("Hello, World!")
                }
            }
    }
}

struct ProgressHUDView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressHUDView()
    }
}
