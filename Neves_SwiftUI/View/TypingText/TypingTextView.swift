//
//  TypingTextView.swift
//  Neves
//
//  Created by aa on 2025/6/12.
//

import SwiftUI

struct TypingTextView: View {
    let fullText: String =
    """
    清晨七点半，闹钟第N次响起。程序员小李睡眼惺忪地摸到手机，先看一眼有没有线上告警🔔，再挣扎着爬起来。这是他在深圳写代码的第三年，工资到账还没捂热，就被房租、水电、花呗和显卡分期瓜分殆尽💸。
    
    地铁早高峰里，无数个小李挤在车厢中，人人低头刷着技术公众号，脸上写满疲惫😮‍💨。他们穿梭在写字楼格子间，敲着键盘、改着Bug、开着站会，把青春兑换成每月固定到账的数字。996是常态，双休成了奢侈品，需求一变再变，产品经理一句“再改改”，就能让一个下午化为乌有📝。
    
    “程序员打工人”这个称呼带着自嘲的温情。他们调侃自己“码农魂”👨‍💻，在群里发着“今天你修Bug了吗”的表情包，用幽默消解现实的重量。可夜深人静时，焦虑如潮水涌来——35岁危机、裁员传闻、永远追不上的房价，还有那越来越高的发际线，像几座大山压在胸口😵。
    
    然而，程序员打工人从未放弃寻找生活的微光✨。工位上那盆绿萝、午休时刷到的搞笑视频、周五晚上和朋友的一顿烧烤🍢，都是支撑下去的理由。他们一边喊着“躺平”，一边默默学习新框架；一边吐槽工作，一边把代码写到最优雅。偶尔上线成功，看到日志里没有红色报错，也会小小地开心一下🎉。
    
    这代程序员打工人明白，生活或许不会突然变好，但也不必永远困在焦虑里。他们学会在通勤路上听播客🎧，在出租屋里养一只猫🐱，在周末去公园看一场日落🌇。因为真正的勇敢，是看清生活的真相后，依然热爱生活。
    
    我们都是程序员打工人，都在用自己的方式，在这个时代里认真地活着。或许前路漫漫，但每一个敲下的字符，都在为明天积蓄光亮💪。
    """
    let typingInterval: TimeInterval = 0.03
    
    @State private var displayText: String = ""
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView {
            Button("点我\(isAnimating ? "暂停" : "开始")") {
                if isAnimating {
                    stopAnimationAndShowAll()
                } else {
                    startTyping()
                }
            }
            Text(displayText)
                .font(.system(size: 17))
                .foregroundColor(.primary)
                .contentTransition(.opacity) // 核心代码#1：选择动画类型
                .animation(.smooth, value: displayText) // 核心代码#2：选择动画曲线（value-该值发生变化才有动画效果）
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
        }
        .padding()
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTyping() {
        displayText = ""
        currentIndex = 0
        isAnimating = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { t in
            if currentIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
                displayText.append(fullText[index])
                currentIndex += 1
            } else {
                t.invalidate()
                isAnimating = false
            }
        }
    }
    
    private func stopAnimationAndShowAll() {
        timer?.invalidate()
        displayText = fullText
        isAnimating = false
    }
}
