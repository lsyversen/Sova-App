//
//  User.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/26/24.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation
import Firebase

struct User: Codable {
    @DocumentID var id: String?
    let fullname: String
    let email: String
    var phoneNumber: String?
    var profileImageUrl: String?
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
    var accountType: AccountType
    var coordinates: GeoPoint
    var isActive: Bool
    
    var uid: String { return id ?? "" }
}

struct SavedLocation: Codable {
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
}

enum AccountType: Int, Codable {
    case passenger
    case driver
}

