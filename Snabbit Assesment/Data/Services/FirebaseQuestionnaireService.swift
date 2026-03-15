//
//  FirebaseQuestionnaireService.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import FirebaseFirestore

final class FirebaseQuestionnaireService {
    
    private let db = Firestore.firestore()
    
    // MARK: Fetch Questions
    
    func fetchQuestions(
        completion: @escaping (Result<[QuestionnaireQuestion], Error>) -> Void
    ) {
        
        db.collection("questionnaires")
            .order(by: "order")
            .getDocuments { snapshot, error in
                
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let questions = documents.compactMap { doc -> QuestionnaireQuestion? in
                    
                    let data = doc.data()
                    
                    guard
                        let title = data["title"] as? String,
                        let typeString = data["type"] as? String,
                        let type = QuestionType(rawValue: typeString)
                    else { return nil }
                    
                    let options = data["options"] as? [String]
                    
                    return QuestionnaireQuestion(
                        id: doc.documentID,
                        title: title,
                        type: type,
                        options: options
                    )
                }
                
                completion(.success(questions))
            }
    }
    
    
    // MARK: Save Responses
    
    func submitResponses(
        userId: String,
        state: QuestionnaireState,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        let data: [String: Any] = [
            
            "skills": Array(state.selectedSkills),
            
            "smartphone": state.smartphoneAnswer ?? "",
            "phone_requirement": state.phoneRequirementAnswer ?? "",
            "google_maps": state.googleMapsAnswer ?? "",
            
            "dob": "\(state.dobDay)-\(state.dobMonth)-\(state.dobYear)",
            
            "submittedAt": Timestamp()
        ]
        
        db.collection("users")
            .document(userId)
            .collection("questionnaireResponses")
            .document("answers")
            .setData(data) { error in
                
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func hasSubmittedQuestionnaire(
        userId: String
    ) async throws -> Bool {
        
        let document = try await db
            .collection("users")
            .document(userId)
            .collection("questionnaireResponses")
            .document("answers")
            .getDocument()
        
        return document.exists
    }
    
}
