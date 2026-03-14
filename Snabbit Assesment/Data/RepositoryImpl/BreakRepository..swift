//
//  BreakRepository..swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import Foundation

final class BreakRepository: BreakRepositoryProtocol {

    func fetchBreak() async throws -> Break {

        let start = Date()
        let duration: TimeInterval = 180

        return Break(
            startTime: start,
            duration: duration
        )
    }

    func endBreakEarly() async throws {

        print("Break ended early sent to server")
    }
}
