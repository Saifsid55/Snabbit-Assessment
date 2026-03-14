//
//  FetchBreakUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//


protocol FetchBreakUseCaseProtocol {
    func execute() async throws -> Break
}

final class FetchBreakUseCase: FetchBreakUseCaseProtocol {

    private let repository: BreakRepositoryProtocol
    
    init(repository: BreakRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> Break {
        try await repository.fetchBreak()
    }
}
