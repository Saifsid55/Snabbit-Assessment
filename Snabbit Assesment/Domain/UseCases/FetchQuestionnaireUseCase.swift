//
//  FetchQuestionnaireUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

protocol FetchQuestionnaireUseCaseProtocol {
    
    func execute(
        completion: @escaping (Result<[QuestionnaireQuestion], Error>) -> Void
    )
}

final class FetchQuestionnaireUseCase: FetchQuestionnaireUseCaseProtocol {
    
    private let repository: QuestionnaireRepositoryProtocol
    
    init(repository: QuestionnaireRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        completion: @escaping (Result<[QuestionnaireQuestion], Error>) -> Void
    ) {
        repository.fetchQuestions(completion: completion)
    }
}
