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
        
        setupLayout()
        setupSkillsSection()
        setupSmartphoneSection()
        setupGoogleMapsSection()
        setupDOBSection()
        setupContinueButton()
        bindViewModel()
    }
}

// MARK: - Layout

private extension QuestionnaireViewController {
    
    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: - Skills Section

private extension QuestionnaireViewController {
    
    func setupSkillsSection() {
        let title = UILabel()
        title.text = "Skills"
        title.font = .boldSystemFont(ofSize: 18)
        
        contentStack.addArrangedSubview(title)
        
        let skills = [
            "Cutting vegetables",
            "Sweeping",
            "Mopping",
            "Cleaning bathrooms",
            "Laundry",
            "Washing dishes",
            "None of the above"
        ]
        
        skills.forEach { skill in
            let button = UIButton(type: .system)
            button.setTitle(skill, for: .normal)
            button.contentHorizontalAlignment = .left
            
            button.addAction(
                UIAction { [weak self] _ in
                    self?.viewModel.toggleSkill(skill)
                },
                for: .touchUpInside
            )
            
            contentStack.addArrangedSubview(button)
        }
    }
}

// MARK: - Smartphone Section

private extension QuestionnaireViewController {
    
    func setupSmartphoneSection() {
        let label = UILabel()
        label.text = "Do you have your own smartphone?"
        
        contentStack.addArrangedSubview(label)
        
        let yes = UIButton(type: .system)
        yes.setTitle("Yes", for: .normal)
        
        let no = UIButton(type: .system)
        no.setTitle("No", for: .normal)
        
        yes.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.selectSmartphone(true)
            },
            for: .touchUpInside
        )
        
        no.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.selectSmartphone(false)
            },
            for: .touchUpInside
        )
        
        contentStack.addArrangedSubview(yes)
        contentStack.addArrangedSubview(no)
    }
}

// MARK: - Google Maps Section

private extension QuestionnaireViewController {
    
    func setupGoogleMapsSection() {
        let label = UILabel()
        label.text = "Have you ever used Google Maps?"
        
        contentStack.addArrangedSubview(label)
        
        let yes = UIButton(type: .system)
        yes.setTitle("Yes", for: .normal)
        
        let no = UIButton(type: .system)
        no.setTitle("No", for: .normal)
        
        yes.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.selectGoogleMaps(true)
            },
            for: .touchUpInside
        )
        
        no.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.selectGoogleMaps(false)
            },
            for: .touchUpInside
        )
        
        contentStack.addArrangedSubview(yes)
        contentStack.addArrangedSubview(no)
    }
}

// MARK: - DOB Section

private extension QuestionnaireViewController {
    
    func setupDOBSection() {
        let label = UILabel()
        label.text = "Date of Birth"
        
        contentStack.addArrangedSubview(label)
        
        let stack = UIStackView(arrangedSubviews: [dobDayTF, dobMonthTF, dobYearTF])
        stack.axis = .horizontal
        stack.spacing = 10
        
        dobDayTF.placeholder = "DD"
        dobMonthTF.placeholder = "MM"
        dobYearTF.placeholder = "YYYY"
        
        [dobDayTF, dobMonthTF, dobYearTF].forEach {
            $0.borderStyle = .roundedRect
            $0.addTarget(
                self,
                action: #selector(dobChanged),
                for: .editingChanged
            )
        }
        
        contentStack.addArrangedSubview(stack)
    }
    
    @objc func dobChanged() {
        viewModel.updateDOB(
            day: dobDayTF.text ?? "",
            month: dobMonthTF.text ?? "",
            year: dobYearTF.text ?? ""
        )
    }
}

// MARK: - Continue Button

private extension QuestionnaireViewController {
    
    func setupContinueButton() {
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = .systemPurple
        continueButton.layer.cornerRadius = 8
        
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        
        contentStack.addArrangedSubview(continueButton)
    }
    
    func bindViewModel() {
        viewModel.isContinueEnabled = { [weak self] enabled in
            DispatchQueue.main.async {
                self?.continueButton.isEnabled = enabled
                self?.continueButton.alpha = enabled ? 1 : 0.5
            }
        }
    }
}
