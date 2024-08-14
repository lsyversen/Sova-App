//
//  MapViewActionButton.swift
//  SleepTracker
//
//  Created by Liam Syversen on 7/22/24.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var state: MapViewState
    @Binding var showSideMenu: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState()
            }
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.title3)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func imageNameForState(state: MapViewState) -> String {
        switch state {
        case .searchingForLocation,
                .locationSelected,
                .tripAccepted,
                .tripRequested,
                .tripCompleted,
                .polylineAdded:
            return "arrow.left"
        case .noInput, .tripCancelled:
            return "line.3.horizontal"
        default:
            return "line.3.horizontal"
        }
    }
    
    func actionForState() {
        switch state {
        case .noInput:
            showSideMenu.toggle()
        case .searchingForLocation:
            state = .noInput
        case .locationSelected, .polylineAdded:
            state = .noInput
        case .tripRequested:
            state = .noInput
        default: break
        }
    }
}

