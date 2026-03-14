//
//  LoginViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//


import UIKit

final class LoginViewController: UIViewController {
    
    private var viewModel: LoginViewModelProtocol
    private let container: AppDependencyContainer
    
    private let titleLabel = UILabel()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    
    private let referralCheckbox = UIButton()
    private let termsLabel = UILabel()
    
    private let continueButton = UIButton()
    private let signupButton = UIButton()
    
    let tap = UITapGestureRecognizer(
        target: LoginViewController.self,
        action: #selector(dismissKeyboard)
    )
    
    init(viewModel: LoginViewModelProtocol,
         container: AppDependencyContainer) {
        
        self.viewModel = viewModel
        self.container = container
        super.init(nibName: nil, bundle: nil)
        view.addGestureRecognizer(tap)
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

private extension LoginViewController {
    
    func setupUI() {
        
        // MARK: Title
        
        titleLabel.text = "Login or Sign up to continue"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        // MARK: Username
        
        usernameTextField.placeholder = "Enter your username"
        usernameTextField.borderStyle = .roundedRect
        
        // MARK: Password
        
        passwordTextField.placeholder = "Enter password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        // MARK: Referral Checkbox
        
        referralCheckbox.setTitle(
            " I have a referral code (optional)",
            for: .normal
        )
        
        referralCheckbox.setTitleColor(.darkGray, for: .normal)
        
        referralCheckbox.setImage(
            UIImage(systemName: "circle"),
            for: .normal
        )
        
        referralCheckbox.contentHorizontalAlignment = .leading
        
        referralCheckbox.addTarget(
            self,
            action: #selector(referralTapped),
            for: .touchUpInside
        )
        
        // MARK: Signup Button
        
        signupButton.setTitle(
            "Don't have an account? Sign up",
            for: .normal
        )
        
        signupButton.setTitleColor(.systemPurple, for: .normal)
        signupButton.contentHorizontalAlignment = .leading
        signupButton.addTarget(
            self,
            action: #selector(signupTapped),
            for: .touchUpInside
        )
        
        // MARK: Terms
        
        termsLabel.text =
        "By clicking, I accept the Terms of Use & Privacy Policy"
        
        termsLabel.font = .systemFont(ofSize: 12)
        termsLabel.textColor = .gray
        termsLabel.numberOfLines = 0
        termsLabel.textAlignment = .center
        
        // MARK: Continue
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = .systemPurple
        continueButton.layer.cornerRadius = 8
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        continueButton.addTarget(
            self,
            action: #selector(loginTapped),
            for: .touchUpInside
        )
        
        // MARK: Stack
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            passwordTextField,
            referralCheckbox,
            signupButton,
            termsLabel,
            continueButton
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
        
        // MARK: TextField Observers
        
        usernameTextField.addTarget(
            self,
            action: #selector(usernameChanged),
            for: .editingChanged
        )
        
        passwordTextField.addTarget(
            self,
            action: #selector(passwordChanged),
            for: .editingChanged
        )
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
    }
}

private extension LoginViewController {
    
    func bindViewModel() {
        
        viewModel.isContinueEnabled = { [weak self] enabled in
            
            self?.continueButton.isEnabled = enabled
            self?.continueButton.alpha = enabled ? 1 : 0.5
        }
        
        viewModel.onLoginSuccess = { [weak self] in
            guard let self else { return }
            
            let questionnaireVC = container.makeQuestionnaireViewController()
            
            self.navigationController?.setViewControllers([questionnaireVC], animated: true)
        }
        
        viewModel.onError = { error in
            print(error)
        }
    }
}

private extension LoginViewController {
    
    @objc
    func usernameChanged() {
        viewModel.updateUsername(usernameTextField.text ?? "")
    }
    
    @objc
    func passwordChanged() {
        viewModel.updatePassword(passwordTextField.text ?? "")
    }
    
    @objc
    func loginTapped() {
        viewModel.login()
    }
    
    @objc
    func referralTapped() {
        
        referralCheckbox.isSelected.toggle()
        
        let image = referralCheckbox.isSelected
        ? UIImage(systemName: "checkmark.circle.fill")
        : UIImage(systemName: "circle")
        
        referralCheckbox.setImage(image, for: .normal)
    }
    
    @objc
    func signupTapped() {
        print("Signup tapped")
        let signupVC = container.makeSignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
