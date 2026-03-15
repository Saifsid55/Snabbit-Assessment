//
//  GetCurrentUserUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

protocol GetCurrentUserUseCaseProtocol {
    func execute() async throws -> User
}

final class GetCurrentUserUseCase: GetCurrentUserUseCaseProtocol {
    
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> User {
        try await repository.fetchCurrentUser()
    }
}
