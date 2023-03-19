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
    let dateFormatter = ISO8601DateFormatter()
    
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
                Text("\(daysSinceLastActivity)")
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
        if daysSinceLastActivity > 90 {
            return .pink
            
        } else if daysSinceLastActivity > 30 {
            return .yellow
            
        } else {
            return .green
        }
    }
    
    var updatedToday: Bool {
        daysSinceLastActivity < 1
    }
    
    var daysSinceLastActivity: Int {
        calculateDaysSinceLastActivity(since: repo.pushedAt)
    }
    
    func calculateDaysSinceLastActivity(since dateString: String) -> Int {
        
        let lastActivityDate = dateFormatter.date(from: dateString) ?? .now
        let timeSinceLastActivity = Calendar.current.dateComponents([.day],
                                                                    from: lastActivityDate,
                                                                    to: .now)
        return timeSinceLastActivity.day ?? 0
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
