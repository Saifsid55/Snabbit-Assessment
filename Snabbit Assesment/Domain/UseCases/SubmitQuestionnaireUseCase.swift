//
//  SubmitQuestionnaireUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

protocol SubmitQuestionnaireUseCaseProtocol {
    func execute(state: QuestionnaireState) async throws
}

final class SubmitQuestionnaireUseCase: SubmitQuestionnaireUseCaseProtocol {
    
    private let repository: QuestionnaireRepositoryProtocol
    
    init(repository: QuestionnaireRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(state: QuestionnaireState) async throws {
        try await repository.submitResponses(state: state)
    }
}
