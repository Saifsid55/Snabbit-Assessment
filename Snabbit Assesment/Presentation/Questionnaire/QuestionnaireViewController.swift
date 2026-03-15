//
//  QuestionnaireViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class QuestionnaireViewController: UIViewController {
    
    private var viewModel: QuestionnaireViewModelProtocol
    private let container: AppDependencyContainer
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let continueButton = UIButton()
    
    private let progressContainer = UIView()
    private let progressFill = UIView()
    private var progressWidthConstraint: NSLayoutConstraint!
    private var dobFields: [UITextField] = []
    private var dobErrorLabel: UILabel?
    
    
    init(
        viewModel: QuestionnaireViewModelProtocol,
        container: AppDependencyContainer
    ) {
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
        
        setupProgressBar()
        setupContinueButton()
        setupLayout()
        bindViewModel()
        
        viewModel.loadQuestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardObservers()   // ← add
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardObservers() // ← add
    }
    
    func updateProgress(_ progress: Float) {
        
        let maxWidth = progressContainer.bounds.width
        progressWidthConstraint.constant = maxWidth * CGFloat(progress)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

//
// MARK: - Layout
//

private extension QuestionnaireViewController {
    
    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: progressContainer.bottomAnchor,
                constant: 20
            ),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: continueButton.topAnchor,
                constant: -8
            )
        ])
        
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: 20
            ),
            contentStack.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -20
            ),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor,
                constant: -40
            )
        ])
    }
}

//
// MARK: - Progress Bar
//

private extension QuestionnaireViewController {
    
    func setupProgressBar() {
        
        progressContainer.backgroundColor = AppColors.progressTrack
        progressContainer.layer.cornerRadius = 3
        
        progressFill.backgroundColor = AppColors.progressFill
        progressFill.layer.cornerRadius = 3
        
        view.addSubview(progressContainer)
        progressContainer.addSubview(progressFill)
        
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        progressFill.translatesAutoresizingMaskIntoConstraints = false
        
        progressWidthConstraint =
        progressFill.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            
            progressContainer.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 12
            ),
            progressContainer.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            progressContainer.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            progressContainer.heightAnchor.constraint(equalToConstant: 6),
            
            progressFill.leadingAnchor.constraint(
                equalTo: progressContainer.leadingAnchor
            ),
            progressFill.topAnchor.constraint(
                equalTo: progressContainer.topAnchor
            ),
            progressFill.bottomAnchor.constraint(
                equalTo: progressContainer.bottomAnchor
            ),
            
            progressWidthConstraint
        ])
    }
}

//
// MARK: - ViewModel Binding
//

private extension QuestionnaireViewController {
    
    func bindViewModel() {
        
        viewModel.onQuestionsLoaded = { [weak self] questions in
            
            DispatchQueue.main.async {
                self?.buildUI(from: questions)
            }
        }
        
        viewModel.onSubmitSuccess = { [weak self] in
            
            DispatchQueue.main.async {
                self?.navigateToBreakScreen()
            }
        }
        
        viewModel.onProgressChanged = { [weak self] progress in
            
            DispatchQueue.main.async {
                self?.updateProgress(progress)
            }
        }
        
        viewModel.isContinueEnabled = { [weak self] enabled in
            
            DispatchQueue.main.async {
                self?.continueButton.isEnabled = enabled
                self?.continueButton.alpha = enabled ? 1 : 0.5
            }
        }
    }
}

//
// MARK: - Dynamic UI Builder
//

private extension QuestionnaireViewController {
    
    func buildUI(from questions: [QuestionnaireQuestion]) {
        
        questions.forEach { question in
            
            switch question.type {
                
            case .multiSelect:
                setupMultiSelectSection(
                    title: question.title,
                    options: question.options ?? []
                )
                
            case .singleSelect:
                setupSingleSelectSection(
                    questionId: question.id,
                    title: question.title,
                    options: question.options ?? []
                )
            case .date:
                setupDOBSection(title: question.title)
            }
        }
    }
}

//
// MARK: - Multi Select
//

private extension QuestionnaireViewController {
    
    func setupMultiSelectSection(
        title: String,
        options: [String]
    ) {
        
        let header = SectionHeaderView(
            title: title,
            subtitle: ""
        )
        
        contentStack.addArrangedSubview(header)
        
        var index = 0
        
        while index < options.count {
            
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 20
            row.distribution = .fillEqually
            
            let firstOption = options[index]
            let first = CheckboxView(title: firstOption)
            
            first.onToggle = { [weak self] in
                self?.viewModel.toggleSkill(firstOption)
            }
            
            row.addArrangedSubview(first)
            
            if index + 1 < options.count {
                
                let secondOption = options[index + 1]
                let second = CheckboxView(title: secondOption)
                
                second.onToggle = { [weak self] in
                    self?.viewModel.toggleSkill(secondOption)
                }
                row.addArrangedSubview(second)
            }
            
            contentStack.addArrangedSubview(row)
            
            index += 2
        }
    }
}

//
// MARK: - Single Select
//

private extension QuestionnaireViewController {
    
    func setupSingleSelectSection(
        questionId: String,
        title: String,
        options: [String]
    ) {
        
        let label = UILabel()
        label.text = title
        
        contentStack.addArrangedSubview(label)
        
        guard options.count == 2 else { return }
        
        let (firstRow, firstRadio) = makeRadioRow(title: options[0])
        let (secondRow, secondRadio) = makeRadioRow(title: options[1])
        
        firstRadio.onTap = { [weak self] in
            firstRadio.setSelected(true)
            secondRadio.setSelected(false)
            
            self?.viewModel.selectSingleOption(
                questionId: questionId,
                value: options[0]
            )
        }
        
        secondRadio.onTap = { [weak self] in
            firstRadio.setSelected(false)
            secondRadio.setSelected(true)
            
            self?.viewModel.selectSingleOption(
                questionId: questionId,
                value: options[1]
            )
        }
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [
            firstRow,
            secondRow,
            spacer
        ])
        stack.axis     = .horizontal
        stack.spacing  = 24
        stack.alignment = .center
        
        contentStack.addArrangedSubview(stack)
    }
}

// MARK: - DOB

private extension QuestionnaireViewController {
    
    func setupDOBSection(title: String) {
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        contentStack.addArrangedSubview(label)
        
        
        let day   = makeDOBField("DD",   maxDigits: 2)
        let month = makeDOBField("MM",   maxDigits: 2)
        let year  = makeDOBField("YYYY", maxDigits: 4)
        
        dobFields = [day, month, year]
        
        // ── Field row ────────────────────────────────────────────────
        let fieldStack = UIStackView(arrangedSubviews: [day, month, year])
        fieldStack.axis    = .horizontal
        fieldStack.spacing = 14
        fieldStack.translatesAutoresizingMaskIntoConstraints = false
        
        // ── Red error label (hidden by default) ──────────────────────
        let errorLabel = UILabel()
        errorLabel.font      = .systemFont(ofSize: 12, weight: .regular)
        errorLabel.textColor = .systemRed
        errorLabel.isHidden  = true
        errorLabel.numberOfLines = 1
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dobErrorLabel = errorLabel
        
       
        let wrapper = UIView()
        wrapper.addSubview(fieldStack)
        wrapper.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            // Fields sit at the top-left of wrapper
            fieldStack.topAnchor.constraint(equalTo: wrapper.topAnchor),
            fieldStack.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            
            // Error label sits 6 pt below the fields, also left-aligned
            errorLabel.topAnchor.constraint(equalTo: fieldStack.bottomAnchor, constant: 6),
            errorLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        
        contentStack.addArrangedSubview(wrapper)
    }
    
    func makeDOBField(_ placeholder: String, maxDigits: Int) -> UITextField {
        
        let tf            = UITextField()
        tf.placeholder    = placeholder
        tf.textAlignment  = .center
        tf.font           = .systemFont(ofSize: 16, weight: .medium)
        tf.keyboardType   = .numberPad
        tf.delegate       = self
        tf.tag            = maxDigits
        
        tf.layer.cornerRadius = 14
        tf.layer.borderWidth  = 1
        tf.layer.borderColor  = UIColor.systemGray4.cgColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tf.widthAnchor.constraint(equalToConstant: 72),
            tf.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        attachDoneToolbar(to: tf)
        tf.addTarget(self, action: #selector(dobChanged), for: .editingChanged)
        
        return tf
    }
}
//
// MARK: - Helpers
//

private extension QuestionnaireViewController {
    
    func makeRadioRow(
        title: String
    ) -> (UIView, RadioOptionView) {
        
        let radio = RadioOptionView()
        
        let label = UILabel()
        label.text = title
        
        let stack = UIStackView(arrangedSubviews: [
            radio,
            label
        ])
        
        stack.axis = .horizontal
        stack.spacing = 8
        
        return (stack, radio)
    }
}

//
// MARK: - Continue Button
//

private extension QuestionnaireViewController {
    
    func setupContinueButton() {
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = AppColors.primaryButton
        continueButton.layer.cornerRadius = 8
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            continueButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            continueButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            continueButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        
        continueButton.addTarget(
            self,
            action: #selector(didTapContinue),
            for: .touchUpInside
        )
    }
}

//
// MARK: - Navigation
//

private extension QuestionnaireViewController {
    
    func navigateToBreakScreen() {
        
        let breakVC = container.makeBreakViewController()
        
        navigationController?.pushViewController(
            breakVC,
            animated: true
        )
    }
}

//
// MARK: - Actions
//

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
        viewModel.submit()
    }
}


//
//  QuestionnaireViewController+KeyboardAvoidance.swift
//

extension QuestionnaireViewController {
    
    // MARK: - Register / Unregister
    
    func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func unregisterKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Done toolbar
    
    func attachDoneToolbar(to textField: UITextField) {
        let bar  = UIToolbar()
        bar.sizeToFit()
        
        let flex = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let done = UIBarButtonItem(
            title: "Done",
            style: .prominent,
            target: nil,
            action: #selector(UIResponder.resignFirstResponder)
        )
        
        bar.items = [flex, done]
        textField.inputAccessoryView = bar
    }
    
    @objc func dismissKeyboard() { view.endEditing(true) }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo      = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration      = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw      = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let insets  = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.scrollView.contentInset          = insets
            self.scrollView.scrollIndicatorInsets = insets
        }
        
        guard let activeField = dobFields.first(where: { $0.isFirstResponder }) else { return }
        let fieldRect  = activeField.convert(activeField.bounds, to: scrollView)
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
            self.scrollView.contentInset          = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
}

// MARK: - UITextFieldDelegate  (digit limit · validation · auto-advance)

extension QuestionnaireViewController: UITextFieldDelegate {
    
    // ── Max-digit limit & numeric-only gate ──────────────────────────────────
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard dobFields.contains(textField) else { return true }
        
        let maxDigits = textField.tag          // 2 = DD or MM, 4 = YYYY
        let current   = (textField.text ?? "") as NSString
        let proposed  = current.replacingCharacters(in: range, with: string)
        
        let allDigits = CharacterSet.decimalDigits.isSuperset(
            of: CharacterSet(charactersIn: string)
        )
        guard string.isEmpty || allDigits else { return false }
        return proposed.count <= maxDigits
    }
    
    // ── Validate · pad · auto-advance once the field is full ────────────────
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        guard dobFields.contains(textField) else { return }
        
        let text      = textField.text ?? ""
        let maxDigits = textField.tag          // 2 or 4
        
        // While still typing — only clear a stale error
        guard text.count == maxDigits else {
            showDOBError(nil)
            textField.layer.borderColor = UIColor.systemGray4.cgColor
            return
        }
        
        // ── Day validation ────────────────────────────────────────────
        if textField === dobFields[safe: 0], let value = Int(text) {
            guard (1...31).contains(value) else {
                textField.layer.borderColor = UIColor.systemRed.cgColor
                showDOBError("Enter a valid day (01 – 31)")
                return
            }
        }
        
        // ── Month validation ──────────────────────────────────────────
        if textField === dobFields[safe: 1], let value = Int(text) {
            guard (1...12).contains(value) else {
                textField.layer.borderColor = UIColor.systemRed.cgColor
                showDOBError("Enter a valid month (01 – 12)")
                return
            }
        }
        
        // ── All good: clear error, reset border ───────────────────────
        showDOBError(nil)
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        
        // Pad single-digit day / month with a leading zero
        if maxDigits == 2, let value = Int(text), value < 10, !text.hasPrefix("0") {
            textField.text = String(format: "%02d", value)
        }
        
        // Advance to next field or dismiss
        if let idx = dobFields.firstIndex(of: textField) {
            let next = idx + 1
            if next < dobFields.count {
                dobFields[next].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
    }
    
    // ── Clear error when user starts correcting a field ──────────────────────
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard dobFields.contains(textField) else { return }
        showDOBError(nil)
        textField.layer.borderColor = UIColor.systemGray4.cgColor
    }
}

// MARK: - Error label helper

extension QuestionnaireViewController {
    
    /// Pass `nil` to hide the label; pass a string to show it in red.
    func showDOBError(_ message: String?) {
        guard let label = dobErrorLabel else { return }
        if let msg = message {
            label.text      = msg
            label.isHidden  = false
        } else {
            label.isHidden  = true
            label.text      = nil
        }
    }
}

// MARK: - Safe array subscript

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
