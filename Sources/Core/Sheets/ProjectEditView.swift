//
//  ProjectEditView.swift
//  Menata
//
//  Created by Muhamad Azis on 19/06/25.
//
import SwiftUI

struct ProjectEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editedProject: Project
    @State private var showingDeleteAlert = false
    @State private var showCombineView = false
    
    let onSave: (Project) -> Void
    let onDelete: (Project) -> Void
    
    init(project: Project, onSave: @escaping (Project) -> Void, onDelete: @escaping (Project) -> Void = { _ in }) {
        self._editedProject = State(initialValue: project)
        self.onSave = onSave
        self.onDelete = onDelete
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    ProjectThumbnailSection(project: editedProject)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ProjectNameEditSection(projectName: $editedProject.name)
                        
                        ProjectInfoSection(project: editedProject)
                        
                        Button(action: {
                            showCombineView = true
                        })
                        {
                            Text("Continue Edit")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ProjectEditToolbar(
                    onCancel: { dismiss() },
                    onSave: {
                        onSave(editedProject)
                        dismiss()
                    },
                    onDelete: {
                        showingDeleteAlert = true
                    }
                )
            }
        }
        .alert("Delete Project", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete") {
                onDelete(editedProject)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete '\(editedProject.displayName)'?\n\nThis action cannot be undone.")
        }
        .fullScreenCover(isPresented: $showCombineView) {
            CombineView()
        }
    }
}

struct ProjectThumbnailSection: View {
    let project: Project
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 200)
            
            VStack(spacing: 12) {
                if let room = project.selectedRoom {
                    Image(systemName: "house.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text(room.name)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    Text("3D Room Scan")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                } else {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    Text("No Room Selected")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    Text("Select a room to start")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding()
    }
}

struct ProjectNameEditSection: View {
    @Binding var projectName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Project Name")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("Enter project name", text: $projectName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.return)
            
            if projectName.isEmpty {
                Text("Project name cannot be empty")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
    }
}

struct ProjectInfoSection: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Project Information")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                InfoRow(
                    title: "Created",
                    value: project.createdDate.formatted(date: .abbreviated, time: .shortened)
                )
                
                InfoRow(
                    title: "Last Modified",
                    value: project.lastModified.formatted(date: .abbreviated, time: .shortened)
                )
                
                InfoRow(
                    title: "Project ID",
                    value: project.id.uuidString.prefix(8).uppercased() + "...",
                    valueColor: .secondary
                )
                
                Divider()
                
                if let room = project.selectedRoom {
                    InfoRow(title: "Room", value: room.name, valueColor: .primary)
                    InfoRow(title: "Room File", value: "\(room.usdzFileName).usdz", valueColor: .secondary)
                    InfoRow(title: "File Size", value: room.fileSize, valueColor: .secondary)
                    InfoRow(title: "Room Captured", value: room.captureDate.formatted(date: .abbreviated, time: .omitted), valueColor: .secondary)
                } else {
                    InfoRow(title: "Room", value: "Not selected", valueColor: .red)
                    InfoRow(title: "Status", value: "Incomplete", valueColor: .red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    let valueColor: Color
    
    init(title: String, value: String, valueColor: Color = .secondary) {
        self.title = title
        self.value = value
        self.valueColor = valueColor
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .foregroundColor(valueColor)
        }
    }
}

struct ProjectEditToolbar: ToolbarContent {
    let onCancel: () -> Void
    let onSave: () -> Void
    let onDelete: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel", action: onCancel)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 16) {
                Button("Delete", action: onDelete)
                    .foregroundColor(.red)
                    .font(.subheadline)
                
                Button("Save", action: onSave)
                    .fontWeight(.semibold)
                    .font(.subheadline)
            }
        }
    }
}

//#Preview {
//    ProjectEditView(
//        project: Project.sampleProjects.first!,
//        onSave: { _ in print("Project saved") },
//        onDelete: { _ in print("Project deleted") }
//    )
//}
