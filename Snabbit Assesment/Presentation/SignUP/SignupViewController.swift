//
//  SignupViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

protocol SignupViewModelDelegate: AnyObject {
    func viewModelDidUpdateSignupState(_ isEnabled: Bool)
    func viewModelDidSignupSuccessfully()
    func viewModelDidFailWithError(_ message: String)
}

protocol SignupViewModelProtocol: AnyObject {
    var delegate: SignupViewModelDelegate? { get set }
    func updateEmail(_ email: String)
    func updateUsername(_ username: String)
    func updatePassword(_ password: String)
    func updateConfirmPassword(_ confirmPassword: String)
    func signup()
}

final class SignupViewController: UIViewController {
    private enum Constants {
        static let emailPlaceholder = "Email"
        static let usernamePlaceholder = "Username"
        static let passwordPlaceholder = "Password"
        static let confirmPasswordPlaceholder = "Confirm Password"
        static let signupTitle = "Sign Up"
        static let bodyFontSize: CGFloat = 16
        static let smallFontSize: CGFloat = 13
        static let fieldHeight: CGFloat = 52
        static let fieldCornerRadius: CGFloat = 12
        static let fieldBorderWidth: CGFloat = 1.5
        static let fieldInset: CGFloat = 16
        static let signupButtonHeight: CGFloat = 52
        static let signupButtonRadius: CGFloat = 12
        static let stackSpacing: CGFloat = 14
        static let horizontalPadding: CGFloat = 24
        static let stackTopPadding: CGFloat = 32
        static let bottomContainerPadding: CGFloat = 16
        static let enabledAlpha: CGFloat = 1
        static let disabledAlpha: CGFloat = 0.5
        static let fieldInactiveBorderColor = UIColor.systemGray4.cgColor
        static let disabledButtonColor = UIColor.systemGray5
        static let animDuration: CGFloat = 0.2
    }
    
    private var viewModel: SignupViewModelProtocol
    private let container: AppDependencyContainer
    private var bottomContainerBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = false
        sv.showsVerticalScrollIndicator = false
        sv.keyboardDismissMode = .interactive
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var emailTF: UITextField = {
        let field = makeStyledTextField(placeholder: Constants.emailPlaceholder)
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.delegate = self
        field.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        return field
    }()
    
    private lazy var usernameTF: UITextField = {
        let field = makeStyledTextField(placeholder: Constants.usernamePlaceholder)
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.delegate = self
        field.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        return field
    }()
    
    private lazy var passwordTF: UITextField = {
        let field = makeStyledTextField(placeholder: Constants.passwordPlaceholder)
        field.isSecureTextEntry = true
        field.returnKeyType = .next
        field.delegate = self
        field.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        return field
    }()
    
    private lazy var confirmPasswordTF: UITextField = {
        let field = makeStyledTextField(placeholder: Constants.confirmPasswordPlaceholder)
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        field.delegate = self
        field.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        return field
    }()
    
    private lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTF, usernameTF, passwordTF, confirmPasswordTF])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.signupTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.disabledButtonColor
        button.layer.cornerRadius = Constants.signupButtonRadius
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: Constants.bodyFontSize, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: Constants.signupButtonHeight).isActive = true
        button.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Init
    
    init(viewModel: SignupViewModelProtocol, container: AppDependencyContainer) {
        self.viewModel = viewModel
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.delegate = self
        setupUI()
        registerKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup

private extension SignupViewController {
    func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addSubview(signupButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topStack)
        view.addSubview(bottomContainer)
        
        bottomContainerBottomConstraint = bottomContainer.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -Constants.bottomContainerPadding
        )
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -Constants.bottomContainerPadding),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            topStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.stackTopPadding),
            topStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            topStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            topStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            bottomContainerBottomConstraint,
            
            signupButton.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
            signupButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            signupButton.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor)
        ])
    }
    
    func makeStyledTextField(placeholder: String) -> UITextField {
        let field = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray3,
            .font: UIFont.systemFont(ofSize: Constants.bodyFontSize)
        ]
        field.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        field.font = .systemFont(ofSize: Constants.bodyFontSize)
        field.layer.borderColor = Constants.fieldInactiveBorderColor
        field.layer.borderWidth = Constants.fieldBorderWidth
        field.layer.cornerRadius = Constants.fieldCornerRadius
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.fieldInset, height: 1))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.fieldInset, height: 1))
        field.rightViewMode = .always
        field.heightAnchor.constraint(equalToConstant: Constants.fieldHeight).isActive = true
        return field
    }
    
    func updateFieldBorder(_ field: UITextField, active: Bool) {
        UIView.animate(withDuration: Constants.animDuration) {
            field.layer.borderColor = active
            ? AppColors.primaryButton.cgColor
            : Constants.fieldInactiveBorderColor
        }
    }
}

// MARK: - Keyboard

private extension SignupViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        let safeAreaBottom = view.safeAreaInsets.bottom
        bottomContainerBottomConstraint.constant = -(keyboardFrame.height - safeAreaBottom + Constants.bottomContainerPadding)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16)) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        bottomContainerBottomConstraint.constant = -Constants.bottomContainerPadding
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16)) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Actions

private extension SignupViewController {
    @objc func emailChanged() { viewModel.updateEmail(emailTF.text ?? "") }
    @objc func usernameChanged() { viewModel.updateUsername(usernameTF.text ?? "") }
    @objc func passwordChanged() { viewModel.updatePassword(passwordTF.text ?? "") }
    @objc func confirmPasswordChanged() { viewModel.updateConfirmPassword(confirmPasswordTF.text ?? "") }
    @objc func signupTapped() { viewModel.signup() }
    @objc func dismissKeyboard() { view.endEditing(true) }
}

// MARK: - SignupViewModelDelegate

extension SignupViewController: SignupViewModelDelegate {
    func viewModelDidUpdateSignupState(_ isEnabled: Bool) {
        signupButton.isEnabled = isEnabled
        signupButton.backgroundColor = isEnabled ? AppColors.primaryButton : Constants.disabledButtonColor
    }
    
    func viewModelDidSignupSuccessfully() {
        let questionnaireVC = container.makeQuestionnaireViewController()
        navigationController?.setViewControllers([questionnaireVC], animated: true)
    }
    
    func viewModelDidFailWithError(_ message: String) {
        print(message)
    }
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateFieldBorder(textField, active: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateFieldBorder(textField, active: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF: usernameTF.becomeFirstResponder()
        case usernameTF: passwordTF.becomeFirstResponder()
        case passwordTF: confirmPasswordTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}
