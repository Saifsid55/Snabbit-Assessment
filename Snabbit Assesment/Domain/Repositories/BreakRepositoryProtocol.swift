//
//  BreakRepositoryProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

protocol BreakRepositoryProtocol {
    
    func observeBreak(
        onChange: @escaping (Break?) -> Void
    )
    
    func fetchBreak() async throws -> Break
    
    func startBreak() async throws
    
    func resetBreak() async throws
    
    func endBreakEarly() async throws
}
