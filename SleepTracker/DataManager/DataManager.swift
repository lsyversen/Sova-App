//
//  DataManager.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI
import CoreData
import Foundation

/// Main data manager for the app
class DataManager: NSObject, ObservableObject {

    /// Dynamic properties that the UI will react to
    @Published var fullScreenMode: FullScreenMode?
    @Published var performance: [String: MoodLevel] = [String: MoodLevel]()
    @Published var dailyAverage: String = "- -"
    @Published var monthlyAverage: String = "- -"
    @Published var happiestMoodMonth: String?
    @Published var completedSessionStartTime: String = "- -"
    @Published var showProfileUpdatesFlow: Bool = false

    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage("username") var username: String = AppConfig.genericUsername
    @AppStorage("avatarName") var avatarName: String = AppConfig.avatars[0]
    @AppStorage("isTrackingSleep") var isTrackingSleep: Bool = false
    @AppStorage("submittedMoodStatus") var submittedMoodStatus: String = ""
    @AppStorage("sleepSessionStartTime") var sleepSessionStartTime: String = ""
    @AppStorage("trackedSleepSessionsCount") var trackedSleepSessionsCount: Int = 0
    @AppStorage(AppConfig.premiumVersion) var isPremiumUser: Bool = false {
        didSet { Interstitial.shared.isPremiumUser = isPremiumUser }
    }

    /// Core Data container with the database model
    private let container: NSPersistentContainer = NSPersistentContainer(name: "Database")

    /// Default initializer
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }

        Interstitial.shared.loadInterstitial()

        fetchMoodStats()
        fetchSleepStats()

        if submittedMoodStatus != Date().string(format: .mediumFormat) {
            submittedMoodStatus = ""
        }

        if username == AppConfig.genericUsername {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation { self.showProfileUpdatesFlow = true }
            }
        }
    }

    /// Greetings text based on the time of day
    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())

        let newDay = 0
        let noon = 12
        let sunset = 18
        let midnight = 24

        var greetingText = "Good day"

        switch hour {
        case newDay..<noon:
            greetingText = "Good morning"
        case noon..<sunset:
            greetingText = "Good afternoon"
        case sunset..<midnight:
            greetingText = "Good evening"
        default: break
        }

        return greetingText
    }

    /// Calendar days
    var calendarDays: [Date] {
        var days = [Date]()
        for index in 0..<10 {
            let date = Calendar(identifier: .gregorian).date(byAdding: .day, value: -index, to: Date())!
            days.append(date)
        }
        days.removeLast()
        days.insert(Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: Date())!, at: 0)
        return days.reversed()
    }

    /// Sleep duration based on current sleepSessionStartTime
    func duration(from currentDate: Date) -> String {
        guard let startTime = Date.from(string: sleepSessionStartTime, format: .longFormat) else {
            return "00:00:00"
        }
        return startTime.sleepDuration(from: currentDate)
    }
}

// MARK: - Track Mood Levels
extension DataManager {

    /// Save selected mood level for current day
    /// - Parameters:
    ///   - level: mood level
    ///   - reason: the reason for the mood
    ///   - notes: any notes that the user may want to share/save
    func trackMood(level: MoodLevel, reason: MoodReason, notes: String) {
        let moodEntity = MoodEntity(context: container.viewContext)
        moodEntity.moodLevel = Int16(level.rawValue)
        moodEntity.reason = reason.rawValue
        moodEntity.notes = notes
        moodEntity.date = Date()
        try? container.viewContext.save()
        submittedMoodStatus = Date().string(format: .mediumFormat)
        fetchMoodStats()

        /// Show interstitial ads
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Interstitial.shared.showInterstitialAds()
        }
    }

    /// Get the mood details for a given date
    /// - Parameter date: selected date
    /// - Returns: returns the notes and reason
    func moodDetails(forDate date: String?) -> (note: String, reason: String) {
        if let dateString = date, let startTime = Date.from(string: dateString, format: .mediumFormat) {
            let fetchRequest = MoodEntity.fetchRequest()
            fetchRequest.predicate = startTime.predicate
            if let matchingResult = try? container.viewContext.fetch(fetchRequest).first {
                return (matchingResult.notes ?? "", matchingResult.reason ?? "")
            }
        }
        return ("", "")
    }

    /// Fetch all mood data
    func fetchMoodStats() {
        let currentWeek = Array(calendarDays.dropLast().sorted().suffix(7)).compactMap({ $0.mediumFormat })
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let fetchRequest = MoodEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date > %@", oneWeekAgo as NSDate)
        if let results = try? container.viewContext.fetch(fetchRequest) {
            var performanceData = [String: MoodLevel]()
            currentWeek.forEach { date in
                let mood = results.filter({ $0.date?.mediumFormat == date }).map({ $0.moodLevel })
                if mood.count > 0 {
                    performanceData[date] = MoodLevel(rawValue: Int(mood.reduce(0, +)) / mood.count)
                }
            }
            DispatchQueue.main.async {
                self.performance = performanceData
                self.fetchHappiestMonthMoodData()
            }
        }
    }
    
    /// Fetch the happiest month of the year
    func fetchHappiestMonthMoodData(){
        let fetchRequest: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
        if let moodResults = try? container.viewContext.fetch(fetchRequest) {
            var moodMonthlyEntries: [String: Double] = [String: Double]()
            let moodItems = moodResults.filter({ $0.date?.year == Date().year })
            let moodEntries = Set(moodItems.map({ $0.date?.longFormat ?? "" })).sorted(by: > )
            moodEntries.enumerated().forEach { index, entry in
                if let entryDate = entry.date {
                    let mood = moodItems.filter({ $0.date?.month == entryDate.month }).map({ $0.moodLevel })
                    if moodMonthlyEntries[entryDate.month] == nil {
                        moodMonthlyEntries[entryDate.month] = Double(mood.reduce(0, +)) / Double(mood.count)
                    }
                }
            }
            DispatchQueue.main.async {
                if let month = moodMonthlyEntries.sorted(by: { $0.value > $1.value }).first?.key {
                    self.happiestMoodMonth = "🥳 \(month) 🎉"
                }
            }
        }
    }
}

// MARK: - Track Sleep Sessions
extension DataManager {

    /// Save sleep session details
    func startSleepSession() {
        let date = Date()
        let startTime = date.string(format: .longFormat)
        let sleepEntity = SleepEntity(context: container.viewContext)
        sleepEntity.startTime = date
        try? container.viewContext.save()

        /// Keep track of active sessions
        withAnimation { isTrackingSleep = true }
        sleepSessionStartTime = startTime
    }

    /// End sleep session
    func endSleepSession() {
        guard let startTime = Date.from(string: sleepSessionStartTime, format: .longFormat) else { return }
        let fetchRequest = SleepEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "startTime > %@", startTime as NSDate)
        if let matchingResult = try? container.viewContext.fetch(fetchRequest).first {
            matchingResult.endTime = Date()
            try? container.viewContext.save()

            /// Keep track of active sessions
            withAnimation { isTrackingSleep = false }
            completedSessionStartTime = startTime.string(format: .longFormat)
            trackedSleepSessionsCount += 1
            sleepSessionStartTime = ""
            fetchSleepStats()

            /// Show interstitial ads
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Interstitial.shared.showInterstitialAds()
            }
        }
    }

    /// Fetch all sleep data
    func fetchSleepStats() {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let last7Days = fetchSleepStats(startDate: oneWeekAgo).compactMap { $0.secondsDuration }
        dailyAverage = last7Days.averageTime

        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let last30Days = fetchSleepStats(startDate: oneMonthAgo).compactMap { $0.secondsDuration }
        monthlyAverage = last30Days.averageTime
    }

    /// Get the sleep data for a given start date
    /// - Parameter date: start date for a sleep session
    /// - Returns: returns all the results
    private func fetchSleepStats(startDate date: Date) -> [SleepEntity] {
        let fetchRequest = SleepEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "startTime > %@", date as NSDate)
        if let results = try? container.viewContext.fetch(fetchRequest) { return results }
        return []
    }
}
