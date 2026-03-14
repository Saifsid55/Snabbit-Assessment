//
//  BreakState.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

enum BreakState {
    case notStarted
    case running
    case ended
    
    var buttonTitle: String {
        switch self {
        case .notStarted: return "Start my break"
        case .running: return "End my break"
        case .ended: return ""
        }
    }
}
