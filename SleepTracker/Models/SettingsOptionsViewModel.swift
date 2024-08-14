//
//  SettingsOptionsViewModel.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/26/24.
//

import SwiftUI

protocol SettingsViewModelProtocol: CaseIterable {
    var title: String { get }
    var imageName: String { get }
    var imageBackgroundColor: UIColor { get }
}

enum SettingOptionsViewModel: Int, SettingsViewModelProtocol {
    case notifications
    case paymentMethods
    
    var title: String {
        switch self {
        case .notifications: return "Notifications"
        case .paymentMethods: return "Payment Methods"
        }
    }
    
    var imageName: String {
        switch self {
        case .notifications: return "bell.circle.fill"
        case .paymentMethods: return "creditcard.circle.fill"
        }
    }
    
    var imageBackgroundColor: UIColor {
        switch self {
        case .notifications: return .systemPurple
        case .paymentMethods: return .systemBlue
        }
    }
}

enum AccountOptionsViewModel: Int, SettingsViewModelProtocol {
    case makeMoneyDriving
    case earnings
    case signout
    
    var title: String {
        switch self {
        case .makeMoneyDriving: return "Make money driving"
        case .earnings: return "Your earnings"
        case .signout: return "Sign out"
        }
    }
    
    var imageName: String {
        switch self {
        case .makeMoneyDriving, .earnings: return "dollarsign.square.fill"
        case .signout: return "arrow.left.square.fill"
        }
    }
    
    var imageBackgroundColor: UIColor {
        switch self {
        case .makeMoneyDriving, .earnings: return .systemGreen
        case .signout: return .systemRed
        }
    }
}

