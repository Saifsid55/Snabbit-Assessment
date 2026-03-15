//
//  FetchQuestionnaireUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

protocol FetchQuestionnaireUseCaseProtocol {
    func execute() async throws -> [QuestionnaireQuestion]
}

final class FetchQuestionnaireUseCase: FetchQuestionnaireUseCaseProtocol {
    
    private let repository: QuestionnaireRepositoryProtocol
    
    init(repository: QuestionnaireRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [QuestionnaireQuestion] {
        try await repository.fetchQuestions()
    }
}
