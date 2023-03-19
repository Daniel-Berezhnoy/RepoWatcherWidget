//
//  LargeWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daniel Berezhnoy on 3/5/23.
//

import WidgetKit
import SwiftUI

struct LargeWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> LargeWidgetEntry {
        LargeWidgetEntry(date: .now, repo: Repository.placeholder)
    }
    
    func getSnapshot(for configuration: SelectRepoIntent, in context: Context, completion: @escaping (LargeWidgetEntry) -> Void) {
        let entry = LargeWidgetEntry(date: .now, repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectRepoIntent, in context: Context, completion: @escaping (Timeline<LargeWidgetEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds
            
            do {
                // Get The Repo
                let repoToShow = RepoURL.prefix + (configuration.repo ?? "Daniel-Berezhnoy/SwiftUIBuddy")
                var repo = try await NetworkManager.shared.getRepo(from: repoToShow)
                
                // Download and set the Avatar for the Repo Owner
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData
                
                // Get the Top 4 Contributors
                let contributors = try await NetworkManager.shared.getContributors(from: repoToShow + "/contributors")
                var topContributors = Array(contributors.prefix(4))
                
                // Download and set Avatars for the top 4 contributor
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
        IntentConfiguration(kind: kind,
                            intent: SelectRepoIntent.self,
                            provider: LargeWidgetProvider()) { entry in
            LargeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Maximum Info")
        .description("Repo Stats + the top 4 contributors!")
        .supportedFamilies([.systemLarge])
    }
}

struct LargeWidget_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetEntryView(entry: LargeWidgetEntry(date: .now, repo: Repository.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
