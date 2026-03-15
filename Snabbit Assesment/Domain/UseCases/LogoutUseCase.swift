//
//  LogoutUseCase.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import Foundation

final class LogoutUseCase {
    
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() throws {
        try repository.logout()
    }
}
