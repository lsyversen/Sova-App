//
//  LocationManager.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/22/24.
//

import CoreLocation

enum RegionType: String {
    case pickup
    case dropoff
}

class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Helpers
    
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    @Published var userLocation: CLLocation?
    @Published var didEnterPickupRegion = false
    @Published var didEnterDropoffRegion = false
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Helpers
    
    private func createCustomRegion(withType type: RegionType, coordinates: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: type.rawValue)
        locationManager.startMonitoring(for: region)
    }
    
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        if region.identifier == RegionType.pickup.rawValue {
            print("DEBUG: Did start montioring pick up region \(region)")
        }
        
        if region.identifier == RegionType.dropoff.rawValue {
            print("DEBUG: Did start montioring destination region \(region)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == RegionType.pickup.rawValue {
            print("DEBUG: Did enter region..")
            didEnterPickupRegion = true
        }
        
        if region.identifier == RegionType.dropoff.rawValue {
            print("DEBUG: Did start montioring destination region \(region)")
            didEnterDropoffRegion = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == RegionType.pickup.rawValue {
            print("DEBUG: Did exit pickup region")
            didEnterPickupRegion = false
        }
        
        if region.identifier == RegionType.dropoff.rawValue {
            didEnterDropoffRegion = false
        }
    }
}

