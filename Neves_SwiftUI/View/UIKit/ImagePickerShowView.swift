//
//  ImagePickerShowView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/12.
//

import SwiftUI

struct ImagePickerShowView: View {
    @State var show: Bool = false
    
    var body: some View {
        Button {
            show = true
        } label: {
            VStack(spacing: 8) {
                SFSymbol.photoArtframe
                Text("点击打开相册")
            }
        }
        // 全屏用`.fullScreenCover(...)`
        .sheet(isPresented: $show) {
            ImagePickerView(selectedImage: .constant(nil))
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ImagePickerShowView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerShowView()
    }
}
