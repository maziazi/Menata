//
//  RoomData.swift
//  Menata
//
//  Created by Muhamad Azis on 17/06/25.
//

import Foundation

struct RoomData {
    static let availableRooms = [
        "Living Room",
        "Kitchen",
        "Bedroom",
        "Bathroom",
        "Office",
        "Dining Room",
        "Garage",
        "Basement",
        "Attic",
        "Hallway"
    ]
    
    static let roomCategories: [String: [String]] = [
        "Main Rooms": ["Living Room", "Kitchen", "Bedroom", "Bathroom"],
        "Additional Rooms": ["Office", "Dining Room", "Garage"],
        "Other Spaces": ["Basement", "Attic", "Hallway"]
    ]
}
