//
//  Func.swift
//  Neves_SwiftUI
//
//  Created by aa on 2021/12/6.
//

var screenSize: CGSize { UIScreen.main.bounds.size }

func haptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

