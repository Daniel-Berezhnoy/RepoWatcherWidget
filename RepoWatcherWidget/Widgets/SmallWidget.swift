//
//  SmallWidget.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/6/23.
//

import WidgetKit
import SwiftUI

struct SmallWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SmallWidgetEntry {
        SmallWidgetEntry(date: Date(), repo: Repository.placeholder)
    }
    
    func getSnapshot(for configuration: SelectRepoIntent, in context: Context, completion: @escaping (SmallWidgetEntry) -> Void) {
        let entry = SmallWidgetEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectRepoIntent, in context: Context, completion: @escaping (Timeline<SmallWidgetEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds
            
            do {
                let repoToShow = RepoURL.prefix + (configuration.repo ?? "Daniel-Berezhnoy/SwiftUIBuddy")
                var repo = try await NetworkManager.shared.getRepo(from: repoToShow)
                
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData
                
                let entry = SmallWidgetEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                
                completion(timeline)
            } catch {
                print("❌ ERROR: \(error.localizedDescription)")
            }
        }
    }
}

struct SmallWidgetEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct SmallWidgetEntryView: View {
    var entry: SmallWidgetEntry
    
    var body: some View {
        LastUpdateView(for: entry.repo)
    }
}

struct SmallWidget: Widget {
    let kind: String = "SmallWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: SelectRepoIntent.self,
                            provider: SmallWidgetProvider()) { entry in
            SmallWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Last Update")
        .description("See how many days ago the repository was updated.")
        .supportedFamilies([.systemSmall])
    }
}

struct SmallWidget_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetEntryView(entry: SmallWidgetEntry(date: Date(), repo: Repository.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
