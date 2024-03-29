//
//  RepoStatsView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daniel Berezhnoy on 3/4/23.
//

import SwiftUI
import WidgetKit

struct RepoStatsView: View {
    let repo: Repository
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                headline
                description
                Spacer()
                stats
            }
            Spacer()
            daysSinceUpdated
        }
        .padding()
    }
    
    var headline: some View {
        HStack {
            Image(uiImage: avatar)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .padding(.trailing, 2)
            
            Text(repo.name)
                .font(.title2)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
    }
    
    var description: some View {
        Text("\(repo.description)")
            .font(.caption)
            .foregroundColor(.secondary)
            .minimumScaleFactor(0.85)
            .padding(.leading, 2)
    }
    
    var stats: some View {
        HStack(spacing: 12) {
            StatLabel(value: repo.watchers, systemImageName: "star.fill")
            StatLabel(value: repo.forks , systemImageName: "tuningfork")
            
            if repo.hasIssues {
                StatLabel(value: repo.openIssues,
                          systemImageName: "exclamationmark.triangle.fill")
            }
        }
    }
    
    var daysSinceUpdated: some View {
        ZStack {
            if updatedToday {
                VStack {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 60)
                        .padding(.bottom)
                    
                    Text("Updated Today")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
            } else {
                VStack {
                    Text("\(repo.daysSinceLastActivity)")
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
        }
    }
    
    var avatar: UIImage {
        UIImage(data: repo.avatarData) ?? UIImage(named: "avatar")!
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

struct RepoStatsView_Previews: PreviewProvider {
    static var previews: some View {
        RepoStatsView(for: Repository.placeholder)
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
