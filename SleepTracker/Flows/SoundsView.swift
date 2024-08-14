//
//  SoundsView.swift
//  SleepTracker
//
//  Created by Liam Syversen on 8/8/24.
//
import SwiftUI

struct SoundsView: View {
    @State private var selectedTab = 0
    let tabs = ["Favorites", "White Noise", "Music", "Colored Noise", "Weather", "Premium"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Sounds")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Spacer()
            }
            .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Text(tabs[index])
                            .foregroundColor(selectedTab == index ? .white : .gray)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(selectedTab == index ? Color.blue : Color.clear)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedTab = index
                            }
                    }
                }
                .padding(.horizontal)
            }
            
            TabView(selection: $selectedTab) {
                FavoritesView().tag(0)
                WhiteNoiseView().tag(1)
                MusicView().tag(2)
                ColoredNoiseView().tag(3)
                WeatherView().tag(4)
                PremiumView().tag(5)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(
            LinearGradient(colors: [.primaryTextColor, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

struct FavoritesView: View {
    var body: some View {
        Text("Favorites")
            .foregroundColor(.white)
    }
}

struct WhiteNoiseView: View {
    var body: some View {
        Text("White Noise")
            .foregroundColor(.white)
    }
}

struct MusicView: View {
    var body: some View {
        Text("Music")
            .foregroundColor(.white)
    }
}

struct ColoredNoiseView: View {
    var body: some View {
        Text("Colored Noise")
            .foregroundColor(.white)
    }
}

struct WeatherView: View {
    var body: some View {
        Text("Weather")
            .foregroundColor(.white)
    }
}

struct PremiumView: View {
    var body: some View {
        Text("Premium")
            .foregroundColor(.white)
    }
}

#Preview {
    SoundsView()
}
