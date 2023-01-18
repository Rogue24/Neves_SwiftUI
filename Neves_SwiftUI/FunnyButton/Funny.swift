//
//  Funny.swift
//  Neves_SwiftUI
//
//  Created by aa on 2023/1/18.
//

class Funny: ObservableObject {
    private var funnyBtn: FunnyButton { .shared }
    
    var getActions: (() -> [FunnyAction])? {
        set { funnyBtn.getActions = newValue }
        get { funnyBtn.getActions }
    }
}