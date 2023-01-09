//
//  AsyncGifImageView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/9.
//

import SwiftUI

@available(iOS 15.0.0, *)
struct AsyncGifImageView: View {
    var url: URL? {
//            URL(fileURLWithPath: Bundle.main.path(forResource: "Cat", ofType: "gif")!)
        URL(string: "https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ff6f34b91b5046c292092205bfc0aaea~tplv-k3u1fbpfcp-watermark.image?")
    }
    
    var body: some View {
//        AsyncGifImage(url: url, isReLoad: .constant(false), isAnimating: .constant(true)) { phase in
//            switch phase {
//            // 请求中
//            case .empty:
//                ProgressView()
//            // 请求成功
//            case .success(let image):
//                image.aspectRatio(contentMode: .fit)
//            // 请求失败
//            case .failure:
//                Text("Failure")
//            }
//        }
        
        VStack {
            GifImage(gifResult: nil, isAnimating: .constant(true))
                .frame(width: 200, height: 200)
                .background(.pink)
                .zIndex(1)
            
//            Image("")
//                .resizable()
            
            
            AsyncGifImage(url: url,
                          transaction: Transaction(animation: .easeOut),
                          isReLoad: .constant(false), isAnimating: .constant(true)) { phase in
                Group {
                    switch phase {
                    // 请求中
                    case .empty:
                        ProgressView()
                    // 请求成功
                    case .success(let image):
                        image
                            .aspectRatio(contentMode: .fit)
//                                .frame(maxWidth: .infinity)
                            .frame(width: 300, height: 300)
                            .background(.green)
                    // 请求失败
                    case .failure:
                        Text("Failure")
                    }
                }
                .background(.red)
            }
        }
    }
}

@available(iOS 15.0.0, *)
struct AsyncGifImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncGifImageView()
    }
}
