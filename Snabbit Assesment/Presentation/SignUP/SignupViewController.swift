//
//  SignupViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit


final class SignupViewController: UIViewController {
    
    private var viewModel: SignupViewModelProtocol
    private let container: AppDependencyContainer
    
    private let emailTF = UITextField()
    private let usernameTF = UITextField()
    private let passwordTF = UITextField()
    private let confirmPasswordTF = UITextField()
    
    private let signupButton = UIButton()
    
    init(viewModel: SignupViewModelProtocol,
         container: AppDependencyContainer) {
        
        self.viewModel = viewModel
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        bindViewModel()
    }
}

private extension SignupViewController {
    
    func setupUI() {
        
        emailTF.placeholder = "Email"
        usernameTF.placeholder = "Username"
        passwordTF.placeholder = "Password"
        confirmPasswordTF.placeholder = "Confirm Password"
        
        passwordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
        
        [emailTF, usernameTF, passwordTF, confirmPasswordTF].forEach {
            $0.borderStyle = .roundedRect
        }
        
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = .systemPurple
        signupButton.layer.cornerRadius = 8
        signupButton.isEnabled = false
        signupButton.alpha = 0.5
        
        let stack = UIStackView(arrangedSubviews: [
            emailTF,
            usernameTF,
            passwordTF,
            confirmPasswordTF,
            signupButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        emailTF.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        usernameTF.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordTF.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
    }
}

private extension SignupViewController {
    
    func bindViewModel() {
        
        viewModel.isSignupEnabled = { [weak self] enabled in
            guard let self else { return }
            self.signupButton.isEnabled = enabled
            self.signupButton.alpha = enabled ? 1 : 0.5
        }
        
        viewModel.onSignupSuccess = { [weak self] in
            print("Signup success")
            guard let self else { return }
            
            let questionnaireVC = container.makeQuestionnaireViewController()
            
            self.navigationController?.setViewControllers([questionnaireVC], animated: true)
        }
        
        viewModel.onError = { error in
            print(error)
        }
    }
}

private extension SignupViewController {
    
    @objc func emailChanged() {
        viewModel.updateEmail(emailTF.text ?? "")
    }
    
    @objc func usernameChanged() {
        viewModel.updateUsername(usernameTF.text ?? "")
    }
    
    @objc func passwordChanged() {
        viewModel.updatePassword(passwordTF.text ?? "")
    }
    
    @objc func confirmPasswordChanged() {
        viewModel.updateConfirmPassword(confirmPasswordTF.text ?? "")
    }
    
    @objc func signupTapped() {
        viewModel.signup()
    }
}
