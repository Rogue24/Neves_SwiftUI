//
//  PhaseAnimBallView.swift
//  Neves_SwiftUI
//
//  Created by aa on 2026/9/21.
//
//  学自：https://www.bilibili.com/video/BV1svt56XEqa/?spm_id_from=333.1387.upload.video_card.click&vd_source=05ccbbed10d0de65a33ef63c4e5dd2fe
//

import SwiftUI

private let whScale: Double = 3

enum BallPhases: CaseIterable {
    case drop, squish, expand, rise
    
    var offsetY: Double {
        switch self {
        case .drop: 0
        case .squish: 5 * whScale
        case .expand: 0
        case .rise: -40 * whScale
        }
    }
    
    var scale: CGSize {
        switch self {
        case .squish: [1.2, 0.75]
        case .drop, .expand, .rise: [1, 1]
        }
    }
}

struct PhaseAnimBallView: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            PhaseAnimator(BallPhases.allCases) { phase in
                Circle()
                    .fill(Color.pink)
                    .frame(width: 20 * whScale)
                    .offset(x: 0, y: phase.offsetY)
                    .scaleEffect(phase.scale, anchor: .bottom)
            } animation: { phase in
                switch phase {
                case .drop: .easeIn(duration: 0.6)
                case .squish: .easeOut(duration: 0.1)
                case .expand: .easeIn(duration: 0.1)
                case .rise: .easeOut(duration: 0.6)
                }
            }
        } else {
            Text("Need iOS 17.0+")
        }
    }
}
