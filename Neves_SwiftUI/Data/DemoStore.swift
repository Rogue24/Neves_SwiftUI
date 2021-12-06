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
    
    // MARK: - Base
    case Base1
    case Base2
    case Base3
    
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
            Item(demo: .Base1),
            Item(demo: .Base2),
            Item(demo: .Base3),
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
                
            case .Test1:
                Test1View()
                    .navigationBarTitle(title, displayMode: .inline)
            case .Test2:
                Test2View()
                    .navigationBarTitle(title, displayMode: .inline)
            case .Test3:
                Test3View()
                    .navigationBarTitle(title, displayMode: .inline)
                
            case .Buttons:
                ButtonsView()
                    .navigationBarTitle(title, displayMode: .inline)
                
            case .AnimExperience:
                AnimExperienceView()
                    .navigationBarTitle(title, displayMode: .inline)
                
            case .ImagePicker:
                ImagePickerView(selectedImage: .constant(nil))
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle(title, displayMode: .inline)
            case .ImageCroper:
                ImageCroperView(cachePath: .constant(""), isCroped: .constant(false))
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle(title, displayMode: .inline)

            default:
                PlaceholderView(title: title)
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
