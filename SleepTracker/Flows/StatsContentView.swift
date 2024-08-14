//
//  StatsContentView.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import Charts
import SwiftUI

/// Shows sleep and mood statistics
struct StatsContentView: View {

    @EnvironmentObject var manager: DataManager
    @State private var selectedDateReason: String = ""
    @State private var selectedDateNotes: String = ""
    @State private var selectedDate: String?

    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack(spacing: 20) {
                CustomHeaderView
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 25) {
                        SleepHighlightsView
                        HappiestMoodTileView
                        WeeklyChartView
                        WeeklyNotesView
                    }
                }
            }
        }
    }

    /// Custom header view
    private var CustomHeaderView: some View {
        HStack(spacing: 15) {
            Image(manager.avatarName)
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55).background(
                    Color.primaryTextColor.opacity(0.1).cornerRadius(15)
                )
            VStack(alignment: .leading) {
                Text("Snooze & Mood")
                    .foregroundColor(.primaryTextColor).opacity(0.5)
                    .font(.system(size: 14, weight: .medium))
                Text("Statistics").foregroundColor(.primaryTextColor)
                    .font(.system(size: 25, weight: .bold))
            }
            Spacer()
            Button { manager.fullScreenMode = nil } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.5)
                    Image(systemName: "xmark").font(.system(size: 20))
                }
            }.frame(width: 45, height: 45)
        }.padding(.horizontal).lineLimit(1)
    }

    // MARK: - Sleep Highlights
    private var SleepHighlightsView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Sleep Highlights").font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            HStack(spacing: 15) {
                SleepHighlightView(forType: .dailyAverage)
                SleepHighlightView(forType: .monthlyAverage)
            }
        }.padding(.horizontal)
    }

    /// Sleep Highlight item
    private func SleepHighlightView(forType type: SleepHighlightType) -> some View {
        ZStack {
            LinearGradient(colors: type.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: type.icon).resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                    VStack(alignment: .leading) {
                        Text(type == .dailyAverage ? manager.dailyAverage : manager.monthlyAverage)
                            .font(.system(size: 20, weight: .semibold))
                            .blur(radius: manager.isPremiumUser ? 0 : 5)
                        Text(type.rawValue).font(.system(size: 15))
                    }
                }
                Spacer()
            }.padding()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        presentAlert(title: "", message: type.info, primaryAction: .OK)
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .font(.system(size: 15))
                    .frame(width: 20, height: 20, alignment: .center)
                }
                Spacer()
            }.padding(10)
        }.cornerRadius(20)
    }

    // MARK: - Weekly chart performance
    private var WeeklyChartView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Weekly Mood").font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            ChartView
        }.padding(.horizontal)
    }

    /// Chart view with stats data
    var ChartView: some View {
        let weekDays = Array(manager.calendarDays.dropLast().reversed().prefix(7).reversed())
        return ZStack {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(MoodLevel.allCases) { level in
                    HStack(spacing: 10) {
                        Text(level.icon).frame(width: 30, alignment: .leading)
                        Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [6])).frame(height: 1).opacity(0.5)
                    }
                }
            }.padding(.bottom, 30).opacity(manager.isPremiumUser ? 1 : 0.2)

            /// Chart days
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<weekDays.count, id: \.self) { index in
                        Text(weekDays[index].string(format: "MMM\nd"))
                            .font(.system(size: 15, weight: .semibold))
                            .multilineTextAlignment(.center)
                    }.frame(maxWidth: .infinity)
                }
            }.padding(.leading, 30).opacity(manager.isPremiumUser ? 1 : 0.2)

            /// Chart progress bars
            HStack {
                ForEach(0..<weekDays.count, id: \.self) { index in
                    ChartProgressBar(forDate: weekDays[index].mediumFormat)
                }.opacity(manager.isPremiumUser ? 1 : 0).disabled(!manager.isPremiumUser)
            }.padding(.leading, 30).padding(.bottom, 40).overlay(
                VStack {
                    Image(systemName: "crown.fill").font(.system(size: 25))
                    Text("Premium Version").font(.system(size: 18, weight: .semibold))
                    Text("Purchase the premium version\nfor access to statistics")
                        .font(.system(size: 14)).multilineTextAlignment(.center)
                        .opacity(0.75)
                }.background(Color.backgroundColor).padding(.bottom, 50).opacity(manager.isPremiumUser ? 0 : 1)
            )
        }
    }

    /// Chart progress for day
    private func ChartProgressBar(forDate date: String) -> some View {
        GeometryReader { reader in
            VStack {
                Spacer()
                Rectangle().frame(height: completionHeight(reader: reader, date: date))
                    .foregroundColor(.clear).overlay(
                        RoundedCorner(radius: 5, corners: [.topLeft, .topRight]).frame(width: 20)
                            .foregroundColor(manager.performance[date]?.chartColor)
                    )
                    .opacity(selectedDate == date || selectedDate == nil ? 1 : 0.4)
                    .onTapGesture {
                        if selectedDate == date {
                            selectedDate = nil
                        } else {
                            selectedDate = date
                            let moodData = manager.moodDetails(forDate: selectedDate)
                            selectedDateNotes = moodData.note
                            selectedDateReason = moodData.reason
                        }
                    }
            }
        }
    }

    /// Completion progress height for chart bar
    private func completionHeight(reader: GeometryProxy, date: String) -> CGFloat {
        guard let progress = manager.performance[date]?.chartValue else { return 0 }
        let max = Double(100.0)
        let completed = reader.size.height
        let current = (CGFloat(progress) * completed) / CGFloat(max)
        return progress == max ? completed - 5 : current
    }

    // MARK: - Weekly notes
    private var WeeklyNotesView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Journal Notes").font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            if selectedDate != nil {
                if selectedDateNotes.isEmpty {
                    EmptyJournalView
                } else {
                    JournalNotesView
                }
            } else {
                NoJournalDateSelectedView
            }
        }.padding(.horizontal)
    }

    /// Journal notes
    private var JournalNotesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Text("Your notes:").font(.system(size: 17, weight: .semibold))
                    Spacer()
                }.opacity(0.75)
                Text(selectedDateNotes).font(.system(size: 14, weight: .light))
            }.blur(radius: manager.isPremiumUser ? 0 : 5)
            HStack(spacing: 5) {
                Text("Reason for your mood:").font(.system(size: 17, weight: .semibold))
                Spacer()
                Text(selectedDateReason).font(.system(size: 14, weight: .light))
            }.opacity(0.75).blur(radius: manager.isPremiumUser ? 0 : 5)
        }.padding().background(Color.gray.opacity(0.12).cornerRadius(20))
    }

    /// Empty journal view
    private var EmptyJournalView: some View {
        ZStack {
            Color.gray.opacity(0.12).cornerRadius(20)
            VStack {
                Image(systemName: "doc.text")
                Text("No Journal Notes").font(.system(size: 17, weight: .semibold))
                Text("You don't have any notes for this day").font(.system(size: 14, weight: .medium))
            }.opacity(0.75)
        }.frame(height: 100)
    }

    /// No journal date selected
    private var NoJournalDateSelectedView: some View {
        ZStack {
            Color.gray.opacity(0.12).cornerRadius(20)
            VStack {
                Image(systemName: "calendar")
                Text("No Day Selected").font(.system(size: 17, weight: .semibold))
                Text("Select a day on the chart above").font(.system(size: 14, weight: .medium))
            }.opacity(0.75)
        }.frame(height: 100)
    }

    // MARK: - Happiest mood month
    private var HappiestMoodTileView: some View {
        ZStack {
            Color.gray.opacity(0.12).cornerRadius(20)
            VStack {
                HStack(spacing: 0) {
                    Image("leaf-sticker")
                    VStack {
                        Text("Happiest Month").font(.system(size: 15, weight: .semibold))
                        Text("OF THE YEAR").font(.system(size: 14, weight: .medium))
                    }
                    Image("leaf-sticker")
                        .scaleEffect(CGSize(width: -1, height: 1), anchor: .center)
                }.opacity(0.75)
                Spacer()
                Text(manager.happiestMoodMonth != nil ? manager.happiestMoodMonth!
                     : "Here will show your happiest month of the year")
                    .font(.system(size: 15, weight: manager.happiestMoodMonth != nil ? .bold : .light))
                    .lineLimit(1).minimumScaleFactor(0.75)
                    .blur(radius: manager.isPremiumUser ? 0 : 5)
            }.padding(22)
        }.frame(height: 90).padding(.horizontal)
    }
}

/// A simple line path
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

// MARK: - Preview UI
struct StatsContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.performance = [
            "08/18/2023": .level1, "08/19/2023": .level2,
            "08/20/2023": .level3, "08/21/2023": .level4
        ]
        manager.happiestMoodMonth = "September"
        return StatsContentView().environmentObject(manager)
    }
}
