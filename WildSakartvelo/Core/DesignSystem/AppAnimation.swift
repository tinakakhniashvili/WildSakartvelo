import SwiftUI

enum AppAnimation {
    static let standardDuration: Double = 0.22
    static let slowDuration: Double = 0.34

    static var standard: Animation {
        .easeInOut(duration: standardDuration)
    }
}
