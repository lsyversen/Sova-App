//
//  SettingsRowView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 8/4/24.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(Color(.systemBlue))
            
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(tintColor)
                
        }
        .padding(4)
    }
}

#Preview {
    SettingsRowView(imageName: "alarm", title: "Smart Alarm", tintColor: Color.primaryTextColor)
}
