//
//  NevesWidget.swift
//  NevesWidget
//
//  Created by aa on 2022/3/25.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    /// 📢注意：如果相同的小组件存在多个（小、中、大杯），当调用`reloadTimelines`，这里会【按照小、中、大杯的顺序依次调用】这个方法。
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        updateTestData(currentDate)
        
        /**
         * 小组件刷新机制：
         * 参考1：https://xiaozhuanlan.com/topic/1458963702#sectionwidget
         * 参考2：https://www.bbsmax.com/A/GBJrQ7r9z0/
         * 经实测，小组件的刷新间隔最短也要【5分钟左右】，即便这里设置得很短间隔都没用，这是由系统决定。
         */
        
        let entryDate = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, configuration: configuration)
        entries.append(entry)
        
        /// policy提供下次更新的时间，可填：
        /// .never：永不更新(可通过WidgetCenter更新)
        /// .after(Date)：指定多久之后更新
        /// .atEnd：指定Widget通过你提供的entries的Date更新。
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        completion(timeline)
    }
    
    private func updateTestData(_ currentDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
         
        var lastDateStr: String = "null"
        let lastTime = UserDefaults(suiteName: AppGroups.identifier)?.integer(forKey: "widget_currentDateTimeInt") ?? 0
        if lastTime > 0 {
            let lastDate = Date(timeIntervalSince1970: TimeInterval(lastTime))
            lastDateStr = formatter.string(from: lastDate)
        }
        
        let currentDateTimeInt = Int(currentDate.timeIntervalSince1970)
        let currentDateStr = formatter.string(from: currentDate)
        
        
        var index = UserDefaults(suiteName: AppGroups.identifier)?.integer(forKey: "widget_index") ?? 0
        let emojis = ["🤐", "🥱", "🐮", "🌼", "🐻‍❄️", "🍔", "🧁", "🍪", "🍑"]
        let emoji = emojis[index]
        
        index += 1
        if index >= emojis.count {
            index = 0
        }
        
        UserDefaults(suiteName: AppGroups.identifier)?.set(currentDateTimeInt, forKey: "widget_currentDateTimeInt")
        UserDefaults(suiteName: AppGroups.identifier)?.set(currentDateStr, forKey: "widget_currentDateStr")
        UserDefaults(suiteName: AppGroups.identifier)?.set(lastDateStr, forKey: "widget_lastDateStr")
        
        UserDefaults(suiteName: AppGroups.identifier)?.set(index, forKey: "widget_index")
        UserDefaults(suiteName: AppGroups.identifier)?.set(emoji, forKey: "widget_emoji")
        
        UserDefaults(suiteName: AppGroups.identifier)?.synchronize()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct NevesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
//        Text(entry.date, style: .time)
        NevesWidgetView()
    }
}

@main
struct NevesWidget: Widget {
    let kind: String = "NevesWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NevesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct NevesWidget_Previews: PreviewProvider {
    static var previews: some View {
        NevesWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
