//
//  View+CatFriendlyError.swift
//  Neves_SwiftUI
//
//  Created by aa on 2024/3/24.
//

import SwiftUI

struct CatFriendlyError {
    let title: String
    let error: Error
}

extension View {
    func cat_alert(_ error: Binding<CatFriendlyError?>) -> some View {
        self.alert(isPresented: Binding(
            get: { error.wrappedValue != nil },
            set: { _ in error.wrappedValue = nil }
        )) {
            Alert(
                title: Text(error.wrappedValue!.title),
                message: Text(error.wrappedValue!.error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
