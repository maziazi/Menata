//
//  AddProjectSheet.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import SwiftUI

struct AddProjectSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var projectName: String = ""
    @State private var selectedRooms: Set<String> = []
    
    let onSave: (String, Set<String>) -> Void
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                AddProjectSheetHeader()
                AddProjectSheetContent(
                    projectName: $projectName,
                    selectedRooms: $selectedRooms
                )
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                AddProjectSheetToolbar(
                    selectedRooms: selectedRooms,
                    onCancel: { dismiss() },
                    onSave: {
                        onSave(projectName, selectedRooms)
                        dismiss()
                    }
                )
            }
        }
    }
}

private struct AddProjectSheetHeader: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Project")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Select room to your project")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
    }
}

private struct AddProjectSheetContent: View {
    @Binding var projectName: String
    @Binding var selectedRooms: Set<String>
    
    let availableRooms = RoomData.availableRooms
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Project Name (Optional)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextField("Enter project name", text: $projectName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical)
                
                ForEach(availableRooms, id: \.self) { room in
                    RoomSelectionRow(
                        roomName: room,
                        isSelected: selectedRooms.contains(room)
                    ) {
                        if selectedRooms.contains(room) {
                            selectedRooms.remove(room)
                        } else {
                            selectedRooms.insert(room)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

private struct AddProjectSheetToolbar: ToolbarContent {
    let selectedRooms: Set<String>
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel", action: onCancel)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save", action: onSave)
                .disabled(selectedRooms.isEmpty)
        }
    }
}

#Preview {
    AddProjectSheet { name, rooms in
        print("Project: \(name), Rooms: \(rooms)")
    }
}
