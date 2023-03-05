//
//  MediumWidget.swift
//  MediumWidget
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

import WidgetKit
import SwiftUI

struct MediumWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> MediumWidgetEntry {
        MediumWidgetEntry(date: Date(), repo: Repository.placeholder)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MediumWidgetEntry) -> ()) {
        let entry = MediumWidgetEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds
            
            do {
                var repo = try await NetworkManager.shared.getRepo(from: RepoURL.swiftUIBuddy)
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
    
    @Environment(\.widgetFamily) var family
    var entry: MediumWidgetEntry
    
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

struct MediumWidget: Widget {
    let kind: String = "MediumWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MediumWidgetProvider()) { entry in
            MediumWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct MediumWidget_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetEntryView(entry: MediumWidgetEntry(date: Date(), repo: Repository.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
