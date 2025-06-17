//
//  CaptureData.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import Foundation
import SwiftUI

// MARK: - Room Model
struct RoomCaptured: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let fileName: String
    let usdzFileName: String
    let captureDate: Date
    let fileSize: String
    
    var usdzURL: URL? {
        Bundle.main.url(forResource: usdzFileName, withExtension: "usdz")
    }
    
    var isAvailable: Bool {
        return usdzURL != nil
    }
}

// MARK: - Object Model
struct ObjectCaptured: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let fileName: String
    let usdzFileName: String
    let captureDate: Date
    let fileSize: String
    
    var usdzURL: URL? {
        Bundle.main.url(forResource: usdzFileName, withExtension: "usdz")
    }
    
    var isAvailable: Bool {
        return usdzURL != nil
    }
}

// MARK: - Real Data (Sesuai File yang Ada)
extension RoomCaptured {
    static let availableRooms: [RoomCaptured] = [
        RoomCaptured(
            name: "Room 1",
            fileName: "room1_scan",
            usdzFileName: "Room1",
            captureDate: Date().addingTimeInterval(-86400), // 1 day ago
            fileSize: getFileSize(fileName: "Room1")
        ),
        RoomCaptured(
            name: "Room 2",
            fileName: "room2_scan",
            usdzFileName: "Room2",
            captureDate: Date().addingTimeInterval(-172800), // 2 days ago
            fileSize: getFileSize(fileName: "Room")
        )
    ]
    
    private static func getFileSize(fileName: String) -> String {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "usdz"),
              let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let fileSize = attributes[.size] as? NSNumber else {
            return "Unknown"
        }
        
        let sizeInMB = Double(fileSize.intValue) / (1024 * 1024)
        return String(format: "%.1f MB", sizeInMB)
    }
}

extension ObjectCaptured {
    static let availableObjects: [ObjectCaptured] = [
        ObjectCaptured(
            name: "Kursi",
            fileName: "kursi_scan",
            usdzFileName: "Kursi",
            captureDate: Date().addingTimeInterval(-43200), // 12 hours ago
            fileSize: getFileSize(fileName: "Kursi")
        ),
        ObjectCaptured(
            name: "Vanesh",
            fileName: "vanesh_scan",
            usdzFileName: "Vanesh",
            captureDate: Date().addingTimeInterval(-86400), // 1 day ago
            fileSize: getFileSize(fileName: "Vanesh")
        ),
        ObjectCaptured(
            name: "Kursi Kotak",
            fileName: "kursi_kotak_scan",
            usdzFileName: "KursiKotak",
            captureDate: Date().addingTimeInterval(-129600), // 1.5 days ago
            fileSize: getFileSize(fileName: "KursiKotak")
        ),
        ObjectCaptured(
            name: "Kursi Kotak 1",
            fileName: "kursi_kotak1_scan",
            usdzFileName: "KursiKotak1",
            captureDate: Date().addingTimeInterval(-172800), // 2 days ago
            fileSize: getFileSize(fileName: "KursiKoTAK1")
        )
    ]
    
    private static func getFileSize(fileName: String) -> String {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "usdz"),
              let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let fileSize = attributes[.size] as? NSNumber else {
            return "Unknown"
        }
        
        let sizeInMB = Double(fileSize.intValue) / (1024 * 1024)
        return String(format: "%.1f MB", sizeInMB)
    }
}
