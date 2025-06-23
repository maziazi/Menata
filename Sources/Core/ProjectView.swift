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
            ProjectHeaderView {
                viewModel.showingCreateProject = true
            }
            
            mainContentView
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $viewModel.showingCreateProject) {
            CreateProjectSheet(
                availableRooms: viewModel.availableRooms
            ) { name, room in
                viewModel.createProject(name: name, selectedRoom: room)
            }
        }
        .sheet(item: $viewModel.selectedProject) { project in
            ProjectEditView(
                project: project,
                onSave: { updatedProject in
                    viewModel.updateProject(updatedProject)
                },
                onDelete: { projectToDelete in
                    viewModel.deleteProject(projectToDelete)
                }
            )
        }
        .refreshable {
            viewModel.refreshData()
        }
        .onAppear {
            viewModel.refreshData()
        }
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        if viewModel.isLoading {
            ProjectLoadingView()
        } else if viewModel.projects.isEmpty {
            ProjectEmptyStateView {
                viewModel.showingCreateProject = true
            }
        } else {
            ProjectGridView(
                projects: viewModel.projects,
                availableRooms: viewModel.availableRooms
            ) { project in
                viewModel.selectedProject = project
            } onDeleteProject: { project in
                viewModel.deleteProject(project)
            }
        }
    }
}

#Preview {
    ProjectView()
}
