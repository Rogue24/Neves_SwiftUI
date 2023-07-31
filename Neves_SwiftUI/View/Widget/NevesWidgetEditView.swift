//
//  NevesWidgetEditView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/9.
//

import SwiftUI
import WidgetKit

struct NevesWidgetEditView: View {
    @StateObject var store = NevesWidgetStore()
    @State var refresh: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Button("😈") { updateContent("😈") }
                Button("🤖") { updateContent("🤖") }
                Button("👽") { updateContent("👽") }
                Button("🐙") { updateContent("🐙") }
            }
            
            myText
            
            // MARK: 不同View之间的数据传值
            
            // 1.UserDefaults：
            // 徒增IO操作，而且需要维护一个专属于它自己的状态属性，否则不会刷新。
            //【不推荐】
            UserDefaultText(refresh: $refresh)
            
            // 2.ObservedObject：
            // 需要父View或自己本身的状态属性更新才会刷新数据，每次刷新都会重新创建ObservedObject，
            // 而且ObservedObject的生命周期不可控（系统不定时才销毁）。
            //【不推荐】
            ObservedText()
            
            // 3.EnvironmentObject：
            // 与父View共享同一个StateObject，不会造成额外的构造消耗。
            //【推荐】
            EnvironmentText()
            
            // MARK: 图片下载
            if #available(iOS 15.0, *) {
                ImageDownloader() {
                    reloadWidget()
                }
            } else {
                Text("需要iOS15+")
            }
        }
        .environmentObject(store) // 给这棵树的View共用，例如EnvironmentText
    }
    
    @ViewBuilder
    var myText: some View {
        Text("\\" + "\(store.content)/")
            .font(.largeTitle)
    }
    
    func updateContent(_ content: String) {
        store.content = content
        updateUserDefaultContent(content)
        refresh.toggle()
        reloadWidget()
    }
    
    func updateUserDefaultContent(_ content: String) {
        UserDefaults.standard.set(content, forKey: "NevesWidgetContent")
        UserDefaults.standard.synchronize()
    }
    
    func reloadWidget() {
        WidgetCenter.shared.getCurrentConfigurations { result in
            switch result {
            case let .success(infos):
                guard let info = infos.first(where: { $0.kind == "NevesWidget" }) else {
                    print("小组件更新失败: 找不到NevesWidget小组件")
                    return
                }
                print("小组件更新: \(info.kind)")
                WidgetCenter.shared.reloadTimelines(ofKind: info.kind)
                
            case let .failure(error):
                print("小组件更新失败: \(error)")
            }
        }
    }
}

struct NevesWidgetEditView_Previews: PreviewProvider {
    static var previews: some View {
        NevesWidgetEditView()
    }
}

private struct UserDefaultText: View {
    @Binding var refresh: Bool
    @UserDefault<String>("NevesWidgetContent") var content
    
    var body: some View {
        Text("+\(content ?? "😭")+")
            .font(.largeTitle)
    }
}

private struct ObservedText: View {
    @ObservedObject var store = NevesWidgetStore()
    
    var body: some View {
        Text("^\(store.content)^")
            .font(.largeTitle)
    }
}

private struct EnvironmentText: View {
    @EnvironmentObject var store: NevesWidgetStore
    
    var body: some View {
        Text("=\(store.content)=")
            .font(.largeTitle)
    }
}

@available(iOS 15.0.0, *)
private struct ImageDownloader: View {
    @EnvironmentObject var store: NevesWidgetStore
    
    var downloadDone: () -> Void
    
    enum LoadState {
        case idle
        case loading
        case success(_ image: UIImage, _ msg: String)
        case failure(_ msg: String)
        
        var text: String {
            switch self {
            case .idle:
                return "点击下载"
            case .loading:
                return "正在下载..."
            case let .success(_, msg):
                return msg
            case let .failure(msg):
                return msg
            }
        }
    }
    
    @State var loadState: LoadState = .idle
    
    var body: some View {
        VStack(spacing: 8) {
            Group {
                switch loadState {
                case .idle:
                    Color.blue
                case .loading:
                    Color.yellow
                case let .success(image, _):
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.red
                }
            }
            .frame(width: 200, height: 200)
            
            Text(loadState.text)
                .onTapGesture {
                    if case .loading = loadState { return }
                    loadImage()
                }
        }
        .onAppear {
            if let image = store.image {
                loadState = .success(image, "点击重新下载")
            } else {
                store.imageFilePath = ""
                loadState = .idle
            }
        }
    }
    
    func loadImage() {
        loadState = .loading
        Task {
            let url = LoremPicsum.photoURLwithRandomId(size: CGSize(width: 600, height: 600))
            if let (data, _) = try? await URLSession.shared.data(from: url), let image = UIImage(data: data) {
                do {
                    if FileManager.default.fileExists(atPath: NevesWidgetStore.imageCachePath) {
                        try FileManager.default.removeItem(atPath: NevesWidgetStore.imageCachePath)
                    }
                    try data.write(to: NevesWidgetStore.imageCacheURL)
                    store.imageFilePath = NevesWidgetStore.imageCachePath
                    loadState = .success(image, "下载成功，点击重新下载")
                    downloadDone()
                } catch {
                    print(error)
                    loadState = .failure("缓存失败，点击重新下载")
                }
            } else {
                loadState = .failure("下载失败，点击重新下载")
            }
        }
    }
}
