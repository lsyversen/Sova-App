//
//  DraggableOverlayView.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI

/// A draggable view from bottom up to start/stop tracking sleep
struct DraggableOverlayView: View {

    @EnvironmentObject var manager: DataManager
    @State private var containerPadding: Double = UIScreen.main.bounds.height/(UIDevice.current.regularSize ? 1.25 : 1.22)
    private let halfScreenPadding = UIScreen.main.bounds.height/(UIDevice.current.regularSize ? 1.25 : 1.22)
    private let fullScreenPadding = UIScreen.main.bounds.height - 180.0

    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            SleepSessionContentView().environmentObject(manager)
                .opacity(manager.isTrackingSleep ? 1 : (1.0-((containerPadding * 1) / halfScreenPadding)))
            VStack(spacing: 0) {
                Spacer(minLength: containerPadding)
                OverlayShape().foregroundColor(.primaryTextColor)
                    .overlay(ContentContainer).gesture(CustomDragGesture)
            }.ignoresSafeArea().disabled(!canStartTracking)
        }
    }

    /// Handle drag gesture
    private var CustomDragGesture: some Gesture {
        DragGesture().onChanged { value in
            let updatedValue = containerPadding + value.translation.height
            if updatedValue < fullScreenPadding {
                containerPadding = updatedValue
            }
        }.onEnded { value in
            let updatedValue = containerPadding + value.translation.height
            let openDirection = value.translation.height < 0
            if openDirection {
                if updatedValue < halfScreenPadding {
                    withAnimation { containerPadding = 0 }
                    if manager.isTrackingSleep {
                        manager.endSleepSession()
                        manager.fullScreenMode = .sleepAnalysis
                    } else {
                        manager.startSleepSession()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation { containerPadding = halfScreenPadding }
                    }
                } else {
                    withAnimation { containerPadding = halfScreenPadding }
                }
            } else {
                withAnimation { containerPadding = halfScreenPadding }
            }
        }
    }

    /// Bottom content container
    private var ContentContainer: some View {
        VStack(spacing: UIDevice.current.regularSize ? 10 : 5) {
            Spacer()

            if canStartTracking {
                VStack(spacing: 0) {
                    Image(systemName: "chevron.up").resizable()
                    Image(systemName: "chevron.up").resizable()
                }
                .frame(width: UIDevice.current.regularSize ? 25 : 20)
                .frame(height: UIDevice.current.regularSize ? 22 : 18)
                .modifier(Shimmer()).frame(height: UIDevice.current.regularSize ? 35 : 25)

                Image(systemName: manager.isTrackingSleep ? "sunrise" : "moon.zzz")
                    .font(.system(size: UIDevice.current.regularSize ? 40 : 30))
                ZStack {
                    Text("Swipe up").bold()
                    + Text(" to ")
                    + Text(manager.isTrackingSleep ? "stop" : "start").bold()
                    + Text(" tracking")
                }.font(.system(size: 16))
            } else {
                Image(systemName: "crown.fill").font(.system(size: 32))
                VStack(spacing: 5) {
                    Text("Premium Version")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Purchase the premium version\nfor unlimited sleep tracking")
                        .font(.system(size: 14)).multilineTextAlignment(.center)
                        .opacity(0.75)
                }.fixedSize(horizontal: false, vertical: true)
            }

        }
        .foregroundColor(.white)
        .padding(.bottom, UIDevice.current.regularSize ? 30 : 20)
    }

    /// Verify if the user can start tracking their sleep
    private var canStartTracking: Bool {
        manager.isPremiumUser || manager.trackedSleepSessionsCount < AppConfig.freeSleepSessions
    }
}

// MARK: - Overlay shape
struct OverlayShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let archPoint = UIDevice.current.regularSize ? 40.0 : 35.0

        path.move(to: .init(x: 0, y: archPoint))
        path.addQuadCurve(to: .init(x: rect.width, y: archPoint), control: .init(x: rect.width/2.0, y: -archPoint))
        path.addLine(to: .init(x: rect.width, y: rect.height))
        path.addLine(to: .init(x: 0, y: rect.height))

        return path
    }
}

// MARK: - Gradient Animation
struct Shimmer: AnimatableModifier {

    @State private var position: CGFloat = 1

    // MARK: - Main rendering function
    func body(content: Content) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(white: 0.4), .white, Color(white: 0.4)]),
            startPoint: .init(x: 0, y: position - 0.7 * (1 - position)),
            endPoint: .init(x: 0, y: position + 0.7 * position)
        ).mask(content).onAppear {
            withAnimation(
                .linear(duration: 2).delay(0.1).repeatForever(autoreverses: false)
            ) { position = 0 }
        }
    }
}

// MARK: - Preview UI
struct DraggableOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        DraggableOverlayViewPreview()
    }

    struct DraggableOverlayViewPreview: View {
        @StateObject var manager = DataManager()
        var body: some View {
            ZStack {
                Color.black.opacity(manager.isTrackingSleep ? 0.5 : 0.0).ignoresSafeArea()
                DraggableOverlayView().environmentObject(manager)
            }
        }
    }
}
