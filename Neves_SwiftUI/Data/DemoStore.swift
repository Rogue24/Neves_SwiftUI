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
                case .AnimExperience: AnimExperienceView()
                    
                // UIKit
                case .ImagePicker:
                    ImagePickerView(selectedImage: .constant(nil))
                        .edgesIgnoringSafeArea(.all)
                case .ImageCroper:
                    ImageCroperView(cachePath: .constant(""), isCroped: .constant(false))
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
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
