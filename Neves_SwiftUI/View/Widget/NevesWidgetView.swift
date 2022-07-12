//
//  NevesWidgetView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2022/7/11.
//

import SwiftUI

@available(iOS 15.0.0, *)
struct NevesWidgetView: View {
    
    @State var gifResult: UIImage.GifResult? = nil
    
    
    
    var body: some View {
        ZStack {
//            Image(uiImage: UIImage.animatedImage(with: [iamge], duration: iamge.duration)!)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
            
//            if let image = UIImage.animatedImage(with: gifResult.images, duration: gifResult.duration) {
//
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//
//
//            }
            
//            GifImage(gifResult: $gifResult)
//                .aspectRatio(contentMode: .fit)
            
            AsyncImage(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Cat", ofType: "gif")!), transaction: Transaction(animation: .easeOut)) { phase in
                switch phase {
                // 请求中
                case .empty:
                    ProgressView()
                // 请求成功
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                // 请求失败
                case .failure:
                    Color.gray
                // 其他未知情况
                @unknown default:
                    EmptyView() // 此视图无论设置什么都是空白的。
                }
            }
            
            Text("????")
                .font(.title)
                .foregroundColor(.primary)
        }
        .task {
            do {
                try await Task.sleep(nanoseconds: 1000000000)
            } catch {
            
            }
            gifResult = await UIImage.decodeBundleGIF("Cat")
        }
            
    }
    
    
}

@available(iOS 15.0.0, *)
struct NevesWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NevesWidgetView()
    }
}
