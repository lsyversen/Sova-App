//
//  SleepSessionContentView.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI

/// Shows the sleep session flow
struct SleepSessionContentView: View {

    @EnvironmentObject var manager: DataManager
    @State private var zoomMoon: Bool = false
    @State private var snoozeZzz: Bool = false
    @State private var currentDate: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let moonSize: Double = 180.0

    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            LinearGradient(colors: [.primaryTextColor, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            HeaderTitleView
            MoonAnimationView
        }
        .onReceive(timer) { _ in currentDate = Date() }
        .onDisappear { timer.upstream.connect().cancel() }
    }

    /// Header title
    private var HeaderTitleView: some View {
        VStack(spacing: 40) {
            Text("Good night, ") + Text(manager.username).bold()
            VStack {
                Text(Date().string(format: "h:mm"))
                    .font(.system(size: 80, weight: .medium, design: .rounded))
                Text("Sleep Duration: ").font(.system(size: 12, weight: .light))
                + Text(manager.duration(from: currentDate)).font(.system(size: 12, weight: .medium))
            }
            Spacer()
        }.foregroundColor(.white)
    }

    /// Moon animation view
    private var MoonAnimationView: some View {
        ZStack {
            VStack {
                ForEach(0..<20, id: \.self) { _ in
                    AnimatedStar()
                }
            }

            ZzzTextLayer(x: snoozeZzz ? 30 : 20,
                         y: snoozeZzz ? -30 : 70,
                         rotation: snoozeZzz ? 0 : 40,
                         textSize: snoozeZzz ? 45.0 : 30.0)

            ZzzTextLayer(x: snoozeZzz ? 60 : 0,
                         y: snoozeZzz ? -80 : 30,
                         rotation: snoozeZzz ? 30 : 0,
                         textSize: snoozeZzz ? 35.0 : 40.0)

            ZzzTextLayer(x: snoozeZzz ? 30 : -40,
                         y: snoozeZzz ? -70 : 10,
                         rotation: snoozeZzz ? -20 : 0,
                         textSize: snoozeZzz ? 25.0 : 30.0)

            MoonIconView.overlay(
                LinearGradient(colors: [.backgroundColor, .purpleEndColor], startPoint: .topLeading, endPoint: .bottomTrailing).mask(MoonIconView)
            )
            .shadow(color: .purpleStartColor.opacity(0.3), radius: 20)
            .scaleEffect(zoomMoon ? 1.2 : 1.0).onAppear {
                withAnimation(.easeIn(duration: 2).repeatForever()) {
                    zoomMoon = true
                }
            }
        }
    }

    /// Moon icon
    private var MoonIconView: some View {
        Image(systemName: "moon.fill")
            .resizable().aspectRatio(contentMode: .fit)
            .frame(width: moonSize, height: moonSize)
    }

    /// Zzzz text layer
    private func ZzzTextLayer(x: Double, y: Double,
                              rotation: Double, textSize: Double) -> some View {
        Text("z").font(.system(size: textSize, weight: .medium))
            .foregroundColor(.white).offset(x: x, y: y)
            .rotationEffect(.degrees(rotation)).opacity(snoozeZzz ? 0.1 : 1.0)
            .onAppear {
                withAnimation(
                    .easeIn(duration: 3.2).delay(1.0)
                    .repeatForever(autoreverses: false)
                ) { snoozeZzz = true }
            }
    }
}

// MARK: - Animated Star
struct AnimatedStar: View {

    @State private var opacityStars: Bool = false

    // MARK: - Main rendering function
    var body: some View {
        let xPositionStart: Double = -(UIScreen.main.bounds.width/2.0)
        let xPositionEnd: Double = UIScreen.main.bounds.width/2.0
        let yPositionStart: Double = -(UIScreen.main.bounds.height/2.0)
        let yPositionEnd: Double = UIScreen.main.bounds.height/2.0
        return Image(systemName: "sparkle")
            .font(.system(size: Double.random(in: 2...20)))
            .rotationEffect(.degrees(opacityStars ? -10 : 30))
            .offset(x: Double.random(in: xPositionStart...xPositionEnd))
            .offset(y: Double.random(in: yPositionStart...yPositionEnd))
            .foregroundColor(.white).opacity(opacityStars ? 0.9 : 0.1)
            .onAppear {
                withAnimation(
                    .easeOut(duration: Double.random(in: 3...8))
                    .repeatForever(autoreverses: true)
                ) { opacityStars = true }
            }
    }
}

// MARK: - Preview UI
struct SleepSessionContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.isTrackingSleep = true
        return SleepSessionContentView().environmentObject(manager)
    }
}
