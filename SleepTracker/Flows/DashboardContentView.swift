//
//  DashboardContentView.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI

/// Main dashboard for the app
struct DashboardContentView: View {
    @State private var showSideMenu = false
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var manager: DataManager
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // MARK: - Main rendering function
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else {
                NavigationStack {
                    ZStack {
                        if showSideMenu {
                            SideMenuView()
                        }
                        GeometryReader { _ in
                            Color.backgroundColor.ignoresSafeArea().onTapGesture { hideKeyboard() }
                            VStack(spacing: UIDevice.current.regularSize ? 20 : -5) {
                                CustomHeaderView
                                SleepSuggestionsSection
                                MoodTrackingSection
                                Spacer()
                            }
                            DraggableOverlayView().environmentObject(manager)
                        }
                        .offset(x: showSideMenu ? 316 : 0)
                        .shadow(color: showSideMenu ? .black : .clear, radius: 10)
                
                    }
                    .onAppear {
                        showSideMenu = false
                    }
                }
            }
        }
        .animation(.spring(), value: showSideMenu)
        .fullScreenCover(item: $manager.fullScreenMode) { type in
            switch type {
            case .premium: PremiumView
            case .sleepAnalysis:
                SleepAnalysisContentView().environmentObject(manager)
            case .statistics:
                StatsContentView().environmentObject(manager)
            case .suggestions(index: let index):
                SuggestionsContentView(index: index).environmentObject(manager)
            }
        }
    }

    /// Custom header view
    private var CustomHeaderView: some View {
        HStack(spacing: 15) {
            MapViewActionButton(state: $mapState, showSideMenu: $showSideMenu)
            Spacer()
            Button { manager.fullScreenMode = .premium } label: {
                ZStack {
                    Image("sova-icon").resizable()
                }
            }
            .frame(width: 45, height: 45)
            .opacity(manager.isPremiumUser ? 0.2 : 1.0)
            .disabled(manager.isPremiumUser)
        }.padding(.horizontal).lineLimit(1)
    }

    // MARK: - Sleep Suggestions
    private var SleepSuggestionsSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Sleep Suggestions").font(.system(size: 20, weight: .semibold))
                Spacer()
            }.padding(.horizontal).padding(.top, 10).offset(y: 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<AppConfig.sleepSuggestions.count, id: \.self) { index in
                        SleepSuggestionTile(atIndex: index)
                    }
                }.padding()
            }
        }
    }

    /// Shows a sleep suggestion/tip tile
    private func SleepSuggestionTile(atIndex index: Int) -> some View {
        let suggestion = AppConfig.sleepSuggestions[index]
        return Button {
            manager.fullScreenMode = .suggestions(index: index)
        } label: {
            HStack(alignment: .top) {
                Image(systemName: suggestion.icon).font(.system(size: 20))
                VStack(alignment: .leading) {
                    Text(suggestion.title).font(.system(size: 16, weight: .medium))
                    Text(suggestion.subtitle).font(.system(size: 14, weight: .light))
                }.lineLimit(1)
            }.padding().background(
                Color.white.cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 10)
            )
        }
    }

    // MARK: - Mood Tracking
    private var MoodTrackingSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("How was your day?").font(.system(size: 20, weight: .semibold))
                Spacer()
                Button { manager.fullScreenMode = .statistics } label: {
                    HStack(spacing: 2) {
                        Text("Stats").font(.system(size: 16, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                    }.foregroundColor(.blue)
                }
            }.padding(.horizontal).padding(.top, 10)
            MoodTrackerView().environmentObject(manager)
        }
    }

    /// Premium flow view
    private var PremiumView: some View {
        PremiumContentView(title: "Premium Version", subtitle: "Unlock All Features", features: ["Remove Ads", "Unlimited Tracking", "Access to Statistics"], productIds: [AppConfig.premiumVersion]) {
            manager.fullScreenMode = nil
        } completion: { _, status, _ in
            DispatchQueue.main.async {
                if status == .success || status == .restored {
                    manager.isPremiumUser = true
                    Interstitial.shared.isPremiumUser = true
                }
                manager.fullScreenMode = nil
            }
        }
    }
}

// MARK: - Preview UI
struct DashboardContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Create instances of the necessary environment objects
        let manager = DataManager()
        let authViewModel = AuthViewModel()
        
        // Set up the initial state of these objects for the preview
        manager.isTrackingSleep = false
        
        return DashboardContentView()
            .environmentObject(manager)
            .environmentObject(authViewModel)
    }
}

