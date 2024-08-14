//
//  AppConfig.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {

    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-9867250840069210/7390309663"

    // MARK: - Generic Configurations
    static let genericUsername: String = "Your Name"
    static let avatars: [String] = ["avatar-01", "avatar-02", "avatar-03", "avatar-04", "avatar-05", "avatar-06", "avatar-07", "avatar-08", "avatar-09", "avatar-10", "avatar-11", "avatar-12", "avatar-13", "avatar-14", "avatar-15", "avatar-16", "avatar-17", "avatar-18", "avatar-19", "avatar-20", "avatar-21", "avatar-22", "avatar-23", "avatar-24", "avatar-25", "avatar-26"]

    // MARK: - Settings flow items
    static let emailSupport = "sovasleeptracker@gmail.com"
    static let privacyURL: URL = URL(string: "https://www.google.com/")!
    static let termsAndConditionsURL: URL = URL(string: "https://www.google.com/")!
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/app/idXXXXXXXXX")!

    // MARK: - In App Purchases
    static let premiumVersion: String = "AppTemplate.Premium"
    static let freeSleepSessions: Int = 99
}

/// Main app colors
extension Color {
    static let backgroundColor: Color = Color("BackgroundColor")
    static let primaryTextColor: Color = Color("PrimaryTextColor")
    static let secondaryTextColor: Color = Color("SecondaryTextColor")
    static let greenStartColor: Color = Color("GreenStartColor")
    static let greenEndColor: Color = Color("GreenEndColor")
    static let purpleStartColor: Color = Color("PurpleStartColor")
    static let purpleEndColor: Color = Color("PurpleEndColor")
    static let blueStartColor: Color = Color("BlueStartColor")
    static let blueEndColor: Color = Color("BlueEndColor")
    static let greenColor: Color = Color("GreenColor")
    static let redColor: Color = Color("RedColor")
}

/// Mood Level Configurations
enum MoodLevel: Int, CaseIterable, Identifiable {
    case level1 = 1, level2, level3, level4
    var id: Int { hashValue }

    /// Mood level title
    var title: String {
        switch self {
        case .level1:
            return "amazing"
        case .level2:
            return "good"
        case .level3:
            return "meh"
        case .level4:
            return "bad"
        }
    }

    /// Mood chart percentage
    var chartValue: CGFloat {
        switch self {
        case .level1: return 95
        case .level2: return 60
        case .level3: return 30
        case .level4: return 5
        }
    }

    /// Mood chart color
    var chartColor: Color {
        [Color(#colorLiteral(red: 0.3809461594, green: 0.6858740449, blue: 1, alpha: 1))][0]
    }

    /// Mood icon
    var icon: String {
        switch self {
        case .level1:
            return "😄"
        case .level2:
            return "🙂"
        case .level3:
            return "😐"
        case .level4:
            return "😞"
        }
    }
}

/// Reason for selected mood
enum MoodReason: String, CaseIterable, Identifiable {
    case work, friends, nature, pets, fitness, travel, gaming, shopping
    var id: Int { hashValue }
}

/// Full Screen flow
enum FullScreenMode: Identifiable {
    case premium, sleepAnalysis, statistics
    case suggestions(index: Int)
    var id: String {
        switch self {
        case .suggestions(let index):
            return "suggestions-\(index)"
        default:
            return "\(self)"
        }
    }
}

/// Sleep Highlights type
enum SleepHighlightType: String, CaseIterable, Identifiable {
    case dailyAverage = "Daily Average"
    case monthlyAverage = "Monthly Average"
    var id: Int { hashValue }

    var gradient: [Color] {
        switch self {
        case .dailyAverage:
            return [.greenStartColor, .greenEndColor]
        case .monthlyAverage:
            return [.purpleStartColor, .purpleEndColor]
        }
    }

    var info: String {
        switch self {
        case .dailyAverage:
            return "Your daily hours of sleep average count based on previous 7 days"
        case .monthlyAverage:
            return "Your monthly hours of sleep average based on previous 30 days"
        }
    }

    var icon: String {
        switch self {
        case .dailyAverage:
            return "clock.badge.checkmark"
        case .monthlyAverage:
            return "calendar.badge.clock"
        }
    }
}

// MARK: - Sleep Suggestions
extension AppConfig {
    static let sleepSuggestions: [SleepTipModel] = [
        .init(title: "Relaxing Routine", subtitle: "Wind down before bed", icon: "figure.mind.and.body",
              details: [
                .init(title: "Warm Bath",
                      details: "Taking a warm bath or shower before bedtime helps to relax your muscles and calm your mind, creating an ideal environment for sleep."),
                .init(title: "Reading",
                      details: "Engaging in a quiet reading activity, such as a physical book or e-reader with a dim screen, can help you unwind and transition into a peaceful state of mind."),
                .init(title: "Mindfulness",
                      details: "Practicing mindfulness meditation and deep breathing exercises can alleviate stress and anxiety, making it easier to drift off into a restful slumber."),
              ]),

            .init(title: "Screen Time", subtitle: "Limit screen exposure", icon: "iphone.slash",
                  details: [
                    .init(title: "Digital Detox",
                          details: "Minimize screen time at least an hour before bed to avoid the stimulating effects of blue light and help your body prepare for sleep."),
                    .init(title: "Night Mode",
                          details: "Enable night mode on your devices to reduce blue light emissions, making it gentler on your eyes and potentially less disruptive to your sleep cycle."),
                  ]),

            .init(title: "Consistent Schedule", subtitle: "Go to bed at the same time", icon: "clock.badge.checkmark",
                  details: [
                    .init(title: "Regular Bedtime",
                          details: "Establishing a consistent bedtime and wake-up time helps regulate your body's internal clock, making it easier to fall asleep and wake up naturally."),
                    .init(title: "Limit Napping",
                          details: "If you need to nap during the day, aim for shorter naps before 3 PM to avoid interfering with your nighttime sleep and circadian rhythm."),
                  ]),

            .init(title: "Calm Sleeping Environment", subtitle: "Optimal conditions are important", icon: "moon.zzz.fill",
                  details: [
                    .init(title: "Darkness",
                          details: "Create a dark sleeping environment by using blackout curtains or an eye mask to promote the production of sleep-inducing melatonin."),
                    .init(title: "Comfortable Bed",
                          details: "Invest in a comfortable mattress and pillows that provide adequate support and help prevent discomfort during the night."),
                    .init(title: "Cool Temperature",
                          details: "Keep your bedroom slightly cool, as a lower room temperature can promote better sleep and prevent overheating."),
                  ]),

            .init(title: "Healthy Eating", subtitle: "Mindful food choices", icon: "fork.knife",
                  details: [
                    .init(title: "Light Evening Meal",
                          details: "Avoid heavy meals close to bedtime, opting for a light snack if necessary to prevent indigestion that may disrupt sleep."),
                    .init(title: "Limit Caffeine",
                          details: "Reduce caffeine intake in the afternoon and evening, as it can interfere with falling asleep and negatively affect sleep quality."),
                    .init(title: "Hydration Balance",
                          details: "Stay hydrated, but avoid excessive liquids before bed to prevent disruptive trips to the bathroom."),
                  ]),

            .init(title: "Physical Activity", subtitle: "Why active lifestyle?", icon: "dumbbell.fill",
                  details: [
                    .init(title: "Regular Exercise",
                          details: "Engage in regular physical activity, but aim to finish your workouts at least a few hours before bedtime to allow your body to wind down."),
                    .init(title: "Outdoor Time",
                          details: "Spend time outdoors during the day to help regulate your circadian rhythm and improve overall sleep quality."),
                  ]),

            .init(title: "Stress Management", subtitle: "Practice relaxation techniques", icon: "figure.strengthtraining.functional",
                  details: [
                    .init(title: "Journaling",
                          details: "Write down your thoughts and worries in a journal to help clear your mind before bed and reduce anxiety."),
                    .init(title: "Yoga or Stretching",
                          details: "Practice gentle yoga or stretching exercises to release physical tension and promote relaxation."),
                    .init(title: "Guided Imagery",
                          details: "Listen to guided imagery or relaxation recordings to shift your focus away from stress and into a more serene mental state."),
                  ]),

            .init(title: "Liquid Intake", subtitle: "Prevent sleep disruptions", icon: "drop.fill",
                  details: [
                    .init(title: "Evening Hydration",
                          details: "Consume most of your fluids earlier in the day and reduce liquid intake in the hours leading up to bedtime."),
                    .init(title: "Alcohol Awareness",
                          details: "Limit alcohol consumption before bed, as it can disrupt sleep patterns and lead to fragmented sleep."),
                  ])
    ]
}
