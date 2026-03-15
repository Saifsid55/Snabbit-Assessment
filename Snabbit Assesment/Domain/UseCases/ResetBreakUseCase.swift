//
//  ResetBreakUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

protocol ResetBreakUseCaseProtocol {
    func execute() async throws
}

final class ResetBreakUseCase: ResetBreakUseCaseProtocol {

    private let repository: BreakRepositoryProtocol

    init(repository: BreakRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.resetBreak()
    }
}
