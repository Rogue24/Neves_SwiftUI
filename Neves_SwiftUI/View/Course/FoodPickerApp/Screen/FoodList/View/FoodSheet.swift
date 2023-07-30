//
//  FoodSheet.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/30.
//

import SwiftUI

extension FoodListScreen {
    enum Sheet: View, Identifiable {
        case newFood(_ onSubmit: (Food) -> Void)
        case editFood(_ binding: Binding<Food>)
        case foodDetail(_ food: Food)
        
        var id: UUID {
            switch self {
            case .newFood:
                return UUID()
                
            case let .editFood(binding):
                return binding.wrappedValue.id
                
            case let .foodDetail(food):
                return food.id
            }
        }
        
        var body: some View {
            switch self {
            case let .newFood(onSubmit):
                FoodFormView(food: .new, onSubmit: onSubmit)
                
            case let .editFood(binding):
                FoodFormView(food: binding.wrappedValue) {
                    binding.wrappedValue = $0
                }
                
            case let .foodDetail(food):
                FoodDetailSheet(food: food)
            }
        }
    }
}
