//
//  ProjectViewModel.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import Foundation
import SwiftUI

@MainActor
class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingAddProject = false
    
    init() {
        loadProjects()
    }
    
    func addProject(name: String, selectedRooms: Set<String>) {
        let newProject = Project(
            name: name.isEmpty ? generateDefaultName() : name,
            rooms: Array(selectedRooms)
        )
        projects.append(newProject)
        saveProjects()
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        saveProjects()
    }
    
    func updateProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
            saveProjects()
        }
    }
    
    private func generateDefaultName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return "Project \(formatter.string(from: Date()))"
    }
    
    private func loadProjects() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.projects = Project.sampleProjects
            self.isLoading = false
        }
    }
    
    private func saveProjects() {
        if let encoded = try? JSONEncoder().encode(projects) {
            UserDefaults.standard.set(encoded, forKey: "SavedProjects")
        }
    }
}
