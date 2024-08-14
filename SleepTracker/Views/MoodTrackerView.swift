//
//  MoodTrackerView.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI

/// Shows a mood tracking view on the main dashboard
struct MoodTrackerView: View {

    @EnvironmentObject var manager: DataManager
    @State private var showActivitiesCard: Bool = false
    @State private var didShowActivitiesCard: Bool = false
    @State private var showNotesCard: Bool = false
    @State private var didShowNotesCard: Bool = false
    @State private var animateResetAction: Bool = false
    @State private var selectedReason: MoodReason?
    @State private var selectedMood: MoodLevel?
    @State private var didSubmit: Bool = false
    @State private var notes: String = ""
    private let tileHeight: Double = UIDevice.current.regularSize ? 185.0 : 170.0

    // MARK: - Main rendering function
    var body: some View {
        VStack(spacing: animateResetAction ? -(tileHeight) : -(tileHeight/1.5)) {
            NotesCardView
            ActivitiesCardView
            MoodCardView
        }.onAppear { configureSubmittedStateIfNeeded() }
    }

    /// Configure already submitted state
    private func configureSubmittedStateIfNeeded() {
        if !manager.submittedMoodStatus.isEmpty {
            didShowActivitiesCard = true
            showActivitiesCard = false
            didShowNotesCard = true
            showNotesCard = false
            didSubmit = true
        }
    }

    // MARK: - Card Header view
    private func CardHeader(title: String) -> some View {
        Text(title).multilineTextAlignment(.center)
            .font(.system(size: 22, weight: .bold))
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Card Background view
    private func CardBackground(colors: [Color]) -> some View {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .topTrailing).cornerRadius(25)
            .shadow(color: Color.black.opacity(0.1), radius: 8)
    }

    // MARK: - Notes card
    private var NotesCardView: some View {
        ZStack {
            CardBackground(colors: [.greenStartColor, .greenEndColor])
            VStack {
                CardHeader(title: "Do you have any thoughts\nto write down?")
                Spacer()
                TextEditor(text: $notes).font(.system(size: 14)).cornerRadius(15)
                    .padding(.bottom, 30).padding(.horizontal, 2).overlay(
                        VStack {
                            Spacer()
                            NotesOverlayButtons
                        }.padding(4)
                    )
                    .background(Color.white.cornerRadius(15))
                    .overlay(SubmittedStatusOverlay)
            }.padding()
        }
        .padding(.horizontal).frame(height: tileHeight)
        .offset(y: showNotesCard ? -(tileHeight/2.2) : 0)
        .zIndex(didShowNotesCard ? 2 : 0)
    }

    /// Notes overlay buttons
    private var NotesOverlayButtons: some View {
        HStack {
            Button("Reset") {
                withAnimation { animateResetAction = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation { animateResetAction = false }
                    showActivitiesCard = false
                    didShowActivitiesCard = false
                    showNotesCard = false
                    didShowNotesCard = false
                    selectedReason = nil
                    selectedMood = nil
                    notes = ""
                }
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.primaryTextColor).padding(.leading, 8)

            Spacer()

            Button("Submit") {
                guard let mood = selectedMood, let reason = selectedReason else { return }
                manager.trackMood(level: mood, reason: reason, notes: notes)
                didSubmit = true
                hideKeyboard()
            }
            .font(.system(size: 12)).padding(5).padding(.horizontal, 8)
            .background(Color.primaryTextColor.cornerRadius(12))
        }.foregroundColor(.secondaryTextColor)
    }

    /// Submitted overlay
    private var SubmittedStatusOverlay: some View {
        ZStack {
            if didSubmit {
                Color.white.cornerRadius(15)
                VStack {
                    Image(systemName: "checkmark.seal.fill")
                    Text("Well done!").font(.system(size: 17, weight: .medium))
                    Text("Check in again tomorrow").font(.system(size: 14, weight: .light))
                }.foregroundColor(.primaryTextColor)
            }
        }
    }

    // MARK: - Activities card
    private var ActivitiesCardView: some View {
        ZStack {
            CardBackground(colors: [.blueStartColor, .blueEndColor])
            VStack {
                CardHeader(title: "What's making you feel this way today?")
                Spacer()
                LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
                    ForEach(MoodReason.allCases) { reason in
                        MoodReasonButton(reason: reason)
                    }
                }
            }.padding()
        }
        .padding(.horizontal).frame(height: tileHeight)
        .rotationEffect(.degrees(7))
        .offset(y: showActivitiesCard ? -(tileHeight/2.2) :
                    ((didShowActivitiesCard && showNotesCard) ? tileHeight/3.0 : 0))
        .zIndex(didShowActivitiesCard ? 1 : 0)
    }

    /// Mood reason button
    private func MoodReasonButton(reason: MoodReason) -> some View {
        Button {
            if !didShowNotesCard && !showNotesCard {
                withAnimation(.easeOut(duration: 0.5)) {
                    showNotesCard = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 0.5)) {
                        didShowNotesCard = true
                        showNotesCard = false
                    }
                }
                selectedReason = reason
            }
        } label: {
            VStack(spacing: 0) {
                Image(reason.rawValue).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text(reason.rawValue).font(.system(size: 13, weight: .light))
            }
        }
        .frame(maxWidth: .infinity)
        .disabled(selectedReason != nil && selectedReason != reason || didSubmit)
    }

    // MARK: - Mood card
    private var MoodCardView: some View {
        ZStack {
            CardBackground(colors: [.purpleStartColor, .purpleEndColor])
            VStack {
                CardHeader(title: "How was your day?")
                Text("Today, \(Date().string(format: "MMMM d"))")
                    .font(.system(size: 15, weight: .light))
                Spacer()
                HStack {
                    ForEach(MoodLevel.allCases) { level in
                        MoodTypeButton(level: level)
                    }
                }
            }.padding().padding(.top, 10)
        }
        .padding(.horizontal).frame(height: tileHeight)
        .offset(y: showActivitiesCard ? tileHeight/3.0 : 0)
        .zIndex(didShowActivitiesCard ? 0 : 1)
    }

    /// Mood type button
    private func MoodTypeButton(level: MoodLevel) -> some View {
        Button {
            if !didShowActivitiesCard && !showActivitiesCard {
                withAnimation(.easeOut(duration: 0.5)) {
                    showActivitiesCard = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 0.5)) {
                        didShowActivitiesCard = true
                        showActivitiesCard = false
                    }
                }
                selectedMood = level
            }
        } label: {
            VStack {
                Text(level.icon).font(.system(size: 55))
                Text(level.title).font(.system(size: 13, weight: .light))
            }
        }
        .frame(maxWidth: .infinity)
        .disabled(selectedMood != nil && selectedMood != level || didSubmit)
    }
}

// MARK: - Preview UI
struct MoodTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrackerView().environmentObject(DataManager())
    }
}
