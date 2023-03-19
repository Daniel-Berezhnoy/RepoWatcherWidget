//
//  MediumWidget.swift
//  MediumWidget
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

import WidgetKit
import SwiftUI

struct MediumWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> MediumWidgetEntry {
        MediumWidgetEntry(date: Date(), repo: Repository.placeholder)
    }
    
    func getSnapshot(for configuration: SelectRepoIntent, in context: Context, completion: @escaping (MediumWidgetEntry) -> Void) {
        let entry = MediumWidgetEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectRepoIntent, in context: Context, completion: @escaping (Timeline<MediumWidgetEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds

            do {
                let repoToShow = RepoURL.prefix + (configuration.repo ?? "Daniel-Berezhnoy/SwiftUIBuddy")
                var repo = try await NetworkManager.shared.getRepo(from: repoToShow)
                
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData

                let entry = MediumWidgetEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

                completion(timeline)
            } catch {
                print("❌ ERROR: \(error.localizedDescription)")
            }
        }
    }
}

struct MediumWidgetEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct MediumWidgetEntryView: View {
    var entry: MediumWidgetEntry
    
    var body: some View {
        RepoStatsView(for: entry.repo)
    }
}

struct MediumWidget: Widget {
    let kind: String = "MediumWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: SelectRepoIntent.self,
                            provider: MediumWidgetProvider()) { entry in
            MediumWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Repo Stats")
        .description("See all the information about the repository.")
        .supportedFamilies([.systemMedium])
    }
}

struct MediumWidget_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetEntryView(entry: MediumWidgetEntry(date: Date(),
                                                       repo: Repository.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
