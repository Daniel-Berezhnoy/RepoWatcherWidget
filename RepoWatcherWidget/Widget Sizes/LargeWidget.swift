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
        <#code#>
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LargeWidgetEntry) -> Void) {
        <#code#>
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LargeWidgetEntry>) -> Void) {
        <#code#>
    }
}

struct LargeWidgetEntry: TimelineEntry {
    let date: Date
}
