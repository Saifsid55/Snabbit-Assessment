//
//  BreakRepository..swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import Foundation

final class BreakRepository: BreakRepositoryProtocol {
    
    private let service: FirebaseBreakService
    private let userId: String
    
    init(service: FirebaseBreakService, userId: String) {
        self.service = service
        self.userId = userId
    }
    
    func observeBreak(
        onChange: @escaping (Break?) -> Void
    ) {
        Task {
            try? await service.migrateBreakDocumentIfNeeded(userId: userId)
            service.observeBreak(userId: userId, onChange: onChange)
        }
    }
    
    func startBreak() async throws {
        try await service.startBreak(userId: userId)
    }
    
    func fetchBreak() async throws -> Break {
        try await service.fetchBreak(userId: userId)
    }
    
    func resetBreak() async throws {
        try await service.resetBreak(userId: userId)
    }
    
    func endBreakEarly() async throws {
        try await service.endBreakEarly(userId: userId)
    }
}
