//
//  HomeView.swift
//  Menata
//
//  Created by Muhamad Azis on 16/06/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedSegment = 0
    private let segments = ["Room", "Object"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Home")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 10)
            .padding(.bottom, 15)
            .background(Color.orange)
            
            VStack(spacing: 0) {
                // Segmented Picker
                Picker("View Mode", selection: $selectedSegment) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        Text(segments[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 15)
                .padding(.bottom, 10)
                
                // Dynamic Content based on selection and data availability
                contentView
            }
            .background(Color(.systemBackground))
        }
        .refreshable {
            viewModel.refreshData()
        }
        .onAppear {
            viewModel.loadCapturedData()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if selectedSegment == 0 {
            // Room Section
            if viewModel.rooms.isEmpty {
                emptyStateView(
                    icon: "house",
                    title: "No Room has been scanned",
                    subtitle: "Looking for Room1.usdz and Room.usdz files",
                    type: "Room"
                )
            } else {
                roomContentView
            }
        } else {
            // Object Section
            if viewModel.objects.isEmpty {
                emptyStateView(
                    icon: "cube",
                    title: "No Object has been scanned",
                    subtitle: "Looking for Kursi.usdz, Vanesh.usdz, KursiKotak.usdz, KursiKoTAK1.usdz",
                    type: "Object"
                )
            } else {
                objectContentView
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                    .scaleEffect(1.2)
                
                Text("Scanning for captures...")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Looking for USDZ files in bundle")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Empty State View
    private func emptyStateView(icon: String, title: String, subtitle: String, type: String) -> some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Additional info about expected files
                VStack(spacing: 8) {
                    Text("Expected files:")
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 40)
                
                // Refresh button
                Button(action: {
                    viewModel.refreshData()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.orange)
                    .cornerRadius(20)
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Room Content View
    private var roomContentView: some View {
        VStack(spacing: 0) {
            // Stats header
            HStack {
                Image(systemName: "house.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                
                Text("Captured Rooms: \(viewModel.rooms.count)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Refresh") {
                    viewModel.refreshData()
                }
                .font(.caption)
                .foregroundColor(.orange)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            
            // Room Grid
            RoomGridView(rooms: viewModel.rooms)
        }
    }
    
    // MARK: - Object Content View
    private var objectContentView: some View {
        VStack(spacing: 0) {
            // Stats header
            HStack {
                Image(systemName: "cube.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                
                Text("Captured Objects: \(viewModel.objects.count)")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Refresh") {
                    viewModel.refreshData()
                }
                .font(.caption)
                .foregroundColor(.orange)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            
            // Object Grid
            ObjectGridView(objects: viewModel.objects)
        }
    }
}

#Preview {
    HomeView()
}
