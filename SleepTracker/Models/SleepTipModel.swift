//
//  SleepTipModel.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import Foundation

/// A simple model for sleep suggestions/tips
struct SleepTipModel {
    let title: String
    let subtitle: String
    let icon: String
    let details: [SleepTipDetails]?
}

/// A simple model for a sleep suggestion/tip details with title and details
struct SleepTipDetails {
    let title: String
    let details: String
}
