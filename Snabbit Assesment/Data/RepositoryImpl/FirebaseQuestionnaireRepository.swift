//
//  FirebaseQuestionnaireRepository.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

// MARK: - Repository Implementation
final class QuestionnaireRepository: QuestionnaireRepositoryProtocol {
    
    private let service: FirebaseQuestionnaireService
    private let userId: String
    
    init(service: FirebaseQuestionnaireService, userId: String) {
        self.service = service
        self.userId = userId
    }
    
    func fetchQuestions() async throws -> [QuestionnaireQuestion] {
        try await service.fetchQuestions()
    }
    
    func submitResponses(state: QuestionnaireState) async throws {
        try await service.submitResponses(userId: userId, state: state)
    }
    
    func hasSubmittedQuestionnaire() async throws -> Bool {
        try await service.hasSubmittedQuestionnaire(userId: userId)
    }
}
