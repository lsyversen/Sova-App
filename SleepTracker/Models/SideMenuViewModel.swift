//
//  SideMenuViewModel.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/25/24.
//

import Foundation

enum SideMenuOptionViewModel: Int, CaseIterable, Identifiable {
    case trips
    case wallet
    case settings
    
    var title: String {
        switch self {
        case .trips: return "Sleep Analysis"
        case .wallet: return "Sounds"
        case .settings: return "Settings"
        }
    }
    
    var imageName: String {
        switch self {
        case .trips: return "chart.bar"
        case .wallet: return "music.note.list"
        case .settings: return "gear"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}
