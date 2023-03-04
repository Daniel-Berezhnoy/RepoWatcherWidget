//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), repo: Repository.placeholder, avatarData: Data())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: Repository.placeholder, avatarData: Data())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds
            
            do {
                let repo = try await NetworkManager.shared.getRepo(from: RepoURL.swiftUIBuddy)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                
                let entry = RepoEntry(date: .now, repo: repo, avatarData: avatarImageData)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                
                completion(timeline)
            } catch {
                print("❌ ERROR: \(error.localizedDescription)")
            }
        }
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let avatarData: Data
}

struct RepoWatcherWidgetEntryView: View {
    
    @Environment(\.widgetFamily) var family
    var entry: RepoEntry
    
    var body: some View {
        switch family {
                
            case .systemMedium:
                RepoMediumView(repo: entry.repo)
                
            case .systemLarge:
                VStack {
                    RepoMediumView(repo: entry.repo)
                    divider
                    RepoMediumView(repo: entry.repo)
                }
                
            case .systemSmall, .systemExtraLarge, .accessoryCorner, .accessoryCircular, .accessoryRectangular, .accessoryInline: EmptyView()
                
            @unknown default:
                EmptyView()
        }
    }
    
    var divider: some View {
        VStack(spacing: 0) {
            Divider()
            Divider()
        }
        .padding(.horizontal)
    }
}

struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RepoWatcherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct RepoWatcherWidget_Previews: PreviewProvider {
    static var previews: some View {
        RepoWatcherWidgetEntryView(entry: RepoEntry(date: Date(),
                                                    repo: Repository.placeholder,
                                                    avatarData: Data()))
        
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
