//
//  DemoStore.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/6.
//

import SwiftUI
import Combine

enum Demo: String {
    // MARK: - Test
    case Test1
    case Test2
    case Test3
    case FrameTest
    case GeometryReaderTest
    case StateObjectTest
    
    // MARK: - Base
    case MatchedGeometryEffect
    case LazyGrid
    case ResultBuilder
    
    // MARK: - Unit
    case Buttons
    case ProgressHUD
    
    // MARK: - Animation
    case AnimationValue
    case AnimExperience_iOS15
    case AnimExperience
    
    // MARK: - UIKit
    case ImagePicker
    case ImageCroper
}

extension Demo {
    static let sections = [
        Section(title: "Test", items: [
            Item(demo: .Test1),
            Item(demo: .Test2),
            Item(demo: .Test3),
            Item(demo: .GeometryReaderTest),
            Item(demo: .StateObjectTest),
        ]),
        
        Section(title: "Base", items: [
            Item(demo: .MatchedGeometryEffect),
            Item(demo: .LazyGrid),
            Item(demo: .ResultBuilder),
        ]),
        
        Section(title: "Unit", items: [
            Item(demo: .Buttons),
            Item(demo: .ProgressHUD),
        ]),
        
        Section(title: "Animation", items: [
            Item(demo: .AnimationValue),
            Item(demo: .AnimExperience_iOS15),
            Item(demo: .AnimExperience),
        ]),
        
        Section(title: "UIKit", items: [
            Item(demo: .ImagePicker),
            Item(demo: .ImageCroper),
        ]),
    ]
}

extension Demo {
    struct Section: Identifiable {
        let id = UUID()
        let title: String
        let items: [Item]
    }
    
    struct Item: Identifiable {
        let id = UUID()
        let demo: Demo
        
        var title: String { demo.rawValue }
        
        @ViewBuilder
        var body: some View {
            Group {
                switch demo {
                // Test
                case .Test1: Test1View()
                case .Test2: Test2View()
                case .Test3: Test3View()
                case .FrameTest: FrameTestView()
                case .GeometryReaderTest: GeometryReaderTestView()
                case .StateObjectTest: StateObjectTestView()
                    
                // Base
                case .MatchedGeometryEffect: MatchedGeometryEffectView()
                case .LazyGrid: LazyGridView()
                case .ResultBuilder: ResultBuilderView()
                    
                // Unit
                case .Buttons: ButtonsView()
                case .ProgressHUD: ProgressHUDView()
                    
                // Animation
                case .AnimationValue: AnimationValueView()
                case .AnimExperience_iOS15: AnimExperience_iOS15_View()
                case .AnimExperience: AnimExperienceView()
                    
                // UIKit
                case .ImagePicker:
                    if #available(iOS 15.0, *) {
                        NevesWidgetView()
                    }
//                    ImagePickerView(selectedImage: .constant(nil))
//                        .edgesIgnoringSafeArea(.all)
                case .ImageCroper:
//                    ImageCroperView(cachePath: .constant(""), isCroped: .constant(false))
//                        .edgesIgnoringSafeArea(.all)
                    if #available(iOS 15.0, *) {
//                        AsyncGifImage(url: url, isReLoad: .constant(false), isAnimating: .constant(true)) { phase in
//                            switch phase {
//                            // 请求中
//                            case .empty:
//                                ProgressView()
//                            // 请求成功
//                            case .success(let image):
//                                image.aspectRatio(contentMode: .fit)
//                            // 请求失败
//                            case .failure:
//                                Text("Failure")
//                            }
//                        }
                        
                        VStack {
                            GifImage(gifResult: nil, isAnimating: .constant(true))
                                .frame(width: 200, height: 200)
                                .background(.pink)
                                .zIndex(1)
                            
//                            Image("")
//                                .resizable()
                            
                            
                            AsyncGifImage(url: url,
                                          transaction: Transaction(animation: .easeOut),
                                          isReLoad: .constant(false), isAnimating: .constant(true)) { phase in
                                    Group {
                                        switch phase {
                                        // 请求中
                                        case .empty:
                                            ProgressView()
                                        // 请求成功
                                        case .success(let image):
                                            image
                                                .aspectRatio(contentMode: .fit)
//                                                .frame(maxWidth: .infinity)
                                                .frame(width: 300, height: 300)
                                                .background(.green)
                                        // 请求失败
                                        case .failure:
                                            Text("Failure")
                                        }
                                    }
                                    .background(.red)
                                }
                        }
                    }
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
        }
        
        var url: URL? {
//            URL(fileURLWithPath: Bundle.main.path(forResource: "Cat", ofType: "gif")!)
            URL(string: "https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ff6f34b91b5046c292092205bfc0aaea~tplv-k3u1fbpfcp-watermark.image?")
        }
    }
    
    struct PlaceholderView: View {
        let title: String
        var body: some View {
            VStack {
                Text("敬请期待！")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(Color.randomColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.randomColor)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(title)
        }
    }
}
