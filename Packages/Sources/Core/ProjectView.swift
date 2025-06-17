//
//  ProjectView.swift
//  Menata
//
//  Created by Muhamad Azis on 16/06/25.
//

import SwiftUI

struct ProjectView: View {
    @StateObject private var viewModel = ProjectViewModel()
    
    var body: some View {
            VStack(spacing: 0) {
                ProjectHeaderView(onAddTapped: {
                    viewModel.showingAddProject = true
                })
                        
                ProjectContentView(
                    projects: viewModel.projects,
                    isLoading: viewModel.isLoading,
                    onProjectTapped: { project in
                        handleProjectTap(project)
                    },
                    onAddProjectTapped: {
                        viewModel.showingAddProject = true
                    }
                )
            }
    }
    private func handleProjectTap(_ project: Project) {
        print("Tapped project: \(project.name)")
    }
}

#Preview {
    ProjectView()
}
