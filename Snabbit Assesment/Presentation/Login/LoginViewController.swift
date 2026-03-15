//
//  LoginViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//


import UIKit

final class LoginViewController: UIViewController {
    private enum Constants {
        static let titleText = "Login or Sign up to continue"
        static let usernamePlaceholder = "Enter your username"
        static let passwordPlaceholder = "Enter password"
        static let referralTitle = " I have a referral code"
        static let signupTitle = "Don't have an account? Sign up"
        static let termsFullText = "By clicking, I accept the Terms of Use & Privacy Policy"
        static let termsUnderlineRange1 = "Terms of Use"
        static let termsUnderlineRange2 = "Privacy Policy"
        static let continueTitle = "Continue"
        static let circleIcon = "circle"
        static let checkmarkIcon = "checkmark.circle.fill"
        static let titleFontSize: CGFloat = 22
        static let bodyFontSize: CGFloat = 16
        static let smallFontSize: CGFloat = 13
        static let tinyFontSize: CGFloat = 14
        static let continueButtonHeight: CGFloat = 52
        static let continueButtonRadius: CGFloat = 12
        static let fieldHeight: CGFloat = 52
        static let fieldCornerRadius: CGFloat = 12
        static let fieldBorderWidth: CGFloat = 1.5
        static let fieldInset: CGFloat = 16
        static let stackSpacing: CGFloat = 14
        static let horizontalPadding: CGFloat = 24
        static let stackTopPadding: CGFloat = 32
        static let bottomContainerPadding: CGFloat = 16
        static let bottomContainerSpacing: CGFloat = 12
        static let enabledAlpha: CGFloat = 1
        static let disabledAlpha: CGFloat = 0.5
        static let fieldInactiveBorderColor = UIColor.systemGray4.cgColor
        static let checkboxInactiveColor = UIColor.systemGray3
        static let disabledButtonColor = UIColor.systemGray5
    }

    private var viewModel: LoginViewModelProtocol
    private let container: AppDependencyContainer

    private var bottomContainerBottomConstraint: NSLayoutConstraint!

    // MARK: - Scroll content views

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

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let field = makeStyledTextField(placeholder: Constants.usernamePlaceholder)
        field.returnKeyType = .next
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.delegate = self
        field.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        return field
    }()

    private lazy var passwordTextField: UITextField = {
        let field = makeStyledTextField(placeholder: Constants.passwordPlaceholder)
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        field.delegate = self
        field.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        return field
    }()

    private lazy var referralCheckbox: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.referralTitle, for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.bodyFontSize)
        button.setImage(UIImage(systemName: Constants.circleIcon), for: .normal)
        button.tintColor = Constants.checkboxInactiveColor
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(referralTapped), for: .touchUpInside)
        return button
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.signupTitle, for: .normal)
        button.setTitleColor(AppColors.primaryButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.tinyFontSize)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        return button
    }()

    private lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            passwordTextField,
            referralCheckbox,
            signupButton
        ])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Bottom pinned views

    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = makeTermsAttributedText()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.continueTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.disabledButtonColor
        button.layer.cornerRadius = Constants.continueButtonRadius
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: Constants.bodyFontSize, weight: .semibold)
        button.heightAnchor.constraint(equalToConstant: Constants.continueButtonHeight).isActive = true
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()

    private lazy var bottomContainer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [termsLabel, continueButton])
        stack.axis = .vertical
        stack.spacing = Constants.bottomContainerSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    init(viewModel: LoginViewModelProtocol, container: AppDependencyContainer) {
        self.viewModel = viewModel
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

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

private extension LoginViewController {
    func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topStack)
        view.addSubview(bottomContainer)

        bottomContainerBottomConstraint = bottomContainer.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -Constants.bottomContainerPadding
        )

        NSLayoutConstraint.activate([
            // Scroll view fills space above bottom container
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

            // Bottom container pinned to bottom
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            bottomContainerBottomConstraint
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

    func makeTermsAttributedText() -> NSAttributedString {
        let baseFont = UIFont.systemFont(ofSize: Constants.smallFontSize)
        let baseColor = UIColor.gray
        let fullText = Constants.termsFullText
        let result = NSMutableAttributedString(
            string: fullText,
            attributes: [.font: baseFont, .foregroundColor: baseColor]
        )
        let underlineAttrs: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: baseColor
        ]
        [Constants.termsUnderlineRange1, Constants.termsUnderlineRange2].forEach { token in
            if let range = fullText.range(of: token) {
                result.addAttributes(underlineAttrs, range: NSRange(range, in: fullText))
            }
        }
        return result
    }

    func updateFieldBorder(_ field: UITextField, active: Bool) {
        UIView.animate(withDuration: 0.2) {
            field.layer.borderColor = active
                ? AppColors.primaryButton.cgColor
                : Constants.fieldInactiveBorderColor
        }
    }
}

// MARK: - Keyboard

private extension LoginViewController {
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

        let keyboardHeight = keyboardFrame.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        bottomContainerBottomConstraint.constant = -(keyboardHeight - safeAreaBottom + Constants.bottomContainerPadding)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve << 16)
        ) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        bottomContainerBottomConstraint.constant = -Constants.bottomContainerPadding

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve << 16)
        ) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Actions

private extension LoginViewController {
    @objc func usernameChanged() {
        viewModel.updateUsername(usernameTextField.text ?? "")
    }

    @objc func passwordChanged() {
        viewModel.updatePassword(passwordTextField.text ?? "")
    }

    @objc func loginTapped() {
        viewModel.login()
    }

    @objc func referralTapped() {
        referralCheckbox.isSelected.toggle()
        let icon = referralCheckbox.isSelected ? Constants.checkmarkIcon : Constants.circleIcon
        referralCheckbox.setImage(UIImage(systemName: icon), for: .normal)
        referralCheckbox.tintColor = referralCheckbox.isSelected
            ? AppColors.primaryButton
            : Constants.checkboxInactiveColor
    }

    @objc func signupTapped() {
        let signupVC = container.makeSignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - LoginViewModelDelegate

extension LoginViewController: LoginViewModelDelegate {
    func viewModelDidUpdateContinueState(_ isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
        continueButton.backgroundColor = isEnabled ? AppColors.primaryButton : Constants.disabledButtonColor
    }

    func viewModelDidLoginSuccessfully() {
        let questionnaireVC = container.makeQuestionnaireViewController()
        navigationController?.setViewControllers([questionnaireVC], animated: true)
    }

    func viewModelDidFailWithError(_ message: String) {
        print(message)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateFieldBorder(textField, active: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateFieldBorder(textField, active: false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
