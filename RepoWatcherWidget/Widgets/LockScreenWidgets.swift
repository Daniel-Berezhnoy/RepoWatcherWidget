//
//  LockScreenWidgets.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/24/23.
//

import WidgetKit
import SwiftUI

struct LockScreenWidgetsProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> LockScreenWidgetsEntry {
        LockScreenWidgetsEntry(date: Date(), repo: Repository.placeholder)
    }
    
    func getSnapshot(for configuration: SelectRepoIntent, in context: Context, completion: @escaping (LockScreenWidgetsEntry) -> Void) {
        let entry = LockScreenWidgetsEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectRepoIntent, in context: Context, completion: @escaping (Timeline<LockScreenWidgetsEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds
            
            do {
                let repoToShow = RepoURL.prefix + (configuration.repo ?? "Daniel-Berezhnoy/SwiftUIBuddy")
                var repo = try await NetworkManager.shared.getRepo(from: repoToShow)
                
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData
                
                let entry = LockScreenWidgetsEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                
                completion(timeline)
            } catch {
                print("❌ ERROR: \(error.localizedDescription)")
            }
        }
    }
}

struct LockScreenWidgetsEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct LockScreenWidgetsEntryView: View {
    
    @Environment(\.widgetFamily) var family
    var entry: LockScreenWidgetsEntry
    
    var body: some View {
        switch family {
                
            case .accessoryInline:
                inlineWidget
                
            case .accessoryCircular:
                circularWidget
                
            case .accessoryRectangular:
                rectangularWidget

            case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
                EmptyView()
                
            @unknown default:
                EmptyView()
        }
    }
    
    var inlineWidget: some View {
        Text("\(entry.repo.name) - \(entry.repo.daysSinceLastActivity)")
    }
    
    var circularWidget: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            VStack {
                Text("\(entry.repo.daysSinceLastActivity)")
                    .font(.headline)
                
                Text("days")
                    .font(.caption)
            }
        }
    }
    
    var rectangularWidget: some View {
        VStack(alignment: .leading) {
            
            Text(entry.repo.name)
                .font(.headline)
            
            Text("\(entry.repo.daysSinceLastActivity) days")
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                
                Text("\(entry.repo.watchers)")
                
                Image(systemName: "tuningfork")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                
                Text("\(entry.repo.forks)")
                
                if entry.repo.hasIssues {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                    
                    Text("\(entry.repo.openIssues)")
                }
            }
            .font(.caption)
        }
    }
}

struct LockScreenWidgets: Widget {
    let kind: String = "LockScreenWidgets"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: SelectRepoIntent.self,
                            provider: LockScreenWidgetsProvider()) { entry in
            LockScreenWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Last Update")
        .description("See how many days ago the repository was updated.")
        .supportedFamilies([.accessoryInline, .accessoryRectangular, .accessoryCircular])
    }
}

struct LockScreenWidgets_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetsEntryView(entry: LockScreenWidgetsEntry(date: .now,
                                                                 repo: Repository.placeholder))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
