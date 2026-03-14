//
//  BreakRepositoryProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

protocol BreakRepositoryProtocol {

    func fetchBreak() async throws -> Break
    
    func endBreakEarly() async throws
}
