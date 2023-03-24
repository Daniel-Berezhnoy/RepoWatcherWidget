//
//  RepoWatcherWidgetBundle.swift
//  RepoWatcherWidget
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

import WidgetKit
import SwiftUI

@main
struct RepoWatcherWidgetBundle: WidgetBundle {
    var body: some Widget {
        SmallWidget()
        MediumWidget()
        LargeWidget()
        LockScreenWidgets()
    }
}
