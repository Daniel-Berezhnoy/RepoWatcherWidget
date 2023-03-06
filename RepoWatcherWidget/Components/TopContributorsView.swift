//
//  TopContributorsView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daniel Berezhnoy on 3/5/23.
//

import SwiftUI
import WidgetKit

struct TopContributorsView: View {
    
    let gridColumns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            title
            grid
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
            ForEach(0 ..< 4) { contributor in
                contributorRow
            }
        }
    }
    
    var contributorRow: some View {
        HStack {
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .foregroundStyle(.gray.opacity(0.6))
            
            VStack(alignment: .leading) {
                
                Text("Daniel")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Text("192")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TopContributorsView_Previews: PreviewProvider {
    static var previews: some View {
        TopContributorsView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
