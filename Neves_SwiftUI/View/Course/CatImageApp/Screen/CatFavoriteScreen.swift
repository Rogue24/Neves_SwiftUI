//
//  CatFavoriteScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatFavoriteScreen: View {
//    @Environment(\.catApiManager) var apiManager: CatAPIManager
    @EnvironmentObject private var apiManager: CatAPIManager
    // ⚠️`EnvironmentObject`的注意点：如果「上层或直至根层」都没有传递该值过来会直接【Crash】！！！
    
//    @State private var loadingState: CatFavoriteLoadingState = .old_notStarted // 旧实现
    @State private var loadingState: CatFavoriteLoadingState = .loading(page: 0)
    @State private var loadError: CatFriendlyError? = nil
    
    var body: some View {
        VStack {
            Text("我的最爱")
                .font(.largeTitle.bold())
            
            ScrollView {
                // 请求完发现没数据才显示提示文案
                if apiManager.favorites.isEmpty && loadingState == .success(nextPage: nil)  {
                    favoriteFeatureHintText
                }
                
                // 使用`LazyVStack`可以保证View在【看到】的时候才会被创建。
                // 这样就不会不断地去【自动】加载更多了（使用LazyVStack就可以滑到底部时才会去创建「成功状态的ProgressView」去加载更多）
                LazyVStack {
                    favoriteList
//                    old_footer // 旧实现
                    footer
                }
            }
        }
        .animation(.spring(), value: apiManager.favorites)
        .cat_alert(error: $loadError)
        // 旧实现
//        .task {
//            guard loadingState == .old_notStarted else { return }
//            await old_loadFavorites(page: 0)
//        }
    }
}

// MARK: - Subviews
private extension CatFavoriteScreen {
    var favoriteFeatureHintText: some View {
        Text("双击图片即可新增到最爱哟 😊")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x: apiManager.favorites.isEmpty ? 0 : -UIScreen.main.bounds.maxX)
            .font(.title3)
            .padding()
    }
    
    var favoriteList: some View {
        ForEach(apiManager.favorites, id: \.imageID) { favoriteItem in
            CatImageView(.init(favoriteItem: favoriteItem), isFavourited: true) {
                do {
                    try await apiManager.removeFromFavorite(id: favoriteItem.id)
                } catch {
                    loadError = .init(title: "无法从「我的最爱」中移除，请确认网络状态后再重试。", error: error)
                }
            }.transition(.slide)
        }
    }
    
    var footer: some View {
        Group {
            switch loadingState {
            case let .loading(page):
                ProgressView()
                    .controlSize(.large)
                    .onAppear {
                        loadFavorites(page: page)
                    }
                
            case let .success(nextPage?):
                //【自动】加载更多
                ProgressView()
                    .controlSize(.large)
                    .onAppear {
                        loadingState = .loading(page: nextPage)
                    }
                
            case let .fail(retryPage):
                buildRetryButton(retryPage)
                
            default:
                EmptyView()
            }
        }
        .frame(minHeight: 100)
    }
    
    func buildRetryButton(_ retryPage: Int) -> some View  {
        HStack {
            Text("「我的最爱」加载失败\n请确认网络状态后再重试。")
            Button("继续") {
                // 旧实现
//                Task {
//                    await old_loadFavorites(page: retryPage)
//                }
                
                loadingState = .loading(page: retryPage)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
        }
    }
}

// MARK: - Load Data
private extension CatFavoriteScreen {
    func loadFavorites(page: Int) {
        Task {
            loadingState = await apiManager.getFavoritesAndAppend(page: page, limit: 5)
        }
    }
}

// MARK: - 旧实现
private extension CatFavoriteScreen {
    var old_footer: some View {
        Group {
            switch loadingState {
            case .old_loading:
                ProgressView()
                    .controlSize(.large)
                
            case let .success(nextPage?):
                //【自动】加载更多
                ProgressView()
                    .controlSize(.large)
                    .task {
                        JPrint("正在去加载第\(nextPage)页的数据")
                        await old_loadFavorites(page: nextPage)
                    }
                
                //【手动】加载更多
//                Button("加载更多") {
//                    Task {
//                        JPrint("正在去加载第\(nextPage)页的数据")
//                        await old_loadFavorites(page: nextPage)
//                    }
//                }
                
            case let .fail(retryPage):
                buildRetryButton(retryPage)
                
            default:
                EmptyView()
            }
        }
        .frame(minHeight: 100)
    }
    
    func old_loadFavorites(page: Int) async {
        loadingState = .old_loading
        
        // ⚠️ 不能在这里接着给loadingState赋值
//        loadingState = await apiManager.getFavoritesAndAppend(page: page, limit: 5)
        // 这是因为如果该方法是从第`42`行执行过来的，则是包在一个`task`中执行的，
        // 而该方法第一句就是`loadingState = .loading`，导致原本的View直接被替换，顺带的`task`及其子任务立马被取消执行，由于此时网络正在请求中，因此请求则会被取消（失败）
        // 🔨 解决方法：
        // 把请求过程和回调丢到另一个独立的`task`中去，这样即便原本的`task`被取消了也不影响网络请求和回调：
        Task.detached { // ==> 使用`detached`创建的任务是独立的，不会继承创建它的任务的上下文（从原本的`task`中剥离出来，独立执行）。
            let resultState = await apiManager.getFavoritesAndAppend(page: page, limit: 5)
            // detached创建的任务的actor不继承当前的上下文，因此在里面修改loadingState需要手动切换回MainActor（View默认都是MainActor）
            await MainActor.run {
                loadingState = resultState
            }
        }
        /**
         * `Task.detached {}`和`Task {}`的区别
         * 来自**ChatGPT**的解释：
         *
         * 在 iOS 中，使用`Task {}`和`Task.detached {}`都可以创建异步任务，但它们在任务的执行上下文和继承性方面有所不同。
         * 以下是它们的主要区别：
         *
         * 1. 执行上下文和继承性:
         * `Task {}`:
         *  - 创建的任务【继承了】当前的任务上下文。这意味着它会继承当前任务的优先级和任务的局部值（如 TaskLocal 的值）。
         *  - 适合需要在当前上下文中执行的任务，尤其是当你希望任务继承当前任务的一些环境信息时。
         * `Task.detached {}`:
         *  - 创建的任务是独立的，【不会继承】创建它的任务的上下文。它具有自己的独立优先级和任务局部值。
         *  - 适合完全独立的任务，不依赖于当前任务的环境信息。
         *
         * 2. 使用场景:
         * `Task {}`:
         *  - 当你希望新任务与当前任务有某种关联时使用，比如需要继承一些环境信息或任务优先级。
         *  - 例如，在 UI 线程上启动后台任务，但希望保持某些上下文信息时使用。
         * `Task.detached {}`:
         *  - 当你希望新任务完全独立于当前任务时使用，比如处理一些完全独立的后台工作，不需要依赖当前上下文。
         *  - 例如，处理独立的后台数据处理或网络请求时使用。
         *
         * 3. 示例代码:
         *
                // 使用 Task {} 创建任务
                Task {
                    // 这段代码将在当前任务上下文中运行
                    await someAsyncFunction()
                }

                // 使用 Task.detached {} 创建独立任务
                Task.detached {
                    // 这段代码将在独立上下文中运行，不会继承当前任务的优先级或局部值
                    await someOtherAsyncFunction()
                }
         *
         * 总结：
         *  - 使用 `Task {}`创建的任务继承当前任务的上下文和优先级，适合需要保持某些上下文信息的任务。
         *  - 使用`Task.detached {}`创建的任务完全独立，适合需要独立执行的任务，不依赖当前上下文。
         * 根据具体需求选择合适的方式来创建和管理异步任务，有助于更好地控制任务的执行行为和性能。
         */
    }
}

struct CatFavoriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        CatFavoriteScreen()
//            .environment(\.catApiManager, .preview) // 使用自定义的环境变量
            .environmentObject(CatAPIManager.preview) // 改用environmentObject：能跟随属性的变化去更新视图
    }
}
