//
//  LargeWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daniel Berezhnoy on 3/5/23.
//

import WidgetKit
import SwiftUI

struct LargeWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> LargeWidgetEntry {
        LargeWidgetEntry(date: .now, repo: Repository.placeholder)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LargeWidgetEntry) -> Void) {
        let entry = LargeWidgetEntry(date: .now, repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LargeWidgetEntry>) -> Void) {
        
        let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds
        
        let entry = LargeWidgetEntry(date: .now, repo: Repository.placeholder)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
}

struct LargeWidgetEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct LargeWidgetEntryView: View {
    var entry: LargeWidgetEntry
    
    var body: some View {
        VStack {
            RepoStatsView(for: entry.repo)
                .padding(.bottom)
            
            TopContributorsView(for: entry.repo)
        }
    }
}

struct LargeWidget: Widget {
    let kind: String = "LargeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LargeWidgetProvider()) { entry in
            LargeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Repo Watcher+")
        .description("Repo Watcher + Top Contributors")
        .supportedFamilies([.systemLarge])
    }
}

struct LargeWidget_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetEntryView(entry: LargeWidgetEntry(date: .now, repo: Repository.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
