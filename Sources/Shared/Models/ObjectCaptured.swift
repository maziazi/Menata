//
//  ObjecrCaptures.swift
//  Menata
//
//  Created by Muhamad Azis on 24/06/25.
//

import Foundation

struct ObjectCaptured: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let fileName: String
    let usdzFileName: String
    let captureDate: Date
    let fileSize: String
    let localURL: URL?
    
    // Backward compatibility untuk bundle resources
    var usdzURL: URL? {
        // Prioritaskan local file jika ada
        if let localURL = localURL, FileManager.default.fileExists(atPath: localURL.path) {
            return localURL
        }
        // Fallback ke bundle resource
        return Bundle.main.url(forResource: usdzFileName, withExtension: "usdz")
    }
    
    var isAvailable: Bool {
        return usdzURL != nil
    }
    
    // Initializer untuk file system
    init(name: String, fileName: String, usdzFileName: String, captureDate: Date, fileSize: String, localURL: URL?) {
        self.name = name
        self.fileName = fileName
        self.usdzFileName = usdzFileName
        self.captureDate = captureDate
        self.fileSize = fileSize
        self.localURL = localURL
    }
    
    // Initializer untuk backward compatibility (bundle resources)
    init(name: String, fileName: String, usdzFileName: String, captureDate: Date, fileSize: String) {
        self.name = name
        self.fileName = fileName
        self.usdzFileName = usdzFileName
        self.captureDate = captureDate
        self.fileSize = fileSize
        self.localURL = nil
    }
}

// MARK: - Static Data (Fallback)
extension ObjectCaptured {
    static var availableObjects: [ObjectCaptured] {
        // Ambil dari file system terlebih dahulu
        let fileSystemObjects = FileSystemManager.shared.getObjectsFromFileSystem()
        
        // Jika tidak ada di file system, gunakan fallback data
        if fileSystemObjects.isEmpty {
            return fallbackObjects
        }
        
        return fileSystemObjects
    }
    
    private static let fallbackObjects: [ObjectCaptured] = [
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
