//
//  FirebaseQuestionnaireService.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import FirebaseFirestore

final class FirebaseQuestionnaireService {
    
    private let db = Firestore.firestore()
    
    // MARK: - Fetch Questions
    
    func fetchQuestions() async throws -> [QuestionnaireQuestion] {
        let snapshot = try await db.collection("questionnaires")
            .order(by: "order")
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> QuestionnaireQuestion? in
            let data = doc.data()
            guard
                let title = data["title"] as? String,
                let typeString = data["type"] as? String,
                let type = QuestionType(rawValue: typeString)
            else { return nil }
            
            return QuestionnaireQuestion(
                id: doc.documentID,
                title: title,
                type: type,
                options: data["options"] as? [String]
            )
        }
    }
    
    // MARK: - Submit Responses
    
    func submitResponses(userId: String, state: QuestionnaireState) async throws {
        let data: [String: Any] = [
            "skills": Array(state.selectedSkills),
            "smartphone": state.smartphoneAnswer ?? "",
            "phone_requirement": state.phoneRequirementAnswer ?? "",
            "google_maps": state.googleMapsAnswer ?? "",
            "dob": "\(state.dobDay)-\(state.dobMonth)-\(state.dobYear)",
            "submittedAt": Timestamp()
        ]
        
        try await db.collection("users")
            .document(userId)
            .collection("questionnaireResponses")
            .document("answers")
            .setData(data)
    }
    
    // MARK: - Has Submitted
    
    func hasSubmittedQuestionnaire(userId: String) async throws -> Bool {
        let document = try await db.collection("users")
            .document(userId)
            .collection("questionnaireResponses")
            .document("answers")
            .getDocument()
        
        return document.exists
    }
}
