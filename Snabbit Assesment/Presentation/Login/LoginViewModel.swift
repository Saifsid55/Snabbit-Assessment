//
//  LoginViewModelProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import Foundation

final class LoginViewModel: LoginViewModelProtocol {
    
    private let loginUseCase: LoginUseCase
    
    var isContinueEnabled: ((Bool) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private var username = ""
    private var password = ""
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func updateUsername(_ username: String) {
        self.username = username
        validate()
    }
    
    func updatePassword(_ password: String) {
        self.password = password
        validate()
    }
    
    private func validate() {
        let isValid = !username.isEmpty && !password.isEmpty
        isContinueEnabled?(isValid)
    }
    
    func login() {
        
        loginUseCase.execute(
            email: username,
            password: password
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success:
                    self?.onLoginSuccess?()
                    
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
