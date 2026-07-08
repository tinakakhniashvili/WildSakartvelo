import Foundation

struct DailyDiscoveryService {
    var calendar: Calendar = .current

    func discovery(for date: Date = Date(), discoveries: [DailyDiscovery]) -> DailyDiscovery? {
        guard !discoveries.isEmpty else { return nil }
        let startOfDay = calendar.startOfDay(for: date)
        let dayNumber = Int(startOfDay.timeIntervalSince1970 / 86_400)
        return discoveries[abs(dayNumber) % discoveries.count]
    }
}
