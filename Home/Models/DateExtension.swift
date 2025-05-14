import Foundation

public extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: self, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "1 day ago" : "\(day) days ago"
        } else if let hour = components.hour, hour > 0 {
            return hour == 1 ? "1 hr ago" : "\(hour) hrs ago"
        } else if let minute = components.minute, minute > 0 {
            return minute == 1 ? "1 min ago" : "\(minute) mins ago"
        } else {
            return "Just now"
        }
    }
} 