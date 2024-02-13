//
//  ImagePickerShowView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/12.
//

import SwiftUI

struct ImagePickerShowView: View {
    @State var photo: UIImage? = nil
    @State var show: Bool = false
    
    var body: some View {
        Button {
            show = true
        } label: {
            VStack(spacing: 12) {
                Group {
                    if let photo {
                        Image(uiImage: photo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        SFSymbol.photoArtframe
                            .font(.system(size: 30))
                            .foregroundColor(.randomColor)
                    }
                }
                .frame(width: 150, height: 150)
                .background(Color.randomColor)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(radius: 10)
                
                Text("点击打开相册")
            }
        }
        // 全屏用`.fullScreenCover(...)`
        .sheet(isPresented: $show) {
            ImagePickerView(selectedImage: $photo)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ImagePickerShowView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerShowView()
    }
}
