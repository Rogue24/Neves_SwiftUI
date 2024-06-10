//
//  CatAPIManager.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2024/3/4.
//
//  API文档：https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t

import SwiftUI

enum CatFavoriteLoadingState: Equatable {
    case old_notStarted
    case old_loading
    case loading(page: Int)
    case success(nextPage: Int?)
    case fail(retryPage: Int)
}

/// 由于`ObservableObject`中会有很多更新页面的事情，使用`@MainActor`标记该类可以确保其所有的方法和属性都在【主线程】上执行。
/// 但是可能会有一些长时间运行的任务需要在子线程执行，可以使用`nonisolated`修饰符来标记这样的方法（`fetch`网络请求和数据处理的方法），以允许它在非主线程上执行。
/// 参考：https://blog.csdn.net/mydo/article/details/132873988
@MainActor 
final class CatAPIManager: ObservableObject {
    
/// 想让视图能够观察`CatAPIManager`对象的`favorites`属性是否发生变化从而更新视图的做法：
/// 1. `CatAPIManager`遵守`ObservableObject`
/// 2. 在`favorites`的`willSet`中调用`objectWillChange.send()` / 使用`@Published`这个属性包装器
///
/// PS1：`objectWillChange`是`ObservableObject`的协议属性。
///
/// PS2：为什么要在`willSet`中调用，而不是在`didSet`中调用？
/// 这是因为要判断变化的时候，必须要有一个前后的状态来进行比较。
/// `willSet`则是在状态即将发生改变的时候触发，此时调用`objectWillChange.send()`，
/// 就能让【观察着这个属性的View（订阅者）】先去记录自己当前的页面状态（`willSet`），
/// 然后在下一个更新页面的时间点（`didSet`），把新的页面状态跟刚刚记录的状态拿来做比较，通过比较得知哪个地方需要去更新。
///
/// 为何在【`willSet`】中调用更加合理？
/// 来自**ChatGPT**的解释：
/// 问：`objectWillChange.send()`只能在`willSet`里面调用吗？能不能在`didSet中`调用？
/// 答：在 `didSet` 中调用 `objectWillChange.send()` 并不是一种常见的做法，因为在 `didSet` 中调用时，对象已经发生了更改，而 `objectWillChange.send()` 通常用于通知对象即将发生更改。这可能导致一些意外的行为，因为你正在发送一个即将发生的更改通知，而实际上更改已经发生了。
/// 通常情况下，最好在属性即将更改时使用 `willSet`，因为此时是最合适发送通知的时机。如果需要在更改后发送通知，可能会有其他设计上的选择。例如，你可以在 `didSet` 中处理其他的逻辑，然后在适当的时候手动调用某个方法来发送通知。
/// 但是，在某些特定的情况下，可能会存在在 `didSet` 中调用 `objectWillChange.send()` 的合理用例。但要确保在这种情况下，你明确地了解你的代码逻辑，以及它如何影响整个应用程序的行为。
///
/// PS3：使用`@Published`这个属性包装器，相当于帮我们实现了`willSet`中调用`objectWillChange.send()`，也就是在这个属性要发生更新的时候进行通知。
/// 不过这种是只要发生变化就会去通知，如果是处理一些比较复杂的变化，想要自己去决定更新的时机，那还是自己手动去调用`objectWillChange.send()`进行通知。
/// - 例如想在多个属性都发生改变并处理好之后才发出通知，避免每一个属性发生改变都要去更新一次，其实等到最后只更新一次即可。
///
    private var favorites2: [FavoriteItem] = [] { // ==> 这只是用来模拟`@Published var favorites: [FavoriteItem]`的内部实现
        willSet {
            // 既然这是去通知视图去更新页面，那就是必须要在【主线程】中处理
            
            // 丢到主线程中去通知：
//            Task { @MainActor in
//                objectWillChange.send()
//            }
            
            // 整个类已经用`@MainActor`修饰了，不需要手动丢进`Task`中执行了
            objectWillChange.send()
        }
    }
    /// ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    /// 使用`@Published`相当于帮我们实现了`willSet`中调用`objectWillChange.send()`。
    /// ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    @Published private(set) var favorites: [FavoriteItem] = []
    /// 不过这种只要发生变化就会去通知，如果想要自己去决定更新的时机，那还是自己手动去调用`objectWillChange.send()`进行通知。
    
    /// 提供`URLRequest`以决定如何获取`Data`的闭包
    /// - Note: 有默认处理，并且提供外部修改
    var getData: (Endpoint) async throws -> Data
    
    /// 启动时间（使用GMT时区，与服务器一致）
    private let startDate: Date = {
        // 获取当前时间
        let now = Date.now
        // 获取 GMT 时区的时间偏移量
        let gmtOffset = TimeZone.current.secondsFromGMT()
        // 计算 GMT 时间
        let gmtDate = now.addingTimeInterval(TimeInterval(-gmtOffset))
        
        JPrint("now Date: \(now), GMT Date: \(gmtDate)")
        return gmtDate
    }()
    
    init(getData: @escaping (Endpoint) async throws -> Data) {
        self.getData = getData
    }
}

// MARK: - Singleton
extension CatAPIManager {
    static let shared = CatAPIManager {
        try await URLSession.cat_imageSession.jp_data(for: $0.request)
    }
    
    static let preview = CatAPIManager {
        try? await Task.sleep(for: .seconds(1)) // 模拟网络请求：停1s再回传
        return $0.stub
    }
}

// MARK: - 公开API
extension CatAPIManager {
    func getImages() async throws -> [ImageResponse] {
        try await fetch(.images)
    }
    
    func getFavorites(page: Int, limit: Int) async throws -> [FavoriteItem] {
        try await fetch(.favorites(page: page, limit: limit))
    }
    
    func getFavoritesAndAppend(page: Int, limit: Int = 100) async -> CatFavoriteLoadingState {
        do {
            var items = try await getFavorites(page: page, limit: limit)
            // for error test
//            if Bool.random() {
//                throw URLError(.unknown)
//            }
            
            // 📢 调用addToFavorite（手动添加新数据到favorites）后，接着从服务器请求则会拉取到相同的数据，
            // 这是因为服务器是从数据库拉取数据，不会特意给你过滤掉手动插入的数据。
            // 解决方法1：添加请求后不手动添加新数据，直接请求服务器拉取新数据。 --- 不太推荐，又丑又慢，但能保证顺序跟服务器的一致
            // 解决方法2：添加请求并手动添加新数据，之后请求的数据过滤掉比启动时间更晚的数据。--- 推荐，虽然顺序跟服务器的不符
            while let last = items.last, last.createdAt > startDate {
                items.removeLast()
            }
            // - 服务器拉取的数据是根据createdAt从小到大排序的，直接从最后一个开始检索更有效率。
            // - 手动添加的数据的createdAt肯定是比startDate大的（startDate是初始化时间，添加肯定是初始化之后），所以直接移除即可！
            
            let oldCount = favorites.count
            favorites += items
            JPrint("before favorites.count: \(oldCount), getted favorites.count: \(favorites.count)")
            
            let isLastPage = items.count < limit
            return .success(nextPage: isLastPage ? nil : (page + 1))
            
        } catch {
            JPrint("getFavorites fail: \(error.localizedDescription)")
            return .fail(retryPage: page)
        }
    }
    
    func addToFavorite(_ cat: CatImageViewModel) async throws {
        JPrint("请求【添加】cat：", cat.id)
        let body = ["image_id": cat.id]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let response: FavoriteCreationResponse = try await fetch(.addToFavorite(bodyData: bodyData))
        favorites.append(FavoriteItem(catImage: cat, id: response.id))
    }
    
    func removeFromFavorite(id: Int) async throws {
        guard let index = favorites.firstIndex(where: \.id == id) else { return }
        try await removeFromFavorite(at: index)
    }
    
    func toggleFavorite(_ cat: CatImageViewModel) async throws {
        if let index = favorites.firstIndex(where: \.imageID == cat.id) {
            try await removeFromFavorite(at: index)
        } else {
            try await addToFavorite(cat)
        }
    }
}

// MARK: - 私有API
private extension CatAPIManager {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    /// 使用`nonisolated`修饰符，标记该方法不需要在`MainActor`上执行（允许它在非主线程上执行）
    nonisolated func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T{
        let data = try await getData(endpoint)
        
        // ------- look result 0 -------
//        let str = String(data: data, encoding: .utf8)
//        JPrint("请求结果：", str ?? "???")
        
//        do {
//            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
//            JPrint("请求结果：", dict ?? [:])
//        } catch {
//            JPrint("请求失败！", error)
//        }
        // ------- look result 1 -------
        
        let decoder = JSONDecoder()
        // 自定义日期解析格式（默认解析方式跟catServer的日期格式不匹配）
        decoder.dateDecodingStrategy = await .formatted(Self.dateFormatter)
        return try decoder.decode(T.self, from: data)
    }
    
    func removeFromFavorite(at index: Int) async throws {
        let favorite = favorites[index]
        JPrint("请求【删除】cat：", favorite.imageID)
        do {
            _ = try await getData(.removeFromFavorite(id: favorite.id))
//            _ = try await getData(.removeFromFavorite(id: Int.random(in: 1...100))) // for error test
            favorites.remove(at: index)
        } catch URLSession.APIError.invalidCode(400) {
            JPrint("请求错误：INVALID_ACCOUNT！这是不存在的最爱ID，默默略过该错误...")
        }
    }
}
