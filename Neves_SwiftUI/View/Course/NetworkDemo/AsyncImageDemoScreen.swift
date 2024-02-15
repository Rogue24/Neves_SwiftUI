//
//  AsyncImageDemoScreen.swift
//  Neves_SwiftUI
//
//  Created by aa on 2024/2/14.
//

import SwiftUI

extension URLSession {
    static let imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = .imageCache
        return URLSession(configuration: config)
    }()
}

/**
 * `URLCache`不会缓存【大于预设容量5%】的数据：
 * The response size is small enough to reasonably fit within the cache. (For example, if you provide a disk cache, the response must be no larger than about 5% of the disk cache size.)
 * 响应大小足够小，可以合理地放入缓存中。（例如，如果你提供了一个磁盘缓存，则响应大小不能超过磁盘缓存大小的大约5%。）
 * 文档：https://developer.apple.com/documentation/foundation/urlsessiondatadelegate/1411612-urlsession
 */
extension URLCache {
    static let imageCache = URLCache(
        memoryCapacity: 20 * 1024 * 1024, // 内存 20 MB
        diskCapacity: 30 * 1024 * 1024 // 磁盘 30 MB
    )
}

struct JPAsyncImage: View {
    @State private var phase: AsyncImagePhase = .empty
    let url: URL
    var session = URLSession.imageSession
    
    var body: some View {
        switch phase {
        case .empty:
            ProgressView()
                .scaleEffect(3)
                .task { await load() }
        case .success(let image):
            image
                .resizable()
                .scaledToFit()
        case .failure(let error):
            Text(error.localizedDescription)
        @unknown default:
            Text("啊？")
        }
    }
    
    func load() async {
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode,
                  let uiImage = UIImage(data: data)
            else {
                throw URLError(.unknown)
            }
            
            phase = .success(Image(uiImage: uiImage))
            
        } catch {
            phase = .failure(error)
        }
    }
}

struct AsyncImageDemoScreen: View {
    @State private var id = UUID()
//    let url = LoremPicsum.photoURLwithRandomId(size: [500, 500])
    let url = URL(string: "https://i0.hdslb.com/bfs/static/jinkela/long/images/512.png")!
    
    var body: some View {
        VStack {
            titleView
            
            // 方式一：
//            AsyncImage(url: url) { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//            } placeholder: {
//                ProgressView()
//                    .scaleEffect(3)
//            }

            // 方式二：
//            AsyncImage(url: url) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                        .scaleEffect(3)
//                case .success(let image):
//                    image
//                        .resizable()
//                        .scaledToFit()
//                case .failure(let error):
//                    Text(error.localizedDescription)
//                @unknown default:
//                    Text("啊？")
//                }
//            }.id(id)
            
            JPAsyncImage(url: url).id(id)
            
            Button("重置") {
                id = UUID()
            }
        }
    }
}

extension AsyncImageDemoScreen {
    var titleView: some View {
        Text("AsyncImage Demo")
            .font(.largeTitle.bold())
    }
}

#Preview {
    AsyncImageDemoScreen()
}
