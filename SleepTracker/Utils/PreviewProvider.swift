//
//  PreviewProvider.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/26/24.
//

import SwiftUI
import MapKit
import Firebase

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}
/*
 let driverName: String
 let passengerName: String
 let driverImageUrl: String
 let passengerImageUrl: String?*/

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    let userLocation = CLLocation(latitude: 37.75, longitude: -122.432)
    
    let mockPassenger = User(id: NSUUID().uuidString,
                             fullname: "Stephan Dowless",
                             email: "test@gmail.com",
                             phoneNumber: nil,
                             profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/uberswiftui.appspot.com/o/profile_images%2F25278BB7-63BF-4278-9EBE-A6CD1EA6B584?alt=media&token=19419f9e-64bb-4f87-a5e7-d42d88113de5",
                             homeLocation: nil,
                             workLocation: nil,
                             accountType: .passenger,
                             coordinates: GeoPoint(latitude: 37.4, longitude: -122.1),
                             isActive: true)
    
    let mockDriver = User(id: NSUUID().uuidString,
                          fullname: "John Doe",
                          email: "johndoe@gmail.com",
                          phoneNumber: nil,
                          profileImageUrl: nil,
                          homeLocation: nil,
                          workLocation: nil,
                          accountType: .driver,
                          coordinates: GeoPoint(latitude: 37.41, longitude: -122.1),
                          isActive: false)
    
}
