//
//  Project.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import Foundation

struct Project: Identifiable, Codable {
    let id: UUID
    let name: String
    let rooms: [String]
    let createdDate: Date
    var description: String?
    var thumbnailURL: URL?
    
    init(id: UUID = UUID(), name: String, rooms: [String], createdDate: Date = Date(), description: String? = nil, thumbnailURL: URL? = nil) {
        self.id = id
        self.name = name
        self.rooms = rooms
        self.createdDate = createdDate
        self.description = description
        self.thumbnailURL = thumbnailURL
    }
}

extension Project {
    static let sampleProjects: [Project] = [
        Project(
            name: "House Project",
            rooms: ["Living Room", "Kitchen", "Bedroom"],
            createdDate: Date().addingTimeInterval(-86400)
        ),
        Project(
            name: "Office Scan",
            rooms: ["Meeting Room", "Office Space"],
            createdDate: Date().addingTimeInterval(-172800)
        )
    ]
}
