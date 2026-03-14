//
//  QuestionnaireViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class QuestionnaireViewController: UIViewController {
    
    private var viewModel: QuestionnaireViewModelProtocol
    
    private var scrollView = UIScrollView()
    private var contentStack = UIStackView()
    
    private var continueButton = UIButton()
    
    private var dobDayTF = UITextField()
    private var dobMonthTF = UITextField()
    private var dobYearTF = UITextField()
    
    private let progressContainer = UIView()
    private let progressFill = UIView()
    private var progressWidthConstraint: NSLayoutConstraint!
    
    init(viewModel: QuestionnaireViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupProgressBar()
        setupLayout()
        setSectionHeader()
        setupSkillsSection()
        setupSmartphoneSection()
        setupSmartphoneRequirementSection()
        setupGoogleMapsSection()
        setupDOBSection()
        setupContinueButton()
        bindViewModel()
    }
}

//MARK: - Layout

private extension QuestionnaireViewController {
    
    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
}

//MARK: - Progress Bar

private extension QuestionnaireViewController {
    
    func setupProgressBar() {
        
        progressContainer.backgroundColor = .systemGray5
        progressContainer.layer.cornerRadius = 3
        
        progressFill.backgroundColor = .systemBlue
        progressFill.layer.cornerRadius = 3
        
        view.addSubview(progressContainer)
        progressContainer.addSubview(progressFill)
        
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        progressFill.translatesAutoresizingMaskIntoConstraints = false
        
        progressWidthConstraint = progressFill.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            
            progressContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            progressContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressContainer.heightAnchor.constraint(equalToConstant: 6),
            
            progressFill.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressFill.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            
            progressWidthConstraint
        ])
    }
    
    func updateProgress(_ progress: Float) {
        
        let maxWidth = progressContainer.frame.width
        progressWidthConstraint.constant = maxWidth * CGFloat(progress)
        
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - Helpers

private extension QuestionnaireViewController {
    
    func makeRadioRow(title: String) -> (UIView, RadioOptionView) {
        
        let radio = RadioOptionView()
        
        let label = UILabel()
        label.text = title
        
        let stack = UIStackView(arrangedSubviews: [radio, label])
        stack.axis = .horizontal
        stack.spacing = 8
        
        return (stack, radio)
    }
}


//MARK: - Section Header
private extension QuestionnaireViewController {
    func setSectionHeader() {
        let header = SectionHeaderView(title: "Skills", subtitle: "Tell us bit more about yourself")
        contentStack.addArrangedSubview(header)
    }
}

//MARK: - Skills Section

private extension QuestionnaireViewController {
    
    func setupSkillsSection() {
        
        let skills = [
            "Cutting vegetables",
            "Sweeping",
            "Mopping",
            "Cleaning bathrooms",
            "Laundry",
            "Washing dishes",
            "None of the above"
        ]
        
        var index = 0
        
        while index < skills.count {
            
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 20
            row.distribution = .fillEqually
            
            let skill = skills[index]
            
            let first = CheckboxView(title: skill)
            first.onToggle = { [weak self] in
                self?.viewModel.toggleSkill(skill)
            }
            
            row.addArrangedSubview(first)
            
            if index + 1 < skills.count {
                
                let secondSkill = skills[index + 1]
                
                let second = CheckboxView(title: secondSkill)
                second.onToggle = { [weak self] in
                    self?.viewModel.toggleSkill(secondSkill)
                }
                
                row.addArrangedSubview(second)
            }
            
            contentStack.addArrangedSubview(row)
            
            index += 2
        }
    }
}

//MARK: - Smartphone

private extension QuestionnaireViewController {
    
    func setupSmartphoneSection() {
        
        let label = UILabel()
        label.text = "Do you have your own smartphone?"
        
        contentStack.addArrangedSubview(label)
        
        let (yesRow, yesRadio) = makeRadioRow(title: "Yes")
        let (noRow, noRadio) = makeRadioRow(title: "No")
        
        yesRadio.onTap = { [weak self] in
            yesRadio.setSelected(true)
            noRadio.setSelected(false)
            self?.viewModel.selectSmartphone(true)
        }
        
        noRadio.onTap = { [weak self] in
            yesRadio.setSelected(false)
            noRadio.setSelected(true)
            self?.viewModel.selectSmartphone(false)
        }
        
        let rowStack = UIStackView(arrangedSubviews: [yesRow, noRow])
        rowStack.axis = .horizontal
        rowStack.spacing = 24
        
        contentStack.addArrangedSubview(rowStack)
    }
}

//MARK: - Smartphone Requirement

private extension QuestionnaireViewController {
    
    func setupSmartphoneRequirementSection() {
        
        let label = UILabel()
        label.text = "Will you be able to get a phone for the job?"
        
        contentStack.addArrangedSubview(label)
        
        let (yesRow, yesRadio) = makeRadioRow(title: "Yes")
        let (noRow, noRadio) = makeRadioRow(title: "No")
        
        yesRadio.onTap = { [weak self] in
            yesRadio.setSelected(true)
            noRadio.setSelected(false)
            self?.viewModel.selectCanGetPhone(true)
        }
        
        noRadio.onTap = { [weak self] in
            yesRadio.setSelected(false)
            noRadio.setSelected(true)
            self?.viewModel.selectCanGetPhone(false)
        }
        
        let rowStack = UIStackView(arrangedSubviews: [yesRow, noRow])
        rowStack.axis = .horizontal
        rowStack.spacing = 24
        
        contentStack.addArrangedSubview(rowStack)
    }
}

//MARK: - Google Maps

private extension QuestionnaireViewController {
    
    func setupGoogleMapsSection() {
        
        let label = UILabel()
        label.text = "Have you ever used Google Maps?"
        
        contentStack.addArrangedSubview(label)
        
        let (yesRow, yesRadio) = makeRadioRow(title: "Yes")
        let (noRow, noRadio) = makeRadioRow(title: "No")
        
        yesRadio.onTap = { [weak self] in
            yesRadio.setSelected(true)
            noRadio.setSelected(false)
            self?.viewModel.selectGoogleMaps(true)
        }
        
        noRadio.onTap = { [weak self] in
            yesRadio.setSelected(false)
            noRadio.setSelected(true)
            self?.viewModel.selectGoogleMaps(false)
        }
        
        let rowStack = UIStackView(arrangedSubviews: [yesRow, noRow])
        rowStack.axis = .horizontal
        rowStack.spacing = 24
        
        contentStack.addArrangedSubview(rowStack)
    }
}

//MARK: - DOB

private extension QuestionnaireViewController {
    
    func setupDOBSection() {
        
        let label = UILabel()
        label.text = "Date of birth"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        contentStack.addArrangedSubview(label)
        
        configureDOBField(dobDayTF, placeholder: "DD", width: 72)
        configureDOBField(dobMonthTF, placeholder: "MM", width: 72)
        configureDOBField(dobYearTF, placeholder: "YYYY", width: 120)
        
        let stack = UIStackView(arrangedSubviews: [
            dobDayTF,
            dobMonthTF,
            dobYearTF
        ])
        
        stack.axis = .horizontal
        stack.spacing = 14
        
        contentStack.addArrangedSubview(stack)
    }
    
    private func configureDOBField(_ textField: UITextField,
                                   placeholder: String,
                                   width: CGFloat) {
        
        textField.placeholder = placeholder
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        
        textField.layer.cornerRadius = 14
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: width),
            textField.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        textField.keyboardType = .numberPad
        
        textField.addTarget(self,
                            action: #selector(dobChanged),
                            for: .editingChanged)
    }
    
    @objc
    func dobChanged() {
        
        viewModel.updateDOB(
            day: dobDayTF.text ?? "",
            month: dobMonthTF.text ?? "",
            year: dobYearTF.text ?? ""
        )
    }
}

//MARK: - Continue Button

private extension QuestionnaireViewController {
    
    func setupContinueButton() {
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = .systemPurple
        continueButton.layer.cornerRadius = 8
        
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        
        contentStack.addArrangedSubview(continueButton)
    }
}

//MARK: - Bind ViewModel

private extension QuestionnaireViewController {
    
    func bindViewModel() {
        
        viewModel.isContinueEnabled = { [weak self] enabled in
            
            DispatchQueue.main.async {
                self?.continueButton.isEnabled = enabled
                self?.continueButton.alpha = enabled ? 1 : 0.5
            }
        }
        
        viewModel.onProgressChanged = { [weak self] progress in
            
            DispatchQueue.main.async {
                self?.updateProgress(progress)
            }
        }
    }
}
