//
//  SettingsRowViewTime.swift
//  SleepTracker
//
//  Created by Liam Syversen on 8/7/24.
//

import SwiftUI

struct SettingsRowViewTime: View {
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
    SettingsRowViewTime(imageName: "alarm", title: "Smart Alarm", tintColor: Color.primaryTextColor)
}
