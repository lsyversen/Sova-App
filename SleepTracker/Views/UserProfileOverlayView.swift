//
//  UserProfileOverlayView.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI
import Combine

/// Shows the user name and avatar overlay
struct UserProfileOverlayView: View {

    @EnvironmentObject var manager: DataManager
    @State private var isKeyboardVisible: Bool = false

    // MARK: - Main rendering function
    var body: some View {
        VStack {
            if !isKeyboardVisible { Spacer() }
            ZStack {
                Color.white.cornerRadius(36)
                VStack {
                    Text("Update Your Profile")
                        .font(.system(size: 25, weight: .semibold))
                    Text("Personalize with a new username & avatar ")
                        .font(.system(size: 14, weight: .light)).opacity(0.75)
                        .multilineTextAlignment(.center)
                    AvatarsCarousel.padding(.vertical, 5)
                    UsernameField.padding(.horizontal, 20)
                    Spacer()
                }.padding(.top, 20)
            }.frame(height: 225)
            if isKeyboardVisible { Spacer() }
        }
        .padding().padding(.bottom, isKeyboardVisible ? 0 : UIDevice.current.regularSize ? -33 : -12)
        .onReceive(Publishers.keyboardHeight) { height in
            withAnimation { isKeyboardVisible = height > 0 }
        }
    }

    /// Avatars carousel
    private var AvatarsCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Spacer(minLength: 0)
                ForEach(0..<AppConfig.avatars.count, id: \.self) { index in
                    Image(AppConfig.avatars[index])
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60).background(
                            Color.primaryTextColor.opacity(0.1).cornerRadius(15)
                        )
                        .opacity(manager.avatarName == AppConfig.avatars[index] ? 0.8 : 0.2)
                        .onTapGesture {
                            manager.avatarName = AppConfig.avatars[index]
                        }
                }
                Spacer(minLength: 0)
            }
        }
    }

    /// Username text field
    private var UsernameField: some View {
        TextField("Username", text: $manager.username)
            .padding(10).padding(.horizontal, 5).background(
                Color.primaryTextColor.opacity(0.08).cornerRadius(15)
            ).foregroundColor(.black).font(.system(size: 25, weight: .bold))
            .multilineTextAlignment(.center)
    }
}

// MARK: - Preview UI
struct UserProfileOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            UserProfileOverlayView().environmentObject(DataManager())
        }
    }
}
