
import Foundation

protocol AuthRepositoryProtocol {
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func signup(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    )
    
    func getEmail(
        from username: String,
        completion: @escaping (Result<String, Error>) -> Void
    )
    
    func isUsernameAvailable(
        _ username: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    func saveUserProfile(
        uid: String,
        email: String,
        username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func logout() throws
}
