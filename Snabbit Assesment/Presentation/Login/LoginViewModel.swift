//
//  LoginViewModelProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func viewModelDidUpdateContinueState(_ isEnabled: Bool)
    func viewModelDidLoginSuccessfully()
    func viewModelDidFailWithError(_ message: String)
}

final class LoginViewModel: LoginViewModelProtocol {
    private enum Constants {
        static let minUsernameLength = 1
        static let minPasswordLength = 1
    }

    weak var delegate: LoginViewModelDelegate?
    private let loginUseCase: LoginUseCase
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

    func login() {
        loginUseCase.execute(email: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.delegate?.viewModelDidLoginSuccessfully()
                case .failure(let error):
                    self?.delegate?.viewModelDidFailWithError(error.localizedDescription)
                }
            }
        }
    }

    private func validate() {
        let isValid = username.count >= Constants.minUsernameLength
            && password.count >= Constants.minPasswordLength
        delegate?.viewModelDidUpdateContinueState(isValid)
    }
}
