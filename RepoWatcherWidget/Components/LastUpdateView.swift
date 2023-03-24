//
//  LastUpdateView.swift
//  RepoWatcher
//
//  Created by Daniel Berezhnoy on 3/6/23.
//

import WidgetKit
import SwiftUI

struct LastUpdateView: View {
    let repo: Repository
    
    var body: some View {
        VStack {
            repoName
            daysSinceUpdated
            daysAgo
        }
        .padding()
    }
    
    var repoName: some View {
        Text(repo.name)
            .fontWeight(.semibold)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
    }
    
    var daysSinceUpdated: some View {
        ZStack {
            if updatedToday {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green)
                    .padding(5)
            } else {
                Text("\(repo.daysSinceLastActivity)")
                    .font(.system(size: 75, weight: .bold))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundColor(dynamicColor)
            }
        }
    }
    
    var daysAgo: some View {
        ZStack {
            if updatedToday {
                Text("Updated Today")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else {
                Text("days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var avatarData: UIImage {
        (UIImage(data: repo.avatarData) ?? UIImage(named: "avatar"))!
    }
    
    var dynamicColor: Color {
        if repo.daysSinceLastActivity > 90 {
            return .pink
            
        } else if repo.daysSinceLastActivity > 30 {
            return .yellow
            
        } else {
            return .green
        }
    }
    
    var updatedToday: Bool {
        repo.daysSinceLastActivity < 1
    }
    
    init(for repo: Repository) {
        self.repo = repo
    }
}

struct LastUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        LastUpdateView(for: Repository.placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
