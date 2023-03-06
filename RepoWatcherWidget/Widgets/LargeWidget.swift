//
//  LargeWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daniel Berezhnoy on 3/5/23.
//

import WidgetKit
import SwiftUI

struct LargeWidgetProvider: TimelineProvider {
    
    let repoToShow = RepoURL.codeEdit
    
    func placeholder(in context: Context) -> LargeWidgetEntry {
        LargeWidgetEntry(date: .now, repo: Repository.placeholder)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LargeWidgetEntry) -> Void) {
        let entry = LargeWidgetEntry(date: .now, repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LargeWidgetEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds
            
            do {
                // Get Repo
                var repo = try await NetworkManager.shared.getRepo(from: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData
                
                // Get the Top 4 Contributors
                let contributors = try await NetworkManager.shared.getContributors(from: repoToShow + "/contributors")
                var topContributors = Array(contributors.prefix(4))
                
                // Download the top 4 Avatars
                for i in topContributors.indices {
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topContributors[i].avatarUrl)
                    topContributors[i].avatarData = avatarData
                }
                
                // Setting the values for Top Contributors
                repo.contributors = topContributors
                
                // Create Entry & Timeline
                let entry = LargeWidgetEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                
                // Call completion handler on the Timeline
                completion(timeline)
                
            } catch {
                print("❌ ERROR: \(error.localizedDescription)")
            }
        }
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
