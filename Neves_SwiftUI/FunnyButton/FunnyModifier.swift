//
//  FunnyModifier.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/18.
//

import SwiftUI

struct FunnyModifier: ViewModifier {
    @EnvironmentObject var funny: Funny
    
    var getActions: () -> [FunnyAction]
    
    func body(content: Content) -> some View {
        content
            .onAppear() {
                funny.getActions = getActions
            }
            .onDisappear() {
                funny.getActions = nil
            }
    }
}

extension View {
    func funnyAction(_ work: @escaping () -> ()) -> some View {
        modifier(
            FunnyModifier() {
                [FunnyAction(work: work)]
            }
        )
    }
    
    func funnyActions(_ getActions: @escaping () -> [FunnyAction]) -> some View {
        modifier(
            FunnyModifier(getActions: getActions)
        )
    }
}
