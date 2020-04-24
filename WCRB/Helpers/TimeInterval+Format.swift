//  TimeInterval+Format.swift - WCRB

import Foundation

extension TimeInterval {
    func minuteSecondFormat() -> String {
        let seconds = Int(self) / 1000
        
        let minutes = seconds / 60
        let remainingSeconds = seconds % minutes
        
        return "\(minutes):\(String(format: "%02d", remainingSeconds))"
    }
}
