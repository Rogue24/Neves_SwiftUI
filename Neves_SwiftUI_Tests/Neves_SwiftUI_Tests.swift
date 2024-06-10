//
//  Neves_SwiftUI_Tests.swift
//  Neves_SwiftUI_Tests
//
//  Created by 周健平 on 2023/9/10.
//

import XCTest
/// 使用`@testable`可以读取到`Neves_SwiftUI`里面所有`internal`的类型（内部类）
@testable import Neves_SwiftUI

final class Neves_SwiftUI_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        print("jpjpjp setUpWithError")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        print("jpjpjp tearDownWithError")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        print("jpjpjp testExample")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
            
            print("jpjpjp testPerformanceExample")
        }
    }
    
    // MARK: - Test: Old_Suffix
    
    /// 测试的主体
    /// `sut`: ** system under test **
//    var sut: Old_Suffix!
    
    /// 需要测试的函数需要加上`test`前缀！！！
//    func test_formatter() {
//        sut = Old_Suffix(wrappedValue: 100, "g")
//        XCTAssertEqual(sut.projectedValue, "100 g", "这都搞不掂？！")
//        
//        sut = Old_Suffix(wrappedValue: 100.888, "g")
//        XCTAssertEqual(sut.projectedValue, "100.9 g", "最多只显示1位小数点，并且四舍五入")
//        
//        sut = Old_Suffix(wrappedValue: -100.234, "g")
//        XCTAssertEqual(sut.projectedValue, "-100.2 g", "最多只显示1位小数点，并且四舍五入")
//    }

    /// 函数命名规范：`test_主体_情况_结果`
//    func test_formatteredString_suffixIsEmpty_shouldNotIncludeSpace() {
//        // 1.Arrange 设定
//        sut = Old_Suffix(wrappedValue: 100, "")
//        
//        // 2.Act 变化
//        let result = sut.projectedValue
//          
//        // 3.Assert 结果
//        XCTAssertEqual(result, "100", "没有后缀时别带上空格")
//    }
    
    // MARK: - Test: CatAPIManager
    
    /// 测试的主体
    /// `sut`: ** system under test **
    var sut: CatAPIManager! 
    
    /// 执行【每一次】测试前都会调用该函数
    override func setUp() async throws {
        await MainActor.run {
            sut = .stub // 清空数据：重置一下`CatAPIManager`
        }
    }
    
    // ----- 调试网络数据的解码 -----
    
    func test_getImages() async throws {
        let images = try await sut.getImages()
        // 检查是不是拿到10张图片
        XCTAssertEqual(images.count, 10)
    }
    
    @MainActor
    func test_getFavoritesAndAppend() async {
        let result1 = await sut.getFavoritesAndAppend(page: 0, limit: 5)
        XCTAssertEqual(result1, .success(nextPage: 1))
        XCTAssertEqual(5, sut.favorites.count)
        
        let result2 = await sut.getFavoritesAndAppend(page: 1, limit: 5)
        XCTAssertEqual(result2, .success(nextPage: 2))
        XCTAssertEqual(10, sut.favorites.count)
        
        let result3 = await sut.getFavoritesAndAppend(page: 2, limit: 5)
        XCTAssertEqual(result3, .success(nextPage: nil))
        XCTAssertEqual(13, sut.favorites.count)
    }
    
    func test_getFavorites() async throws {
        let result1 = try await sut.getFavorites(page: 1, limit: 5)
        XCTAssertEqual(result1.count, 5)
        
        let result2 = try await sut.getFavorites(page: 2, limit: 5)
        XCTAssertEqual(result2.count, 3)
        
        let result3 = try await sut.getFavorites(page: 5, limit: 5)
        XCTAssertEqual(result3.count, 0)
    }
    
    @MainActor
    func test_addToFavorite() async throws {
        try await sut.addToFavorite([CatImageViewModel].stub.first!) // 测试：无论丢啥进去，返回的`response`的`id`固定为`100038507`
        let id = sut.favorites.first!.id
        // 检查解码拿到的id是不是100038507
        XCTAssertEqual(id, 100038507)
    }
}

extension CatAPIManager {
    static var stub: CatAPIManager {
        CatAPIManager { $0.stub }
    }
}
