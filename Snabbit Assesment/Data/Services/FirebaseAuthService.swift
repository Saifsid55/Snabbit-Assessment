import Foundation
import FirebaseAuth

final class FirebaseAuthService {
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
    }
    
    func signup(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(.failure(NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "User creation failed"]
                )))
                return
            }
            
            completion(.success(uid))
        }
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
}
