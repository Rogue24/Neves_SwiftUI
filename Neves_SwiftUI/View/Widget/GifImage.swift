//
//  GifImage.swift
//  Neves_SwiftUI
//
//  Created by aa on 2022/7/11.
//

import SwiftUI
import UIKit

struct GifImage: UIViewRepresentable {
    @Binding var gifResult: UIImage.GifResult?
//    @Binding var isAnimating: Bool
    
    func makeUIView(context: Context) -> UIImageView {
        let imgView = UIImageView()
        imgView.backgroundColor = .systemBlue
        return imgView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        guard let gifResult = self.gifResult else {
            uiView.stopAnimating()
            uiView.animationImages = nil
            uiView.animationDuration = 0
            return
        }
        
        uiView.animationImages = gifResult.images
        uiView.animationDuration = gifResult.duration
        uiView.startAnimating()
    }
}
