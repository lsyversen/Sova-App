//
//  SIdeMenuView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/25/24.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 32) {
                    HStack {
                        Image("sova-icon")
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .padding(.bottom, 8)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sova")
                                .font(.system(size: 32, weight: .bold))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                
                // Option list
                VStack {
                    ForEach(SideMenuOptionViewModel.allCases, id: \.self) { option in
                        NavigationLink(value: option) {
                            SideMenuOptionView(viewModel: option)
                                .padding()
                        }
                    }
                }
                .navigationDestination(for: SideMenuOptionViewModel.self) { 
                    option in
                    switch option {
                    case .settings:
                        SettingsView()
                    case .trips:
                        StatsContentView()
                    case .wallet:
                        SoundsView()
                    }
                }
                Spacer()
            }
            .padding(.top, 32)
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
