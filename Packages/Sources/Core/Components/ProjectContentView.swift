//
//  ProjectContentView.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import SwiftUI

struct ProjectContentView: View {
    let projects: [Project]
    let isLoading: Bool
    let onProjectTapped: (Project) -> Void
    let onAddProjectTapped: () -> Void
    
    var body: some View {
        Group {
            if isLoading {
                ProjectLoadingView()
            } else if projects.isEmpty {
                ProjectEmptyStateView(onAddProjectTapped: onAddProjectTapped)
            } else {
                ProjectListView(projects: projects, onProjectTapped: onProjectTapped)
            }
        }
        .background(Color(.systemBackground))
    }
}

struct ProjectLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Loading projects...")
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
}

struct ProjectEmptyStateView: View {
    let onAddProjectTapped: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "folder")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Add New Project")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Button(action: onAddProjectTapped) {
                    Text("Create Project")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .cornerRadius(25)
                }
            }
            
            Spacer()
        }
    }
}

struct ProjectListView: View {
    let projects: [Project]
    let onProjectTapped: (Project) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(projects) { project in
                    ProjectCard(project: project) {
                        onProjectTapped(project)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ProjectContentView(
        projects: Project.sampleProjects,
        isLoading: false,
        onProjectTapped: { _ in },
        onAddProjectTapped: { }
    )
}
