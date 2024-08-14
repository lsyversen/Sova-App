//
//  SleepAnalysisContentView.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI

/// Shows the current sleep session analysis
struct SleepAnalysisContentView: View {

    @EnvironmentObject var manager: DataManager
    private let currentDate: Date = Date()
    private let circleSize: Double = UIScreen.main.bounds.width/1.8

    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            LinearGradient(colors: [.primaryTextColor, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                ForEach(0..<20, id: \.self) { _ in
                    AnimatedStar()
                }
            }
            VStack {
                CustomHeaderView
                Spacer()
                VStack(spacing: 30) {
                    SleepQualityProgress
                    SleepDuration
                }
                Spacer()
                SleepInfoBottomView
            }
        }
    }

    /// Custom header view
    private var CustomHeaderView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Sleep Analysis").font(.system(size: 25, weight: .bold))
                Text(currentDate.string(format: "MMMM d")).font(.system(size: 18, weight: .light))
            }.foregroundColor(.white)
            Spacer()
        }.padding(.horizontal)
    }

    /// Sleep quality circular progress
    private var SleepQualityProgress: some View {
        ZStack {
            VStack {
                Text("Quality").font(.system(size: 22, weight: .light)).opacity(0.7)
                Text("\(Int(sleepDuration.sleepQuality))").font(.system(size: 60, weight: .bold))
                Text("%").font(.system(size: 20, weight: .light)).opacity(0.7)
            }.foregroundColor(.white)
            Circle().stroke(lineWidth: 15).foregroundColor(.greenColor).opacity(0.2)
            Circle().trim(to: sleepDuration.sleepQuality * 0.01)
                .stroke(style: .init(lineWidth: 20, lineCap: .round))
                .rotation(.degrees(-90)).foregroundColor(.greenColor)
        }.frame(width: circleSize, height: circleSize)
    }

    /// Sleep duration
    private var SleepDuration: some View {
        VStack {
            Text(sleepDuration).font(.system(size: 22, weight: .semibold))
            Text("Sleep Duration").font(.system(size: 15, weight: .light))
        }.foregroundColor(.white)
    }

    /// Sleep info bottom view
    private var SleepInfoBottomView: some View {
        VStack(spacing: 25) {
            HStack {
                Text("Sleep Information").font(.system(size: 20, weight: .semibold))
                Spacer()
            }.padding([.horizontal, .top])
            HStack {
                SleepDataCell(time: Date.convert(from: manager.completedSessionStartTime, to: .timeFormat),
                              icon: "moon", subtitle: "Went to sleep")
                Spacer()
                SleepDataCell(time: currentDate.string(format: .timeFormat),
                              icon: "sunrise", subtitle: "Woke up")
            }.padding(.horizontal)
            Button { manager.fullScreenMode = nil } label: {
                ZStack {
                    Color.primaryTextColor
                    Text("Back to Home").bold().foregroundColor(.white)
                }
            }.frame(height: 55).cornerRadius(15).padding(.horizontal)
        }
        .padding([.top, .horizontal])
        .padding(.bottom, UIDevice.current.regularSize ? 10 : 20)
        .background(
            RoundedCorner(radius: 33, corners: [.topLeft, .topRight])
                .foregroundColor(.white).ignoresSafeArea()
        )
    }

    /// Sleep info data cell
    private func SleepDataCell(time: String, icon: String, subtitle: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon).font(.system(size: 30, weight: .light))
            VStack(alignment: .leading) {
                Text(time).font(.system(size: 22, weight: .semibold))
                Text(subtitle).font(.system(size: 16, weight: .light)).opacity(0.7)
            }.lineLimit(1).minimumScaleFactor(0.8)
        }
    }

    /// Sleep duration string
    private var sleepDuration: String {
        Date.from(time: manager.completedSessionStartTime)?.sleepDuration(from: currentDate) ?? "00:00:00"
    }
}

// MARK: - Preview UI
struct SleepAnalysisContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        return SleepAnalysisContentView().environmentObject(manager)
    }
}
