//
//  ProjectGridView.swift
//  Menata
//
//  Created by Muhamad Azis on 18/06/25.
//

import SwiftUI

struct ProjectGridView: View {
    let projects: [Project]
    let availableRooms: [RoomCaptured]
    let onProjectTapped: (Project) -> Void
    let onDeleteProject: (Project) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(projects) { project in
                    ProjectCard(
                        project: project,
                        room: getRoomForProject(project)
                    ) {
                        onProjectTapped(project)
                    } onDelete: {
                        onDeleteProject(project)
                    }
                }
            }
            .padding()
        }
    }
    
    private func getRoomForProject(_ project: Project) -> RoomCaptured? {
        return project.selectedRoom
    }
}

struct ProjectCard: View {
    let project: Project
    let room: RoomCaptured?
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                ProjectThumbnailView(project: project, room: room)
                
                ProjectCardInfo(project: project, room: room)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    struct ProjectContextMenu: View {
        let project: Project
        let onEdit: () -> Void
        let onDelete: () -> Void
        
        var body: some View {
            Button(action: onEdit) {
                Label("Open Project", systemImage: "arrow.right.circle")
            }
            
            Button(action: onEdit) {
                Label("Edit Project", systemImage: "pencil")
            }
            
            Divider()
            
            Button(role: .destructive, action: onDelete) {
                Label("Delete Project", systemImage: "trash")
            }
        }
    }
    
    
    struct ProjectThumbnailView: View {
        let project: Project
        let room: RoomCaptured?
        
        private var gradientColors: [Color] {
            if room != nil {
                return [Color.orange.opacity(0.8), Color.orange.opacity(0.4)]
            } else {
                return [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]
            }
        }
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 120)
                
                VStack(spacing: 8) {
                    if let room = room {
                        Image(systemName: "house.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text(room.name)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .lineLimit(1)
                    } else {
                        Image(systemName: "folder.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text("No Room")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                    }
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("AR")
                            .font(.caption2.bold())
                            .foregroundColor(.orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .padding(8)
                    
                    Spacer()
                }
            }
        }
    }
    
    struct ProjectCardInfo: View {
        let project: Project
        let room: RoomCaptured?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(project.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Text(project.createdDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let room = room {
                        Image(systemName: "house.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                if let room = room {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                        
                        Text("Room: \(room.name)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(room.fileSize)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundColor(.red)
                        
                        Text("No room selected")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
//#Preview {
//    ProjectGridView(
//        projects: Project.sampleProjects,
//        availableRooms: RoomCaptured.availableRooms,
//        onProjectTapped: { _ in },
//        onDeleteProject: { _ in }
//    )
//}
