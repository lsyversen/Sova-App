//
//  SuggestionsContentView.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI

/// Shows sleep suggestions
struct SuggestionsContentView: View {

    @EnvironmentObject var manager: DataManager
    let index: Int

    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack(spacing: 20) {
                CustomHeaderView
                ScrollView(.vertical, showsIndicators: false) {
                    SleepTipsStackView
                }
            }
        }
    }

    /// Custom header view
    private var CustomHeaderView: some View {
        HStack(spacing: 15) {
            ZStack {
                Color.primaryTextColor.opacity(0.1)
                    .cornerRadius(15).frame(width: 55, height: 55)
                Image(systemName: AppConfig.sleepSuggestions[index].icon)
                    .font(.system(size: 30))
            }
            VStack(alignment: .leading) {
                Text("Restful tips for better sleep")
                    .foregroundColor(.primaryTextColor).opacity(0.5)
                    .font(.system(size: 14, weight: .medium))
                Text("Dreamy Tips").foregroundColor(.primaryTextColor)
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

    /// Sleep details stack
    private var SleepTipsStackView: some View {
        VStack(spacing: 30) {
            let sleepTip = AppConfig.sleepSuggestions[index]
            if let details = sleepTip.details {
                ForEach(0..<details.count, id: \.self) { index in
                    SleepTipSection(title: details[index].title, details: details[index].details)
                }
            }
        }
    }

    // MARK: - Sleep Tip Details
    private func SleepTipSection(title: String, details: String) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text(title).font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            HStack {
                Text(details).font(.system(size: 17, weight: .light))
                Spacer()
            }.padding().background(Color.gray.opacity(0.12).cornerRadius(20))
        }.padding(.horizontal)
    }
}

// MARK: - Preview UI
struct SuggestionsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsContentView(index: 0).environmentObject(DataManager())
    }
}
