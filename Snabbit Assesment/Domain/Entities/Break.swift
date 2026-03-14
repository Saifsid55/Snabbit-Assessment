//
//  Break.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import Foundation

struct Break {
    let startTime: Date
    let duration: TimeInterval
    
    var endTime: Date {
        startTime.addingTimeInterval(duration)
    }
}

enum BreakStatus {
    case running
    case ended
}
