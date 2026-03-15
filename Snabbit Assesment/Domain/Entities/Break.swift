//
//  Break.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import Foundation

struct Break {
    
    let startTime: Date?
    let duration: Double
    let status: String
    let breakTaken: Bool
    let endTime: Date?
    
    var computedEndTime: Date? {
        guard let startTime else { return nil }
        return startTime.addingTimeInterval(duration)
    }
}

enum BreakStatus {
    case running
    case ended
}
