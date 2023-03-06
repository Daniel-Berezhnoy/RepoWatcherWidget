//
//  TopContributorsView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daniel Berezhnoy on 3/5/23.
//

import SwiftUI
import WidgetKit

struct TopContributorsView: View {
    let repo: Repository
    
    var body: some View {
        VStack {
            title
            grid
            Spacer()
        }
        .padding()
    }
    
    var title: some View {
        HStack {
            Text("Top Contributors")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.bottom, 8)
    }
    
    var grid: some View {
        LazyVGrid(columns: gridColumns, alignment: .leading, spacing: 20) {
            ForEach(repo.contributors, id: \.login) { contributor in
                
                ContributorRow(username: contributor.login,
                               avatarData: contributor.avatarData,
                               contributions: contributor.contributions)
            }
        }
    }
    
    let gridColumns = Array(repeating: GridItem(.flexible()), count: 2)
    
    init(for repo: Repository) {
        self.repo = repo
    }
}

struct TopContributorsView_Previews: PreviewProvider {
    static var previews: some View {
        TopContributorsView(for: Repository.placeholder)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct ContributorRow: View {
    
    let username: String
    let avatarData: Data
    let contributions: Int
    
    var body: some View {
        HStack {
            avatar
            
            VStack(alignment: .leading) {
                name
                contributionsCount
            }
        }
    }
    
    var avatar: some View {
        Image(uiImage: UIImage(data: avatarData) ?? UIImage(named: "avatar")!)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 44, height: 44)
    }
    
    var name: some View {
        Text(username)
            .font(.caption)
            .fontWeight(.medium)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }
    
    var contributionsCount: some View {
        Text("\(contributions)")
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}
