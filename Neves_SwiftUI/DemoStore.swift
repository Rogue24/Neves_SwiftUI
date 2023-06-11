//
//  DemoStore.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/6.
//

import SwiftUI
import Combine

enum Demo: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    // MARK: - Course
    case FoodPickerApp
    case AnimTest
    
    // MARK: - Test
    case Test1
    case Test2
    case Test3
    case FrameTest
    case GeometryReaderTest
    case StateObjectTest
    case StateInitTest
    case EnvironmentTest
    case RouteTest
    
    // MARK: - Base
    case MatchedGeometryEffect
    case LazyGrid
    case ResultBuilder
    case WaterfallGrid
    
    // MARK: - Unit
    case Buttons
    case ProgressHUD
    case FunnyPlay
    
    // MARK: - Animation
    case AnimationValue
    case AnimExperience_iOS15
    case AnimExperience
    
    // MARK: - GIF
    case GifImage
    case AsyncGifImage
    
    // MARK: - UIKit
    case ImagePicker
    case ImageCroper
    
    // MARK: - Widget
    case NevesWidget
}

extension Demo {
    var title: String { rawValue }
    
    @ViewBuilder
    var body: some View {
        switch self {
        // Course
        case .FoodPickerApp: FoodPicker()
        case .AnimTest: AnimTestView()
            
        // Test
        case .Test1: Test1View()
        case .Test2: Test2View()
        case .Test3: Test3View()
        case .FrameTest: FrameTestView()
        case .GeometryReaderTest: GeometryReaderTestView()
        case .StateObjectTest: StateObjectTestView()
        case .StateInitTest: StateInitTestView()
        case .EnvironmentTest: EnvironmentTestView()
        case .RouteTest: RouteTestView()
            
        // Base
        case .MatchedGeometryEffect: MatchedGeometryEffectView()
        case .LazyGrid: LazyGridView()
        case .ResultBuilder: ResultBuilderView()
        case .WaterfallGrid: WaterfallGridView()
            
        // Unit
        case .Buttons: ButtonsView()
        case .ProgressHUD: ProgressHUDView()
        case .FunnyPlay: FunnyPlayView()
            
        // Animation
        case .AnimationValue: AnimationValueView()
        case .AnimExperience_iOS15: AnimExperience_iOS15_View()
        case .AnimExperience: AnimExperienceView()
            
        // GIF
        case .GifImage:
            if #available(iOS 15.0.0, *) {
                GifImageView()
            } else {
                PlaceholderView(title: "需要iOS15+")
            }
        case .AsyncGifImage:
            if #available(iOS 15.0.0, *) {
                AsyncGifImageView()
            } else {
                PlaceholderView(title: "需要iOS15+")
            }
            
        // UIKit
        case .ImagePicker:
            ImagePickerShowView()
        case .ImageCroper:
            ImageCroperView(cachePath: .constant(""), isCroped: .constant(false))
                .edgesIgnoringSafeArea(.all)
            
        // Widget
        case .NevesWidget: NevesWidgetEditView()
        }
    }
}

extension Demo {
    struct Section: Identifiable {
        let id = UUID()
        let title: String
        let demos: [Demo]
    }
    
    static let sections = [
        Section(title: "Course", demos: [
            .FoodPickerApp,
            .AnimTest
        ]),
        
        Section(title: "Test", demos: [
            .Test1,
            .Test2,
            .Test3,
            .GeometryReaderTest,
            .StateObjectTest,
            .StateInitTest,
            .EnvironmentTest,
            .RouteTest,
        ]),
        
        Section(title: "Base", demos: [
            .MatchedGeometryEffect,
            .LazyGrid,
            .ResultBuilder,
            .WaterfallGrid,
        ]),
        
        Section(title: "Unit", demos: [
            .Buttons,
            .ProgressHUD,
            .FunnyPlay,
        ]),
        
        Section(title: "Animation", demos: [
            .AnimationValue,
            .AnimExperience_iOS15,
            .AnimExperience,
        ]),
        
        Section(title: "GIF", demos: [
            .GifImage,
            .AsyncGifImage,
        ]),
        
        Section(title: "UIKit", demos: [
            .ImagePicker,
            .ImageCroper,
        ]),
        
        Section(title: "Widget", demos: [
            .NevesWidget,
        ]),
    ]
}
