//
//  RoomGridView.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import SwiftUI
import QuickLook

struct RoomGridView: View {
    let rooms: [RoomCaptured]
    @State private var selectedRoom: RoomCaptured?
    @State private var showingPreview = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(rooms, id: \.id) { room in
                    RoomCard(room: room) {
                        selectedRoom = room
                        showingPreview = true
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingPreview) {
            if let room = selectedRoom, let usdzURL = room.usdzURL {
                ARPreviewSheet(url: usdzURL, title: room.name)
            }
        }
    }
}

struct RoomCard: View {
    let room: RoomCaptured
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Room Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.orange.opacity(0.8), .orange.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 100)
                    
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("3D Room")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                    }
                }
                
                // Room Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(room.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(room.fileName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(room.fileSize)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Image(systemName: "cube.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RoomGridView(rooms: RoomCaptured.availableRooms.filter { $0.isAvailable })
}
