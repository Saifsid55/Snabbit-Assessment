//
//  BreakViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakViewController: UIViewController {
    
    // MARK: - ViewModel
    
    private var viewModel: BreakViewModelProtocol
    private let container: AppDependencyContainer
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let headerView = BreakHeaderView()
    private let timerCardView = BreakTimerCardView()
    private let timelineView = TimelineStatusView()
    
    private var isBreakRunning = false
    
    
    init(viewModel: BreakViewModelProtocol,
         container: AppDependencyContainer) {
        
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
        timerCardView.endBreakButton.setTitle("Start my break", for: .normal)
        timerCardView.endBreakButton.backgroundColor = .systemGreen
    }
}


// MARK: - Layout

private extension BreakViewController {
    
    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        contentStack.axis = .vertical
        contentStack.spacing = 24
        
        scrollView.addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        setupContent()
    }
    
    func setupContent() {
        
        contentStack.addArrangedSubview(headerView)
        contentStack.addArrangedSubview(timerCardView)
        contentStack.addArrangedSubview(timelineView)
        
        headerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
}

// MARK: - Actions

private extension BreakViewController {
    
    func setupActions() {
        
        timerCardView.endBreakButton.addTarget(
            self,
            action: #selector(didTapEndBreak),
            for: .touchUpInside
        )
        
        headerView.helpButton.addTarget(
            self,
            action: #selector(didTapHelp),
            for: .touchUpInside
        )
        
    }
    
    @objc
    func didTapEndBreak() {
        
        if isBreakRunning {
            showEndBreakConfirmation()
        } else {
            viewModel.startBreak()
        }
    }
    
    @objc
    func didTapHelp() {
        let logoutVC = container.makeLogoutViewController()
        navigationController?.pushViewController(logoutVC, animated: true)
    }
}

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


// MARK: - Binding

private extension BreakViewController {
    
    func bindViewModel() {
        
        viewModel.onTimerUpdate = { [weak self] time, progress in
            
            DispatchQueue.main.async {
                
                self?.timerCardView.timerView.update(
                    time: time,
                    progress: progress
                )
                
                self?.timerCardView.breakEndsLabel.text =
                "Break ends at \(self?.viewModel.breakEndTime ?? "")"
            }
        }
        
        viewModel.onBreakEnded = { [weak self] in
            
            DispatchQueue.main.async {
                
                guard let self else { return }
                
                UIView.transition(
                    with: self.timerCardView,
                    duration: 0.4,
                    options: .transitionCrossDissolve
                ) {
                    self.timerCardView.showBreakFinishedState()
                }
            }
        }
        
        viewModel.onBreakStateChanged = { [weak self] state in
            
            DispatchQueue.main.async {
                
                switch state {
                    
                case .notStarted:
                    
                    self?.timerCardView.endBreakButton.setTitle("Start my break", for: .normal)
                    self?.timerCardView.endBreakButton.backgroundColor = .systemGreen
                    self?.isBreakRunning = false
                    
                case .running:
                    
                    self?.timerCardView.endBreakButton.setTitle("End my break", for: .normal)
                    self?.timerCardView.endBreakButton.backgroundColor = .systemRed
                    self?.isBreakRunning = true
                    
                case .ended:
                    break
                }
            }
        }
        
        viewModel.onBreakFinishedUIUpdate = { [weak self] in
            
            DispatchQueue.main.async {
                
                guard let self else { return }
                
                UIView.animate(withDuration: 0.3) {
                    
                    self.timerCardView.endBreakButton.alpha = 0
                    self.timerCardView.breakEndsLabel.alpha = 0
                    
                } completion: { _ in
                    
                    self.timerCardView.endBreakButton.isHidden = true
                    self.timerCardView.breakEndsLabel.isHidden = true
                }
            }
        }
    }
}

private extension BreakViewController {
    
    func showBreakEndedState() {
        
        let alert = UIAlertController(
            title: "Break Finished",
            message: "Hope you are feeling refreshed and ready to start working again.",
            preferredStyle: .alert
        )
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
