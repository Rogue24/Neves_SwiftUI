//
//  ProgressHUDView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2022/1/26.
//

import SwiftUI

struct ProgressHUDView: View {
    
    @State var hudVisible = false
    @State var hudConfig = TTProgressHUDConfig(type: .success, shouldAutoHide: true, allowsTapToHide: false, autoHideInterval: 1, hapticsEnabled: false)
    
    var body: some View {
        ZStack {
            Text("Hello, World!")
                .onTapGesture {
                    hudVisible.toggle()
                }
            
            TTProgressHUD($hudVisible, config: hudConfig)
        }
        .background(Color.randomColor)
    }
}

struct ProgressHUDView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressHUDView()
    }
}
