//
//  EndBreakUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

protocol EndBreakUseCaseProtocol {
    func execute() async throws
}

final class EndBreakUseCase: EndBreakUseCaseProtocol {

    private let repository: BreakRepositoryProtocol

    init(repository: BreakRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws {
        try await repository.endBreakEarly()
    }
}
