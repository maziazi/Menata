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
    @Published var showingCreateProject = false
    @Published var selectedProject: Project?
    @Published var isLoading = false
    
    private let projectsKey = "SavedProjects"
    
    // Computed properties untuk akses data terbaru
    var availableRooms: [RoomCaptured] {
        RoomCaptured.availableRooms.filter { $0.isAvailable }
    }
    
    var availableObjects: [ObjectCaptured] {
        ObjectCaptured.availableObjects.filter { $0.isAvailable }
    }
    
    init() {
        loadProjects()
    }
    
    func loadProjects() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let data = UserDefaults.standard.data(forKey: self.projectsKey),
               let decodedProjects = try? JSONDecoder().decode([Project].self, from: data) {
                self.projects = decodedProjects
                
                // Update projects yang room-nya mungkin sudah tidak ada
                self.validateProjectRooms()
            }
            
            self.isLoading = false
            print("📁 Loaded \(self.projects.count) projects from storage")
        }
    }
    
    private func validateProjectRooms() {
        var hasChanges = false
        
        for (index, project) in projects.enumerated() {
            if let roomId = project.selectedRoomId {
                // Check apakah room masih tersedia
                let roomExists = availableRooms.contains { $0.id.uuidString == roomId }
                if !roomExists {
                    print("⚠️ Room for project '\(project.displayName)' no longer exists")
                    projects[index].selectedRoomId = nil
                    hasChanges = true
                }
            }
        }
        
        if hasChanges {
            saveProjects()
        }
    }
    
    func createProject(name: String, selectedRoom: RoomCaptured?) {
        let projectName = name.isEmpty ? generateDefaultName() : name
        
        let newProject = Project(
            name: projectName,
            selectedRoomId: selectedRoom?.id.uuidString,
            selectedRoom: selectedRoom
        )
        
        projects.append(newProject)
        saveProjects()
        
        print("🆕 Created project: \(projectName) with room: \(selectedRoom?.name ?? "None")")
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        
        saveProjects()
        
        if selectedProject?.id == project.id {
            selectedProject = nil
        }
        
        print("🗑️ Deleted project: '\(project.displayName)' (ID: \(project.id))")
        print("📊 Remaining projects: \(projects.count)")
    }
    
    func updateProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            var updatedProject = project
            updatedProject.lastModified = Date()
            projects[index] = updatedProject
            saveProjects()
            print("✏️ Updated project: \(project.displayName)")
        }
    }
    
    private func saveProjects() {
        do {
            let encoded = try JSONEncoder().encode(projects)
            UserDefaults.standard.set(encoded, forKey: projectsKey)
        } catch {
            print("❌ Failed to save projects: \(error)")
        }
    }
    
    private func generateDefaultName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' HH:mm"
        return "Project \(formatter.string(from: Date()))"
    }
    
    func refreshData() {
        loadProjects()
    }
    
    func getRoomById(_ roomId: String?) -> RoomCaptured? {
        guard let roomId = roomId else { return nil }
        return availableRooms.first { $0.id.uuidString == roomId }
    }
    
    func getProjectStats() -> (total: Int, withRooms: Int, withoutRooms: Int) {
        let total = projects.count
        let withRooms = projects.filter { $0.hasRoom }.count
        let withoutRooms = total - withRooms
        return (total, withRooms, withoutRooms)
    }
    
    func getDataSourceStats() -> (fileSystemRooms: Int, bundleRooms: Int, fileSystemObjects: Int, bundleObjects: Int) {
        let fileSystemRooms = availableRooms.filter { $0.localURL != nil }.count
        let bundleRooms = availableRooms.filter { $0.localURL == nil }.count
        let fileSystemObjects = availableObjects.filter { $0.localURL != nil }.count
        let bundleObjects = availableObjects.filter { $0.localURL == nil }.count
        
        return (fileSystemRooms, bundleRooms, fileSystemObjects, bundleObjects)
    }
}

