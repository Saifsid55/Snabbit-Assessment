//
//  QuestionnaireRepositoryProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

protocol QuestionnaireRepositoryProtocol {
    func fetchQuestions() async throws -> [QuestionnaireQuestion]
    func submitResponses(state: QuestionnaireState) async throws
    func hasSubmittedQuestionnaire() async throws -> Bool
}
