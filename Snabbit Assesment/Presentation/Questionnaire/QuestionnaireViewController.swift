//
//  QuestionnaireViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import UIKit

// MARK: - Layout Constants
private enum Layout {
    static let horizontalPadding: CGFloat = 20
    static let progressBarHeight: CGFloat = 6
    static let progressBarTopPadding: CGFloat = 12
    static let progressBarCornerRadius: CGFloat = 3
    static let scrollViewTopPadding: CGFloat = 20
    static let scrollViewBottomPadding: CGFloat = 8
    static let contentStackSpacing: CGFloat = 20
    static let continueButtonHeight: CGFloat = 52
    static let continueButtonCornerRadius: CGFloat = 8
    static let continueButtonBottomPadding: CGFloat = 16
    static let continueButtonHorizontalPadding: CGFloat = 16
    static let dobFieldWidth: CGFloat = 72
    static let dobFieldHeight: CGFloat = 52
    static let dobFieldCornerRadius: CGFloat = 14
    static let dobFieldBorderWidth: CGFloat = 1
    static let dobFieldSpacing: CGFloat = 14
    static let dobErrorLabelTopPadding: CGFloat = 6
    static let dobErrorLabelFontSize: CGFloat = 12
    static let singleSelectSpacing: CGFloat = 24
    static let multiSelectSpacing: CGFloat = 20
    static let sectionTitleFontSize: CGFloat = 16
    static let radioRowSpacing: CGFloat = 8
    static let headerTopPadding: CGFloat = 16
    static let headerBottomPadding: CGFloat = 8
}

// MARK: - ViewController
final class QuestionnaireViewController: UIViewController {
    
    // MARK: - Dependencies
    private var viewModel: QuestionnaireViewModelProtocol
    private let container: AppDependencyContainer
    
    // MARK: - Computed Views
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.contentStackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = AppColors.primaryButton
        button.layer.cornerRadius = Layout.continueButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.progressTrack
        view.layer.cornerRadius = Layout.progressBarCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressFill: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.progressFill
        view.layer.cornerRadius = Layout.progressBarCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Constraints & State
    
    private var progressWidthConstraint: NSLayoutConstraint!
    private var dobFields: [UITextField] = []
    private var dobErrorLabel: UILabel?
    
    // MARK: - Init
    
    init(viewModel: QuestionnaireViewModelProtocol, container: AppDependencyContainer) {
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
        setupProgressBar()
        setupContinueButton()
        setupLayout()
        viewModel.delegate = self
        Task { await viewModel.loadQuestions() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardObservers()
    }
    
    // MARK: - Progress Update
    
    func updateProgress(_ progress: Float) {
        let maxWidth = progressContainer.bounds.width
        progressWidthConstraint.constant = maxWidth * CGFloat(progress)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Layout

private extension QuestionnaireViewController {
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: Layout.scrollViewTopPadding),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -Layout.scrollViewBottomPadding),
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layout.horizontalPadding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layout.horizontalPadding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(Layout.horizontalPadding * 2))
        ])
    }
    
    func setupProgressBar() {
        view.addSubview(progressContainer)
        progressContainer.addSubview(progressFill)
        progressWidthConstraint = progressFill.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            progressContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.progressBarTopPadding),
            progressContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
            progressContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
            progressContainer.heightAnchor.constraint(equalToConstant: Layout.progressBarHeight),
            progressFill.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressFill.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            progressWidthConstraint
        ])
    }
    
    func setupContinueButton() {
        view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.continueButtonHorizontalPadding),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.continueButtonHorizontalPadding),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.continueButtonBottomPadding),
            continueButton.heightAnchor.constraint(equalToConstant: Layout.continueButtonHeight)
        ])
    }
}

// MARK: - Dynamic UI Builder

private extension QuestionnaireViewController {
    
    func buildUI(from questions: [QuestionnaireQuestion]) {
        questions.forEach { question in
            switch question.type {
            case .multiSelect:
                setupMultiSelectSection(title: question.title, options: question.options ?? [])
            case .singleSelect:
                setupSingleSelectSection(questionId: question.id, title: question.title, options: question.options ?? [])
            case .date:
                setupDOBSection(title: question.title)
            }
        }
    }
}

// MARK: - Multi Select

private extension QuestionnaireViewController {
    
    func setupMultiSelectSection(title: String, options: [String]) {
        let header = SectionHeaderView(title: title, subtitle: "")
        contentStack.addArrangedSubview(header)
        
        var index = 0
        while index < options.count {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = Layout.multiSelectSpacing
            row.distribution = .fillEqually
            
            let firstOption = options[index]
            let first = CheckboxView(title: firstOption)
            first.onToggle = { [weak self] in self?.viewModel.toggleSkill(firstOption) }
            row.addArrangedSubview(first)
            
            if index + 1 < options.count {
                let secondOption = options[index + 1]
                let second = CheckboxView(title: secondOption)
                second.onToggle = { [weak self] in self?.viewModel.toggleSkill(secondOption) }
                row.addArrangedSubview(second)
            }
            
            contentStack.addArrangedSubview(row)
            index += 2
        }
    }
}

// MARK: - Single Select

private extension QuestionnaireViewController {
    
    func setupSingleSelectSection(questionId: String, title: String, options: [String]) {
        let label = UILabel()
        label.text = title
        contentStack.addArrangedSubview(label)
        
        guard options.count == 2 else { return }
        
        let (firstRow, firstRadio) = makeRadioRow(title: options[0])
        let (secondRow, secondRadio) = makeRadioRow(title: options[1])
        
        firstRadio.onTap = { [weak self] in
            firstRadio.setSelected(true)
            secondRadio.setSelected(false)
            self?.viewModel.selectSingleOption(questionId: questionId, value: options[0])
        }
        
        secondRadio.onTap = { [weak self] in
            firstRadio.setSelected(false)
            secondRadio.setSelected(true)
            self?.viewModel.selectSingleOption(questionId: questionId, value: options[1])
        }
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [firstRow, secondRow, spacer])
        stack.axis = .horizontal
        stack.spacing = Layout.singleSelectSpacing
        stack.alignment = .center
        contentStack.addArrangedSubview(stack)
    }
}

// MARK: - DOB

private extension QuestionnaireViewController {
    
    func setupDOBSection(title: String) {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: Layout.sectionTitleFontSize, weight: .semibold)
        contentStack.addArrangedSubview(label)
        
        let day = makeDOBField("DD", maxDigits: QuestionnaireConstants.DOB.dayLength)
        let month = makeDOBField("MM", maxDigits: QuestionnaireConstants.DOB.monthLength)
        let year = makeDOBField("YYYY", maxDigits: QuestionnaireConstants.DOB.yearLength)
        dobFields = [day, month, year]
        
        let fieldStack = UIStackView(arrangedSubviews: [day, month, year])
        fieldStack.axis = .horizontal
        fieldStack.spacing = Layout.dobFieldSpacing
        fieldStack.translatesAutoresizingMaskIntoConstraints = false
        
        let errorLabel = UILabel()
        errorLabel.font = .systemFont(ofSize: Layout.dobErrorLabelFontSize, weight: .regular)
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 1
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        dobErrorLabel = errorLabel
        
        let wrapper = UIView()
        wrapper.addSubview(fieldStack)
        wrapper.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            fieldStack.topAnchor.constraint(equalTo: wrapper.topAnchor),
            fieldStack.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            errorLabel.topAnchor.constraint(equalTo: fieldStack.bottomAnchor, constant: Layout.dobErrorLabelTopPadding),
            errorLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        
        contentStack.addArrangedSubview(wrapper)
    }
    
    func makeDOBField(_ placeholder: String, maxDigits: Int) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.textAlignment = .center
        tf.font = .systemFont(ofSize: Layout.sectionTitleFontSize, weight: .medium)
        tf.keyboardType = .numberPad
        tf.delegate = self
        tf.tag = maxDigits
        tf.layer.cornerRadius = Layout.dobFieldCornerRadius
        tf.layer.borderWidth = Layout.dobFieldBorderWidth
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tf.widthAnchor.constraint(equalToConstant: Layout.dobFieldWidth),
            tf.heightAnchor.constraint(equalToConstant: Layout.dobFieldHeight)
        ])
//        attachDoneToolbar(to: tf)
        tf.addTarget(self, action: #selector(dobChanged), for: .editingChanged)
        return tf
    }
}

// MARK: - Helpers

private extension QuestionnaireViewController {
    
    func makeRadioRow(title: String) -> (UIView, RadioOptionView) {
        let radio = RadioOptionView()
        let label = UILabel()
        label.text = title
        let stack = UIStackView(arrangedSubviews: [radio, label])
        stack.axis = .horizontal
        stack.spacing = Layout.radioRowSpacing
        return (stack, radio)
    }
}

// MARK: - Navigation

private extension QuestionnaireViewController {
    
    func navigateToBreakScreen() {
        let breakVC = container.makeBreakViewController()
        navigationController?.pushViewController(breakVC, animated: true)
    }
}

// MARK: - Actions

@objc private extension QuestionnaireViewController {
    
    func dobChanged() {
        guard dobFields.count == 3 else { return }
        viewModel.updateDOB(
            day: dobFields[0].text ?? "",
            month: dobFields[1].text ?? "",
            year: dobFields[2].text ?? ""
        )
    }
    
    func didTapContinue() {
        Task { await viewModel.submit() }
    }
}

// MARK: - QuestionnaireViewModelDelegate

extension QuestionnaireViewController: QuestionnaireViewModelDelegate {
    
    func didLoadQuestions(_ questions: [QuestionnaireQuestion]) {
        MainActor.assumeIsolated {
            buildUI(from: questions)
        }
    }
    
    func didSubmitSuccess() {
        MainActor.assumeIsolated {
            navigateToBreakScreen()
        }
    }
    
    func didUpdateProgress(_ progress: Float) {
        MainActor.assumeIsolated {
            updateProgress(progress)
        }
    }
    
    func didUpdateContinueEnabled(_ enabled: Bool) {
        MainActor.assumeIsolated {
            continueButton.isEnabled = enabled
            continueButton.alpha = enabled ? 1 : 0.5
        }
    }
}

// MARK: - Keyboard Avoidance

extension QuestionnaireViewController {
    
    func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func attachDoneToolbar(to textField: UITextField) {
        let bar = UIToolbar()
        bar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .prominent, target: nil, action: #selector(UIResponder.resignFirstResponder))
        bar.items = [flex, done]
        textField.inputAccessoryView = bar
    }
    
    @objc func dismissKeyboard() { view.endEditing(true) }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        }
        
        guard let activeField = dobFields.first(where: { $0.isFirstResponder }) else { return }
        let fieldRect = activeField.convert(activeField.bounds, to: scrollView)
        let targetRect = fieldRect.insetBy(dx: 0, dy: -16)
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.scrollView.scrollRectToVisible(targetRect, animated: false)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
}

// MARK: - UITextFieldDelegate

extension QuestionnaireViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard dobFields.contains(textField) else { return true }
        let maxDigits = textField.tag
        let current = (textField.text ?? "") as NSString
        let proposed = current.replacingCharacters(in: range, with: string)
        let allDigits = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        guard string.isEmpty || allDigits else { return false }
        return proposed.count <= maxDigits
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        guard dobFields.contains(textField) else { return }
        let text = textField.text ?? ""
        let maxDigits = textField.tag
        
        guard text.count == maxDigits else {
            showDOBError(nil)
            textField.layer.borderColor = UIColor.systemGray4.cgColor
            return
        }
        
        if textField === dobFields[safe: 0], let value = Int(text) {
            guard (1...31).contains(value) else {
                textField.layer.borderColor = UIColor.systemRed.cgColor
                showDOBError("Enter a valid day (01 – 31)")
                return
            }
        }
        
        if textField === dobFields[safe: 1], let value = Int(text) {
            guard (1...12).contains(value) else {
                textField.layer.borderColor = UIColor.systemRed.cgColor
                showDOBError("Enter a valid month (01 – 12)")
                return
            }
        }
        
        showDOBError(nil)
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        
        if maxDigits == 2, let value = Int(text), value < 10, !text.hasPrefix("0") {
            textField.text = String(format: "%02d", value)
        }
        
        if let idx = dobFields.firstIndex(of: textField) {
            let next = idx + 1
            if next < dobFields.count {
                dobFields[next].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard dobFields.contains(textField) else { return }
        showDOBError(nil)
        textField.layer.borderColor = UIColor.systemGray4.cgColor
    }
}

// MARK: - DOB Error Label

extension QuestionnaireViewController {
    
    func showDOBError(_ message: String?) {
        guard let label = dobErrorLabel else { return }
        if let msg = message {
            label.text = msg
            label.isHidden = false
        } else {
            label.isHidden = true
            label.text = nil
        }
    }
}

// MARK: - Safe Array Subscript

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
