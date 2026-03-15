//
//  ObserveBreakUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//
import Foundation

protocol ObserveBreakUseCaseProtocol {

    func execute(
        onChange: @escaping (Break?) -> Void
    )
}

final class ObserveBreakUseCase: ObserveBreakUseCaseProtocol {

    private let repository: BreakRepositoryProtocol

    init(repository: BreakRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        onChange: @escaping (Break?) -> Void
    ) {
        repository.observeBreak(onChange: onChange)
    }
}
