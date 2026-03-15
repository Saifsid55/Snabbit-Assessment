//
//  FirebaseQuestionnaireRepository.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

final class QuestionnaireRepository: QuestionnaireRepositoryProtocol {
    
    private let service: FirebaseQuestionnaireService
    private let userId: String
    
    init(
        service: FirebaseQuestionnaireService,
        userId: String
    ) {
        self.service = service
        self.userId = userId
    }
    
    func fetchQuestions(
        completion: @escaping (Result<[QuestionnaireQuestion], Error>) -> Void
    ) {
        service.fetchQuestions(completion: completion)
    }
    
    
    func submitResponses(
        state: QuestionnaireState,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        service.submitResponses(
            userId: userId,
            state: state,
            completion: completion
        )
    }
}
