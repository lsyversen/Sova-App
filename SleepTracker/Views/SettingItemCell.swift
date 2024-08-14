//
//  SettingItemCell.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/26/24.
//

import SwiftUI

struct SettingItemCell: View {
    let viewModel: any SettingsViewModelProtocol
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: viewModel.imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(Color(viewModel.imageBackgroundColor))
                .accentColor(.white)
            
            Text(viewModel.title)
                .font(.system(size: 15))
                .foregroundColor(Color.primaryTextColor)
        }
        .padding(4)
    }
}

struct SettingItemCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingItemCell(viewModel: SettingOptionsViewModel.paymentMethods)
    }
}

