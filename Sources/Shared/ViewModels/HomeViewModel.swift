//
//  HomeViewModel.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var rooms: [RoomCaptured] = []
    @Published var objects: [ObjectCaptured] = []
    @Published var isLoading = false
    @Published var selectedSegment = 0
    
    init() {
        loadCapturedData()
    }
    
    func loadCapturedData() {
        isLoading = true
        
        // Simulate loading time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.loadAvailableRooms()
            self.loadAvailableObjects()
            self.isLoading = false
        }
    }
    
    private func loadAvailableRooms() {
        // Filter hanya rooms yang filenya benar-benar ada
        self.rooms = RoomCaptured.availableRooms.filter { $0.isAvailable }
        print("📁 Loaded \(self.rooms.count) rooms from resources")
        
        // Debug: Print available room files
        for room in self.rooms {
            print("✅ Room: \(room.name) - File: \(room.usdzFileName).usdz - Size: \(room.fileSize)")
        }
    }
    
    private func loadAvailableObjects() {
        // Filter hanya objects yang filenya benar-benar ada
        self.objects = ObjectCaptured.availableObjects.filter { $0.isAvailable }
        print("🎯 Loaded \(self.objects.count) objects from resources")
        
        // Debug: Print available object files
        for object in self.objects {
            print("✅ Object: \(object.name) - File: \(object.usdzFileName).usdz - Size: \(object.fileSize)")
        }
    }
    
    func refreshData() {
        loadCapturedData()
    }
    
    // MARK: - Helper Methods
    func getRoomCount() -> Int {
        return rooms.count
    }
    
    func getObjectCount() -> Int {
        return objects.count
    }
    
    func getTotalSize() -> String {
        let allItems = rooms.map { $0.fileSize } + objects.map { $0.fileSize }
        return allItems.joined(separator: ", ")
    }
}
