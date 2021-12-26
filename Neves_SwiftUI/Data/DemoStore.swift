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
    
    // MARK: - Base
    case MatchedGeometryEffect
    case LazyGrid
    
    // MARK: - Unit
    case Buttons
    
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
        ]),
        
        Section(title: "Base", items: [
            Item(demo: .MatchedGeometryEffect),
            Item(demo: .LazyGrid),
        ]),
        
        Section(title: "Unit", items: [
            Item(demo: .Buttons),
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
            switch demo {
                
            // Test
            case .Test1:
                Test1View()
                    .navigationBarTitle(title, displayMode: .inline)
            case .Test2:
                Test2View()
                    .navigationBarTitle(title, displayMode: .inline)
            case .Test3:
                Test3View()
                    .navigationBarTitle(title, displayMode: .inline)
            case .FrameTest:
                FrameTestView()
                    .navigationBarTitle(title, displayMode: .inline)
                
            // Base
            case .MatchedGeometryEffect:
                MatchedGeometryEffectView()
                    .navigationBarTitle(title, displayMode: .inline)
            case .LazyGrid:
                LazyGridView()
                    .navigationBarTitle(title, displayMode: .inline)
                
            // Unit
            case .Buttons:
                ButtonsView()
                    .navigationBarTitle(title, displayMode: .inline)
                
            // Animation
            case .AnimExperience:
                AnimExperienceView()
                    .navigationBarTitle(title, displayMode: .inline)
                
            // UIKit
            case .ImagePicker:
                ImagePickerView(selectedImage: .constant(nil))
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle(title, displayMode: .inline)
            case .ImageCroper:
                ImageCroperView(cachePath: .constant(""), isCroped: .constant(false))
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle(title, displayMode: .inline)

//            default:
//                PlaceholderView(title: title)
            }
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
