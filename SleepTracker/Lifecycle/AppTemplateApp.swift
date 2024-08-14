//
//  SleepTrackerApp.swift
//  SleepTracker
//
//  Created by Apps4World on 9/11/23.
//

import SwiftUI
import Combine
import CoreData
import FirebaseCore

@main
struct SleepTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var manager: DataManager = DataManager()
    @StateObject private var authViewModel = AuthViewModel()

    // MARK: - Main rendering function
    var body: some Scene {
        WindowGroup {
            DashboardContentView()
                .environmentObject(manager)
                .environmentObject(authViewModel)
        }
    }
}

/// Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction, secondaryAction: UIAlertAction? = nil, tertiaryAction: UIAlertAction? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(primaryAction)
        if let secondary = secondaryAction { alert.addAction(secondary) }
        if let tertiary = tertiaryAction { alert.addAction(tertiary) }
        rootController?.present(alert, animated: true, completion: nil)
    }
}

extension UIAlertAction {
    static var Cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }

    static var OK: UIAlertAction {
        UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }
}

var rootController: UIViewController? {
    var root = UIApplication.shared.connectedScenes
        .filter({ $0.activationState == .foregroundActive })
        .first(where: { $0 is UIWindowScene }).flatMap({ $0 as? UIWindowScene })?.windows
        .first(where: { $0.isKeyWindow })?.rootViewController
    while root?.presentedViewController != nil {
        root = root?.presentedViewController
    }
    return root
}

var window: UIWindow? {
    UIApplication.shared.connectedScenes
        .filter({ $0.activationState == .foregroundActive })
        .first(where: { $0 is UIWindowScene }).flatMap({ $0 as? UIWindowScene })?.windows
        .first(where: { $0.isKeyWindow })
}

/// Handle certain date operations
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }

    static func from(string: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US")
        return formatter.date(from: string)
    }

    static func from(time string: String) -> Date? {
        Date.from(string: string, format: .longFormat)
    }

    static func convert(from: String, to string: String) -> String {
        Date.from(string: from, format: .longFormat)?.string(format: string) ?? ""
    }

    func sleepDuration(from date: Date) -> String {
        let timeInterval = date.timeIntervalSince(self)
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, abs(seconds))
    }
    
    var longFormat: String {
        string(format: "MM/dd/yyyy")
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        return formatter.string(from: self)
    }
    
    var predicate: NSPredicate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        return NSPredicate(format: "date >= %@ AND date =< %@", argumentArray: [startDate!, endDate!])
    }

    var mediumFormat: String {
        string(format: .mediumFormat)
    }
}

/// Date String formats
extension String {
    static let mediumFormat = "yyyy-MM-dd"
    static let longFormat = "yyyy-MM-dd'T'HH:mm:ss"
    static let timeFormat = "h:mm a"
    
    func date(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    var date: Date? {
        date(format: "MM/dd/yyyy")
    }
}

/// Get the sleep quality from sleep duration
extension String {
    var sleepQuality: Double {
        let components = components(separatedBy: ":")
        guard let hours = Int(components[0]), let minutes = Int(components[1]) else { return 0.0 }

        /// Convert hours and minutes to total minutes
        let totalMinutes = hours * 60 + minutes

        switch totalMinutes {
        case 0..<30:    /// Less than 1 hour
            return 5.0
        case 30...60:   /// 30m to 1 hour
            return 10.0
        case 60..<180:  /// Less than 3 hours
            return 20.0
        case 180..<300: /// 3 to 4 hours
            return 40.0
        case 300..<420: /// 5 to 6 hours
            return 60.0
        case 420..<540: /// 7 to 8 hours
            return 80.0
        default:        /// More than 8 hours
            return 100.0
        }
    }
}

/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// Detect device type
extension UIDevice {
    var regularSize: Bool {
        UIScreen.main.nativeBounds.height > 1334.0
    }
}

/// Hide keyboard from any view
extension View {
    func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension ViewModifier {
    func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

/// A simple extension to handle observe keyboard appearance
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        return MergeMany(willShow, willHide).eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

/// Get the sleep duration from Sleep Entity
extension SleepEntity {
    var secondsDuration: TimeInterval? {
        guard let start = startTime, let end = endTime else { return nil }
        return end.timeIntervalSince(start)
    }
}

/// Return the average time from TimeInterval array
extension Array where Element == TimeInterval {
    var averageTime: String {
        guard !isEmpty else { return "- -" }

        let totalTimeInterval = reduce(0, +)
        let averageTimeInterval = totalTimeInterval / Double(count)

        let (hours, minutes) = secondsToHoursMinutes(seconds: averageTimeInterval)
        return String(format: "%02dh %02dm", hours, minutes)
    }

    func secondsToHoursMinutes(seconds: TimeInterval) -> (hours: Int, minutes: Int) {
        let secondsInHour: Double = 3600
        let secondsInMinute: Double = 60

        let hours = Int(seconds / secondsInHour)
        let remainingSeconds = seconds - Double(hours) * secondsInHour
        let minutes = Int(remainingSeconds / secondsInMinute)

        return (hours, minutes)
    }
}

