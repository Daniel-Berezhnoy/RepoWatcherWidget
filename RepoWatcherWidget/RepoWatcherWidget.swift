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
        RepoEntry(date: Date(), repo: Repository.placeholder)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RepoEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        //        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //            let entry = RepoEntry(date: entryDate)
        //            entries.append(entry)
        //        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
}

struct RepoWatcherWidgetEntryView : View {
    
    var entry: RepoEntry
    let dateFormatter = ISO8601DateFormatter()
    
    var body: some View {
        HStack {
            VStack {
                headline
                stats
            }
            Spacer()
            daysSinceUpdated
        }
        .padding()
    }
    
    var headline: some View {
        HStack {
            Circle()
                .frame(width: 50, height: 50)
            
            Text(entry.repo.name)
                .font(.title2)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .padding(.bottom)
    }
    
    var stats: some View {
        HStack(spacing: 12) {
            StatLabel(value: entry.repo.watchers, systemImageName: "star.fill")
            StatLabel(value: entry.repo.forks , systemImageName: "tuningfork")
            StatLabel(value: entry.repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
        }
        
    }
    
    var daysSinceUpdated: some View {
        VStack {
            Text("\(daysSinceLastActivity)")
                .font(.system(size: 75, weight: .bold))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .frame(width: 90)
                .foregroundColor(dynamicColor)
            
            Text("days ago")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    var daysSinceLastActivity: Int {
        calculateDaysSinceLastActivity(since: entry.repo.pushedAt)
    }
    
    var dynamicColor: Color {
        if daysSinceLastActivity > 90 {
            return .pink
            
        } else if daysSinceLastActivity > 30 {
            return .yellow
            
        } else {
            return .green
        }
    }
    
    func calculateDaysSinceLastActivity(since dateString: String) -> Int {
        
        let lastActivityDate = dateFormatter.date(from: dateString) ?? .now
        let timeSinceLastActivity = Calendar.current.dateComponents([.day],
                                                                    from: lastActivityDate,
                                                                    to: .now)
        return timeSinceLastActivity.day ?? 0
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
        RepoWatcherWidgetEntryView(entry: RepoEntry(date: Date(), repo: Repository.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

private struct StatLabel: View {
    
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
        } icon: {
            Image(systemName: systemImageName)
                .foregroundColor(.green)
        }
        .fontWeight(.medium)
    }
}
