//
//  QuestionnaireRepositoryProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

protocol QuestionnaireRepositoryProtocol {
    
    func fetchQuestions(
        completion: @escaping (Result<[QuestionnaireQuestion], Error>) -> Void
    )
    
    func submitResponses(
        state: QuestionnaireState,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func hasSubmittedQuestionnaire() async throws -> Bool
}
