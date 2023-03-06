//
//  RepoWatcherWidgetBundle.swift
//  RepoWatcherWidget
//
//  Created by Daniel Berezhnoy on 3/1/23.
//

#error("Try to make the repo configurable from the User Side")
import WidgetKit
import SwiftUI

@main
struct RepoWatcherWidgetBundle: WidgetBundle {
    var body: some Widget {
        SmallWidget()
        MediumWidget()
        LargeWidget()
    }
}
