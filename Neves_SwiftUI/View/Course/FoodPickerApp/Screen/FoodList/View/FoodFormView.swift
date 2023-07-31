//
//  FoodFormView.swift
//  Neves_SwiftUI
//
//  Created by 周健平 on 2023/7/23.
//

import SwiftUI

extension FoodListScreen {
    struct FoodFormView: View {
        enum Field: Int {
            case name
            case image
            case calorie
            case carb
            case fat
            case protein
            
            var isLast: Bool { self == .protein }
        }
        
        @Environment(\.dismiss) var dismiss
        @FocusState private var field: Field?
        @State var food: Food = .new
        
        var onSubmit: (Food) -> Void
        
        private var isNotValid: Bool {
            food.name.isEmpty || food.image.isEmpty || food.image.count > 2
        }
        
        private var invalidMessage: String? {
            if food.name.isEmpty { return "请输入名称" }
            if food.image.isEmpty { return "请输入图示" }
            if food.image.count > 2 { return "图示字符过多" }
            return .none
        }
        
        var body: some View {
            // 📢 注意：`toolbar`必须要包裹在`Navigation`里面才有效果！
            NavigationStack {
                VStack {
                    titleBar
                    formView
                    saveButton
                }
                .background(.sysGb)
                // ---- 设置`VStack`里面整体文本的默认样式 ----
                .multilineTextAlignment(.trailing)
                .font(.title3)
                // --------
                .scrollDismissesKeyboard(.interactively)
                // 添加键盘工具栏
                // 📢 注意：`toolbar`必须要包裹在`Navigation`里面才有效果！
                .toolbar(content: buildKeyboardTools)
            }
        }
    }
}

// MARK: - Subviews
private extension FoodListScreen.FoodFormView {
    var titleBar: some View {
        HStack {
            Label("编辑食物信息", sfs: .pencil)
                .font(.title.bold())
                .foregroundColor(.accentColor)
                .xPush(to: .leading)
            
            SFSymbol.xmarkCircleFill
                .font(.largeTitle.bold())
                .foregroundColor(.secondary)
                .onTapGesture {
                    dismiss()
                }
        }
        .padding([.horizontal, .top])
    }
    
    var formView: some View {
        Form {
            LabeledContent("名称") {
                TextField("必填", text: $food.name)
                    .focused($field, equals: .name)
            }
            
            LabeledContent("图示") {
                TextField("最多输入2个字符", text: $food.image)
                    .focused($field, equals: .image)
            }
            
            buildNumberFiled(title: "热量",
                             value: $food.calorie,
                             field: .calorie,
                             suffix: "大卡")
            
            buildNumberFiled(title: "碳水",
                             value: $food.carb,
                             field: .carb)
            
            buildNumberFiled(title: "脂肪",
                             value: $food.fat,
                             field: .fat)
            
            buildNumberFiled(title: "蛋白质",
                             value: $food.protein,
                             field: .protein)
        }
        .padding(.top, -16)
    }
    
    var saveButton: some View {
        Button {
            dismiss()
            onSubmit(food)
        } label: {
            Text(invalidMessage ?? "保存")
                .bold()
                .maxWidth()
        }
        .mainButtonStyle()
        .padding()
        .disabled(isNotValid)
    }
}

// MARK: - View Builder
private extension FoodListScreen.FoodFormView {
    func buildNumberFiled(title: String,
                          value: Binding<Double>,
                          field: Field,
                          suffix: String = "g") -> some View {
        LabeledContent(title) {
            HStack {
                TextField(
                    "",
                    value: value,
                    format: .number.precision(.fractionLength(1)) // 只显示小数点后1位
                )
                .focused(self.$field, equals: field)
                .keyboardType(.decimalPad)
                
                Text(suffix)
            }
        }
    }
    
    func buildKeyboardTools() -> some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(action: goPreviousField) {
                SFSymbol.chevronUp
            }
            Button(action: goNextField) {
                SFSymbol.chevronDown
            }
        }
    }
}

// MARK: - Focus Handling
private extension FoodListScreen.FoodFormView {
    func goPreviousField() {
        guard let rawValue = field?.rawValue else { return }
        field = Field(rawValue: rawValue - 1)
    }
    
    func goNextField() {
        guard let rawValue = field?.rawValue else { return }
        field = Field(rawValue: rawValue + 1)
    }
}

private extension TextField where Label == Text {
    typealias F = FoodListScreen.FoodFormView.Field
    func focused(_ field: FocusState<F?>.Binding, equals this: F) -> some View {
        self
            .submitLabel(this.isLast ? .done : .next)
            .focused(field, equals: this)
            .onSubmit {
                field.wrappedValue = .init(rawValue: this.rawValue + 1)
            }
    }
}
