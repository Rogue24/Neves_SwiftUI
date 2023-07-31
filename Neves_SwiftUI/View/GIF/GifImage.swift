//
//  GifImage.swift
//  Neves_SwiftUI
//
//  Created by aa on 2022/7/11.
//

import SwiftUI
import UIKit

struct GifImage: UIViewRepresentable {
    var gifResult: UIImage.GifResult?
    @State var abc: Bool = false
    @Binding var isAnimating: Bool

    func makeUIView(context: Context) -> UIView {
        let uiView = UIView()
        uiView.clipsToBounds = true
        uiView.backgroundColor = .randomColor
        
        let imgView = UIImageView()
        imgView.tag = 33
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(imgView)
        
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            imgView.heightAnchor.constraint(equalTo: uiView.heightAnchor),
        ])

        JPrint("新建了？！")
        return uiView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        JPrint("更新了？！", abc, isAnimating)
        
        // Modifying state during view update, this will cause undefined behavior.
//        abc = isAnimating
        /**
         * 在`SwiftUI`中，当你尝试在视图更新期间修改状态时，你可能会遇到`"Modifying state during view update, this will cause undefined behavior."`的警告或错误。
         * 这个问题通常是由于在视图的生命周期方法（例如`body`或`onAppear`）中对状态进行了修改，从而导致了不确定的行为。
         *
         * 这个问题的根本原因是在【视图更新期间】修改状态，会导致视图无限循环更新，因为每次状态发生变化时，`SwiftUI` 会尝试重新绘制视图，然后再次触发状态的修改，这会导致一个无限循环的过程。
         *
         * 说人话就是：
         * 因为修改状态就会更新视图，如果更新视图的途中又修改状态，这样就会导致：更新视图->修改状态->更新视图->修改状态... 死循环！
         *
         * 解决方法：使用`DispatchQueue.main.async`
         * 将状态修改操作放在`DispatchQueue.main.async`块中，以确保它在【下一个`RunLoop` 】中执行。
         * 这样可以避免在视图更新期间进行状态修改，从而解决循环更新的问题。
         *
         * 参考：
         * https://www.jianshu.com/p/7abc825693fd
         * https://swiftui-lab.com/state-changes/
         */
        DispatchQueue.main.async {
            abc = isAnimating
        }
        
        guard let imgView = uiView.viewWithTag(33) as? UIImageView else { return }
        guard let gifResult = self.gifResult else {
            isAnimating = false
            imgView.stopAnimating()
            imgView.animationImages = nil
            imgView.animationDuration = 0
            return
        }
        
        imgView.animationImages = gifResult.images
        imgView.animationDuration = gifResult.duration
        if isAnimating {
            imgView.startAnimating()
        } else {
            imgView.stopAnimating()
        }
    }
}

//struct GifImage: UIViewRepresentable {
//    @Binding var gifResult: UIImage.GifResult?
//    @Binding var isAnimating: Bool
//
//
//
//    func makeUIView(context: Context) -> UIView {
//
//        let uiView = UIView()
//        uiView.backgroundColor = .systemBlue
////        uiView.translatesAutoresizingMaskIntoConstraints = false
//
//        let imgView = UIImageView()
//        imgView.tag = 33
//        imgView.contentMode = .scaleAspectFit
//        imgView.translatesAutoresizingMaskIntoConstraints = false
//        uiView.addSubview(imgView)
//        NSLayoutConstraint.activate([
//            imgView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
//            imgView.heightAnchor.constraint(equalTo: uiView.heightAnchor),
//        ])
//
//        let view = UIView(frame: .zero)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .randomColor(0.5)
//
//        uiView.addSubview(view)
//        NSLayoutConstraint.activate([
//            view.widthAnchor.constraint(equalTo: uiView.widthAnchor),
//            view.heightAnchor.constraint(equalTo: uiView.heightAnchor),
//        ])
//
//        return uiView
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        guard let imgView = uiView.viewWithTag(33) as? UIImageView else { return }
//
//        guard let gifResult = self.gifResult else {
//            isAnimating = false
//            imgView.stopAnimating()
//            imgView.animationImages = nil
//            imgView.animationDuration = 0
//            return
//        }
//
//        imgView.animationImages = gifResult.images
//        imgView.animationDuration = gifResult.duration
//        if isAnimating {
//            imgView.startAnimating()
//        } else {
//            imgView.stopAnimating()
//        }
//
//        uiView.layoutIfNeeded()
//        JPrint(uiView.frame)
//        JPrint(PortraitScreenBounds)
//    }
//}


enum AsyncGifImagePhase {
    /// No image is loaded.
    case empty

    /// An image succesfully loaded.
    case success(GifImage)

    /// An image failed to load with an error.
    case failure
}

@available(iOS 15.0.0, *)
struct AsyncGifImage<Content>: View where Content : View {
    let url: URL?
    let transaction: Transaction
    @Binding var isReLoad: Bool
    @Binding var isAnimating: Bool
    @ViewBuilder var content: (AsyncGifImagePhase) -> Content
    
//    convenience init(url: URL?,
//                     transaction: Transaction = Transaction(),
//                     @Binding isReLoad: Bool,
//                     @Binding isAnimating: Bool,
//                     @ViewBuilder content: @escaping (AsyncGifImagePhase) -> Content) {
////        self.init(url: url,
////                  transaction: transaction,
////                  isReLoad: isReLoad,
////                  isAnimating: isAnimating,
////                  content: content)
////        self.url = url
////        self.transaction = transaction
////        self.isReLoad = isReLoad
////        self.isAnimating = isAnimating
////        self.content = content
//        self.init(url: url, transaction: transaction, isReLoad: isReLoad, isAnimating: isAnimating, content: content)
//    }
    
//    public convenience init(url: URL?,
//                     transaction: Transaction = Transaction(),
//                     @Binding isReLoad: Bool,
//                     @Binding isAnimating: Bool,
//                     @ViewBuilder content: @escaping (AsyncGifImagePhase) -> Content) {
//        self.init(url: url,
//                  transaction: transaction,
//                  isReLoad: isReLoad,
//                  isAnimating: isAnimating,
//                  content: content)
//    }
    
//    public convenience init(url: URL?,
//                     transaction: Transaction = Transaction(),
//                     @ViewBuilder content: @escaping (AsyncGifImagePhase) -> Content) {
//        self.init(url: url,
//                  transaction: transaction,
//                  isReLoad: .constant(false),
//                  isAnimating: .constant(true),
//                  content: content)
//    }
    
    @State var gifResult: UIImage.GifResult? = nil
    @State var phase: AsyncGifImagePhase = .empty
    @State var isLoading = false
    
    var body: some View {
        content(phase)
            .task {
//                switch phase {
//                    case .success: return
//                    default: break
//                }
//                do {
//                    try await Task.sleep(nanoseconds: 1000000000)
//                } catch {
//
//                }
                print("??!!!")
                await reloadGif()
            }
            .onChange(of: isReLoad) { newValue in
                if newValue {
                    Task {
                        await reloadGif()
                    }
                }
            }
    }
    
    func reloadGif() async {
        guard !isLoading else { return }
        isLoading = true
        
        defer {
            isLoading = false
            isReLoad = false
        }
        
        guard let url = self.url else {
            updatePhase(.failure)
            return
        }
        
        updatePhase(.empty)
        
        if url.isFileURL {
            await reloadGifFromLocal(url)
        } else {
            await reloadGifFromRemote(url)
        }
    }
    
    func reloadGifFromRemote(_ url: URL) async {
        do {
            let data = try await URLSession.shared.data(from: url).0
            gifResult = await UIImage.decodeGIF(data)
            updateGifResult()
        } catch {
            updatePhase(.failure)
        }
    }
    
    func reloadGifFromLocal(_ url: URL) async {
        gifResult = await UIImage.decodeLocalGIF(url)
        updateGifResult()
    }
    
    func updatePhase(_ p: AsyncGifImagePhase) {
        withTransaction(transaction) {
            phase = p
        }
    }
    
    func updateGifResult() {
        if let result = gifResult, result.images.count > 0 {
            updatePhase(.success(GifImage(gifResult: gifResult, isAnimating: $isAnimating)))
        } else {
            gifResult = nil
            updatePhase(.failure)
        }
    }
    
}


@available(iOS 15.0.0, *)
struct AsyncGifImage_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
//        AsyncGifImage(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Cat", ofType: "gif")!), isReLoad: .constant(false), isAnimating: .constant(true)) { phase in
//            Group {
//                switch phase {
//                // 请求中
//                case .empty:
//                    ProgressView()
//                // 请求成功
//                case .success(let image):
//                    image
//                // 请求失败
//                case .failure:
//                    Text("Failure")
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .aspectRatio(contentMode: .fit)
//            .background(.yellow)
//        }
    }
}
