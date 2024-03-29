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
    
    /// 测试的主体
    /// `sut`: ** system under test **
    var sut: Suffix!

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
    
    /// 需要测试的函数需要加上`test`前缀！！！
    func test_formatter() {
        sut = Suffix(wrappedValue: 100, "g")
        XCTAssertEqual(sut.projectedValue, "100 g", "这都搞不掂？！")
        
        sut = Suffix(wrappedValue: 100.888, "g")
        XCTAssertEqual(sut.projectedValue, "100.9 g", "最多只显示1位小数点，并且四舍五入")
        
        sut = Suffix(wrappedValue: -100.234, "g")
        XCTAssertEqual(sut.projectedValue, "-100.2 g", "最多只显示1位小数点，并且四舍五入")
    }

    /// 函数命名规范：`test_主体_情况_结果`
    func test_formatteredString_suffixIsEmpty_shouldNotIncludeSpace() {
        // 1.Arrange 设定
        sut = Suffix(wrappedValue: 100, "")
        
        // 2.Act 变化
        let result = sut.projectedValue
          
        // 3.Assert 结果
        XCTAssertEqual(result, "100", "没有后缀时别带上空格")
    }
}
