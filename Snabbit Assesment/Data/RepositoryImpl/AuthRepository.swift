

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    
    private let authService: FirebaseAuthService
    private let userService: UserService
    
    init(
        authService: FirebaseAuthService,
        userService: UserService
    ) {
        self.authService = authService
        self.userService = userService
    }
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        authService.login(
            email: email,
            password: password,
            completion: completion
        )
    }
    
    func signup(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        authService.signup(
            email: email,
            password: password,
            completion: completion
        )
    }
    
    func getEmail(
        from username: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        userService.getEmail(
            from: username,
            completion: completion
        )
    }
    
    func isUsernameAvailable(
        _ username: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        
        userService.isUsernameAvailable(
            username,
            completion: completion
        )
    }
    
    func saveUserProfile(
        uid: String,
        email: String,
        username: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        userService.saveUserProfile(
            uid: uid,
            email: email,
            username: username,
            completion: completion
        )
    }
    
    func fetchCurrentUser() async throws -> User {
        guard let userID = authService.currentUserId() else {
            throw NSError(
                domain: "AuthRepository",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "User not logged in"]
            )
        }
        
        return try await userService.fetchCurrentUser(uid: userID)
    }
    
    func logout() throws {
        try authService.logout()
    }
}
