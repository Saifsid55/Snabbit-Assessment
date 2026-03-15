
import Foundation
import FirebaseFirestore

final class UserService {
    
    private let db = Firestore.firestore()
    
    func getEmail(
        from username: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard
                    let document = snapshot?.documents.first,
                    let email = document.data()["email"] as? String
                else {
                    completion(.failure(NSError(
                        domain: "",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "Username not found"]
                    )))
                    return
                }
                
                completion(.success(email))
            }
    }
    
    func isUsernameAvailable(
        _ username: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let snapshot = snapshot, snapshot.documents.isEmpty {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
    }
    
    func saveUserProfile(
        uid: String,
        email: String,
        username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        db.collection("users")
            .document(uid)
            .setData([
                "email": email,
                "username": username,
                "createdAt": Timestamp()
            ]) { error in
                
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    
    func fetchCurrentUser(uid: String) async throws -> User {
        
        let document = try await db
            .collection("users")
            .document(uid)
            .getDocument()
        
        guard let data = document.data() else {
            throw NSError(
                domain: "UserService",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "User not found"]
            )
        }
        
        guard
            let email = data["email"] as? String,
            let username = data["username"] as? String
        else {
            throw NSError(
                domain: "UserService",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Invalid user data"]
            )
        }
        
        return User(
            uid: uid,
            email: email,
            username: username
        )
    }
}
