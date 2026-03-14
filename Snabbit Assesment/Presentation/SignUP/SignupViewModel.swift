//
//  SignupViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import Foundation

final class SignupViewModel: SignupViewModelProtocol {
    
    private let signupUseCase: SignupUseCase
    
    var isSignupEnabled: ((Bool) -> Void)?
    var onSignupSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private var email = ""
    private var username = ""
    private var password = ""
    private var confirmPassword = ""
    
    init(signupUseCase: SignupUseCase) {
        self.signupUseCase = signupUseCase
    }
    
    func updateEmail(_ email: String) {
        self.email = email
        validate()
    }
    
    func updateUsername(_ username: String) {
        self.username = username
        validate()
    }
    
    func updatePassword(_ password: String) {
        self.password = password
        validate()
    }
    
    func updateConfirmPassword(_ password: String) {
        self.confirmPassword = password
        validate()
    }
    
    func signup() {
        
        guard password == confirmPassword else {
            onError?("Passwords do not match")
            return
        }
        
        signupUseCase.execute(
            email: email,
            username: username,
            password: password
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success:
                    self?.onSignupSuccess?()
                    
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func validate() {
        
        let isValid =
        !email.isEmpty &&
        !username.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
        
        isSignupEnabled?(isValid)
    }
}
