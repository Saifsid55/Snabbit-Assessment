//
//  SubmitQuestionnaireUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

protocol SubmitQuestionnaireUseCaseProtocol {
    
    func execute(
        state: QuestionnaireState,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class SubmitQuestionnaireUseCase: SubmitQuestionnaireUseCaseProtocol {
    
    private let repository: QuestionnaireRepositoryProtocol
    
    init(repository: QuestionnaireRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        state: QuestionnaireState,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        repository.submitResponses(
            state: state,
            completion: completion
        )
    }
}
