//
//  MapViewState.swift
//  SleepTracker
//
//  Created by Liam Syversen on 8/3/24.
//
import Foundation

enum MapViewState: Int {
    case noInput
    case searchingForLocation
    case locationSelected
    case tripRequested
    case tripAccepted
    case driverArrived
    case tripInProgress
    case arrivedAtDestination
    case tripCompleted
    case tripCancelled
    case polylineAdded
}

