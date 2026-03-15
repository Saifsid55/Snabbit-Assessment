//
//  QuestionnaireQuestion.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import Foundation

struct QuestionnaireQuestion: Codable {
    
    let id: String
    let title: String
    let type: QuestionType
    let options: [String]?
}

enum QuestionType: String, Codable {
    case multiSelect = "multi_select"
    case singleSelect = "single_select"
    case date
}
