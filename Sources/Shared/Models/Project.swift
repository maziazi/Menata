//
//  Project.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import Foundation

struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var selectedRoomId: String?
    let createdDate: Date
    var lastModified: Date
    var thumbnailData: Data?
    
    var selectedRoom: RoomCaptured? {
        get {
            guard let roomId = selectedRoomId else { return nil }
            return RoomCaptured.availableRooms.first { $0.id.uuidString == roomId }
        }
        set {
            selectedRoomId = newValue?.id.uuidString
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case selectedRoomId
        case createdDate
        case lastModified
        case thumbnailData
    }
    
    init(id: UUID = UUID(), name: String, selectedRoomId: String? = nil, selectedRoom: RoomCaptured? = nil) {
        self.id = id
        self.name = name
        self.selectedRoomId = selectedRoomId
        self.createdDate = Date()
        self.lastModified = Date()
        
        if let room = selectedRoom {
            self.selectedRoomId = room.id.uuidString
        }
    }
    
    var displayName: String {
        return name.isEmpty ? "Untitled Project" : name
    }
    
    var hasRoom: Bool {
        return selectedRoomId != nil
    }
}
