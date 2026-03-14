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
    
    // MARK: - Init
    
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
        
        viewModel.start()
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
        
        timerCardView.heightAnchor.constraint(equalToConstant: 360).isActive = true
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
    }
    
    @objc
    func didTapEndBreak() {
        
        showEndBreakConfirmation()
    }
}

private extension BreakViewController {
    
    func showEndBreakConfirmation() {
        
        let alert = UIAlertController(
            title: "Ending break early?",
            message: "Are you sure you want to end your break now?",
            preferredStyle: .actionSheet
        )
        
        let continueAction = UIAlertAction(
            title: "Continue Break",
            style: .cancel
        )
        
        let endNowAction = UIAlertAction(
            title: "End Now",
            style: .destructive
        ) { [weak self] _ in
            
            self?.viewModel.endBreakEarly()
        }
        
        alert.addAction(continueAction)
        alert.addAction(endNowAction)
        
        present(alert, animated: true)
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
                
                self?.showBreakEndedState()
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
