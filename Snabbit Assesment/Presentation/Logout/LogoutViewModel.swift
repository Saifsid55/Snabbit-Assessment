//
//  LogoutViewModel.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import Foundation

final class LogoutViewModel: LogoutViewModelProtocol {
    
    private let logoutUseCase: LogoutUseCase
    
    var onLogoutSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
    }
    
    func logout() {
        
        do {
            try logoutUseCase.execute()
            onLogoutSuccess?()
            
        } catch {
            onError?(error.localizedDescription)
        }
    }
}
