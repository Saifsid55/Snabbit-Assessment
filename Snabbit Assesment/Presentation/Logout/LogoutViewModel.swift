//
//  LogoutViewModel.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import Foundation

final class LogoutViewModel: LogoutViewModelProtocol {
    
    private let logoutUseCase: LogoutUseCase
    private let resetBreakUseCase: ResetBreakUseCaseProtocol
    
    var onLogoutSuccess: (() -> Void)?
    var onResetSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(
        logoutUseCase: LogoutUseCase,
        resetBreakUseCase: ResetBreakUseCaseProtocol
    ) {
        self.logoutUseCase = logoutUseCase
        self.resetBreakUseCase = resetBreakUseCase
    }
    
    func logout() {
        
        do {
            try logoutUseCase.execute()
            onLogoutSuccess?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
    
    func resetBreak() {
        
        Task {
            do {
                try await resetBreakUseCase.execute()
                onResetSuccess?()
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
}
