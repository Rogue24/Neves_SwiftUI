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
    @Binding var isAnimating: Bool

    func makeUIView(context: Context) -> UIView {

        let uiView = UIView()
        uiView.clipsToBounds = true
        
        let imgView = UIImageView()
        imgView.tag = 33
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(imgView)
        
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            imgView.heightAnchor.constraint(equalTo: uiView.heightAnchor),
        ])

        return uiView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
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
        
//        guard let gifResult = self.gifResult else {
//            isAnimating = false
//            uiView.stopAnimating()
//            uiView.animationImages = nil
//            uiView.animationDuration = 0
//            return
//        }
//
//        uiView.animationImages = gifResult.images
//        uiView.animationDuration = gifResult.duration
//        if isAnimating {
//            uiView.startAnimating()
//        } else {
//            uiView.stopAnimating()
//        }
        
        
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
            updatePhase(.success(GifImage(gifResult: $gifResult, isAnimating: $isAnimating)))
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
