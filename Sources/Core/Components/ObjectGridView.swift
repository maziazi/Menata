//
//  ObjectGridView.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import SwiftUI
import QuickLook

struct ObjectGridView: View {
    let objects: [ObjectCaptured]
    @State private var selectedObject: ObjectCaptured?
    @State private var showingPreview = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(objects, id: \.id) { object in
                    ObjectCard(object: object) {
                        selectedObject = object
                        showingPreview = true
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingPreview) {
            if let object = selectedObject, let usdzURL = object.usdzURL {
                ARPreviewSheet(url: usdzURL, title: object.name)
            }
        }
    }
}

struct ObjectCard: View {
    let object: ObjectCaptured
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(gradientForObject(object.name))
                        .frame(width: 80, height: 80)
                    
                    VStack {
                        Image(systemName: iconForObject(object.name))
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("3D")
                            .font(.caption2.bold())
                            .foregroundColor(.white)
                    }
                }
                
                VStack(spacing: 2) {
                    Text(object.name)
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Text(object.fileSize)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func gradientForObject(_ name: String) -> LinearGradient {
        if name.lowercased().contains("kursi") {
            return LinearGradient(colors: [.blue.opacity(0.8), .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        } else {
            return LinearGradient(colors: [.purple.opacity(0.8), .purple.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        }
    }
    
    private func iconForObject(_ name: String) -> String {
        return name.lowercased().contains("kursi") ? "chair.fill" : "character.bubble.fill"
    }
}

#Preview {
    ObjectGridView(objects: ObjectCaptured.availableObjects.filter { $0.isAvailable })
}
