//
//  CatImageView.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatImageView: View {
    @State private var phase: AsyncImagePhase
    @State private var isLoading: Bool = false
    private var session: URLSession = .cat_imageSession
    
    private let catImage: CatImageViewModel
    private let isFavourited: Bool
    private var onDoubleTap: () async -> Void
    
    init(_ catImage: CatImageViewModel, isFavourited: Bool, session: URLSession = .cat_imageSession, onDoubleTap: @escaping () async -> Void) {
        self.session  = session
        self.catImage = catImage
        self.isFavourited = isFavourited
        self.onDoubleTap = onDoubleTap
        
        let urlRequest = URLRequest(url: catImage.url)
        if let data = session.configuration.urlCache?.cachedResponse(for: urlRequest)?.data,
           let uiImage = UIImage(data: data) {
            _phase = .init(wrappedValue: .success(.init(uiImage: uiImage)))
        } else {
            _phase = .init(wrappedValue: .empty)
        }
    }
    
    private var imageHeight: CGFloat? {
        guard let width = catImage.width, let height = catImage.height else {
            return nil
        }
        let scale = UIScreen.main.bounds.maxX / width
        return height * scale
    }
    
    var body: some View {
        Group {
            switch phase {
                case .empty:
                    ProgressView()
                        .controlSize(.large)
                        .task { await load() }
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "heart.fill")
                                .scaleEffect(isFavourited ? 1 : 0.0001)
                                .font(.largeTitle)
                                .padding()
                                .foregroundStyle(.pink)
                        }
                        .opacity(isLoading ? 0.1 : 1)
                        // PS_1: `animation`设置`value`代表用到这个`value`的地方才会引用该动画（不跟随其他动画）
                        .animation(.default, value: isLoading)
                        // PS_2: 但仅限于【在此之上】的地方，也就是说【不包括】下面这个`if isLoading { ... }`，ta不受这个`animation`的影响，而是跟随这个View最底下设置的那个`animation`影响
                        .overlay(alignment: .topTrailing) {
                            if isLoading {
                                ProgressView()
                                    .controlSize(.large)
                                    .padding()
                            }
                        }
                        .onTapGesture(count: 2) {
                            Task {
                                isLoading = true
                                await onDoubleTap()
                                isLoading = false
                            }
                        }
                        .disabled(isLoading) // 加载中不可交互
                    
                case .failure:
                    Color(.systemGray6)
                        .overlay {
                            // TODO: retry button
                            Text("图片无法显示")
                        }
                    
                @unknown default:
                    fatalError("This has not been implemented.")
            }
        }
        .animation(.interactiveSpring(), value: isFavourited)
        .frame(maxWidth: .infinity, minHeight: 200)
        .frame(height: imageHeight)
    }
}


private extension CatImageView {
    func load() async {
        do {
            let urlRequest = URLRequest(url: catImage.url)
            let data = try await session.jp_data(for: urlRequest)
            
            guard let uiImage = UIImage(data: data) else {
                throw URLSession.APIError.invalidData
            }
            
            phase = .success(Image(uiImage: uiImage))
        } catch {
            phase = .failure(error)
        }
    }
}


struct CatImageView_Previews: PreviewProvider, View {
    @State private var isFavourited: Bool = false
    
    var body: some View {
        CatImageView([CatImageViewModel].stub.first!, isFavourited: isFavourited) {
            isFavourited.toggle()
        }
    }
    
    static var previews: some View {
        Self()
    }
}
