//
//  GifImageView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/9.
//

import SwiftUI

@available(iOS 15.0.0, *)
struct GifImageView: View {
    
    @State var gifResult: UIImage.GifResult? = nil
    
    @State var color: UIColor = .red
    @State var index: Int = 0
    
    var body: some View {
        VStack {
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
            
            GifImage(gifResult: gifResult, isAnimating: .constant(true))
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
//            AsyncImage(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Cat", ofType: "gif")!), transaction: Transaction(animation: .easeOut)) { phase in
//                switch phase {
//                // 请求中
//                case .empty:
//                    ProgressView()
//                // 请求成功
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                // 请求失败
//                case .failure:
//                    Color.gray
//                // 其他未知情况
//                @unknown default:
//                    EmptyView() // 此视图无论设置什么都是空白的。
//                }
//            }
            
            Text("????")
                .font(.title)
                .foregroundColor(.primary)
            
            TestUIView(color: color, index: index)
                .frame(width: 200, height: 200)
            
            Button {
                index += 1
                color = .randomColor
            } label: {
                Text("\(index)")
                    .frame(width: 100, height: 50)
                    .background(.yellow)
            }

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
struct GifImageView_Previews: PreviewProvider {
    static var previews: some View {
        GifImageView()
    }
}
