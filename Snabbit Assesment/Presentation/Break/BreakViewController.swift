//
//  BreakViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakViewController: UIViewController {
    
    // MARK: - ViewModel & Container
    
    private let viewModel: BreakViewModelProtocol
    private let container: AppDependencyContainer
    
    // MARK: - UI Components
    
    private let headerBackgroundImageView = UIImageView()
    private let headerView = BreakHeaderView()
    
    private let greetingLabel = UILabel()
    private let titleLabel = UILabel()
    private let greetingStack = UIStackView()
    
    private let scrollView = UIScrollView()
    
    private let timerCardView = BreakTimerCardView()
    private let timelineView = TimelineStatusView()
    
    private let contentStack = UIStackView()
    
    // MARK: - Init
    
    init(
        viewModel: BreakViewModelProtocol,
        container: AppDependencyContainer
    ) {
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
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        bindViewModel()
        setupActions()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.refreshState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause ripple so it restarts properly on viewWillAppear
        timerCardView.successView.stopRippleAnimation()
    }

}

//
// MARK: - Layout
//

private extension BreakViewController {
    
    func setupLayout() {
        setupHeaderBackground()
        setupHeaderView()
        setupScrollView()
        setupGreeting()
        setupContent()
    }
    
    func setupHeaderView() {
        
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        headerView.delegate = self
    }
    
    func setupScrollView() {
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupHeaderBackground() {
        
        headerBackgroundImageView.image = UIImage(named: "breakHeaderBG")
        headerBackgroundImageView.contentMode = .scaleAspectFill
        headerBackgroundImageView.clipsToBounds = true
        
        view.insertSubview(headerBackgroundImageView, at: 0)
        
        headerBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBackgroundImageView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    func setupGreeting() {
        
        greetingLabel.font = .systemFont(ofSize: 14, weight: .regular)
        greetingLabel.textColor = .white
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        
        greetingStack.axis = .vertical
        greetingStack.spacing = 4
        greetingStack.alignment = .leading
        
        greetingStack.addArrangedSubview(greetingLabel)
        greetingStack.addArrangedSubview(titleLabel)
    }
    
    func setupContent() {
        
        scrollView.addSubview(contentStack)
        
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        contentStack.addArrangedSubview(greetingStack)
        contentStack.addArrangedSubview(timerCardView)
        contentStack.addArrangedSubview(timelineView)
    }
}

//
// MARK: - Actions
//

private extension BreakViewController {
    
    func setupActions() {
        
        timerCardView.endBreakButton.addTarget(
            self,
            action: #selector(didTapBreakButton),
            for: .touchUpInside
        )
    }
    
    @objc
    func didTapBreakButton() {
        viewModel.didTapBreakButton()
    }
}

//
// MARK: - ViewModel Binding
//

private extension BreakViewController {
    
    func bindViewModel() {
        
        viewModel.onStateChange = { [weak self] state in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                self.titleLabel.text = state.titleText
                
                self.timerCardView.timerView.update(
                    time: state.timerText,
                    progress: state.progress
                )
                
                self.timerCardView.breakEndsLabel.text = state.breakEndsText
                
                self.timerCardView.endBreakButton.setTitle(
                    state.buttonTitle,
                    for: .normal
                )
                
                self.timerCardView.endBreakButton.backgroundColor = state.buttonColor
                
                self.timelineView.update(state: state.timelineState)
                
                if state.breakEndsText.contains("--") {
                    self.timerCardView.breakEndsLabel.isHidden = true
                } else {
                    self.timerCardView.breakEndsLabel.isHidden = false
                }
                
                if state.isBreakFinished {
                    
                    self.timerCardView.showBreakFinishedState()
                    
                } else if state.timerText == "00:00" {
                    // Break not started yet
                    self.timerCardView.showPreBreakState()
                    
                } else {
                    // Break running
                    self.timerCardView.showTimerState()
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                if error == "confirm_end" {
                    self.showEndBreakConfirmation()
                } else {
                    self.showError(message: error)
                }
            }
        }
        
        viewModel.onUsernameUpdate = { [weak self] username in
            
            DispatchQueue.main.async {
                self?.greetingLabel.text = "Hi, \(username)!"
            }
        }
    }
}

//
// MARK: - End Break Confirmation
//

private extension BreakViewController {
    
    func showEndBreakConfirmation() {
        
        let sheet = EndBreakBottomSheetViewController()
        sheet.modalPresentationStyle = .overFullScreen
        
        sheet.onEndNow = { [weak self] in
            self?.viewModel.endBreakEarly()
        }
        
        present(sheet, animated: true)
    }
}

//
// MARK: - Error
//

private extension BreakViewController {
    
    func showError(message: String) {
        
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

//
// MARK: - Header Delegate
//

extension BreakViewController: BreakHeaderViewDelegate {

    func didTapHelp() {
        let logoutVC = container.makeLogoutViewController()

        logoutVC.onResetSuccess = { [weak self] in
            self?.viewModel.didResetBreak()
        }

        navigationController?.pushViewController(logoutVC, animated: true)
    }
}
