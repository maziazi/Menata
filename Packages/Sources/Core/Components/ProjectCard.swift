//
//  ProjectCard.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import SwiftUI

struct ProjectCard: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                ProjectCardHeader(project: project)
                ProjectCardInfo(project: project)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Card Components
private struct ProjectCardHeader: View {
    let project: Project
    
    var body: some View {
        HStack {
            Text(project.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer()
            
            Text(project.createdDate, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct ProjectCardInfo: View {
    let project: Project
    
    var body: some View {
        HStack {
            Image(systemName: "house.fill")
                .foregroundColor(.orange)
            
            Text("\(project.rooms.count) rooms")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    VStack {
        ForEach(Project.sampleProjects) { project in
            ProjectCard(project: project) {
                print("Tapped: \(project.name)")
            }
        }
    }
    .padding()
    .background(Color(.systemGray6))
}
