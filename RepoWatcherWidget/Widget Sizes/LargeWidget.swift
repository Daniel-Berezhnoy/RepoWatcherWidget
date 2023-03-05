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
        LargeWidgetEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LargeWidgetEntry) -> Void) {
        let entry = LargeWidgetEntry(date: .now)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LargeWidgetEntry>) -> Void) {
        
        let nextUpdate = Date().addingTimeInterval(43_200) // 12 hours = 43,200 seconds
        
        let entry = LargeWidgetEntry(date: .now)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
}

struct LargeWidgetEntry: TimelineEntry {
    let date: Date
}
