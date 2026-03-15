//
//  BreakViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakViewController: UIViewController {
    
    // MARK: - ViewModel & Container
    
    private var viewModel: BreakViewModelProtocol
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
    
    private var isBreakRunning = false
    
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
        
        timerCardView.endBreakButton.setTitle("Start my break", for: .normal)
        timerCardView.endBreakButton.backgroundColor = .systemGreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Layout

private extension BreakViewController {
    
    func setupLayout() {
        setupHeaderBackground()
        setHeaderView()
        setupScrollView()
        setGreetingLabel()
        setupContent()
    }
    
    func setHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            
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
        
        // Background image
        headerBackgroundImageView.image = UIImage(named: "breakHeaderBG")
        headerBackgroundImageView.contentMode = .scaleAspectFill
        headerBackgroundImageView.clipsToBounds = true
        headerBackgroundImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        view.insertSubview(headerBackgroundImageView, at: 0)
        headerBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBackgroundImageView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    func setGreetingLabel() {
        greetingLabel.text = "Hi, Reshma!"
        greetingLabel.font = .systemFont(ofSize: 14, weight: .regular)
        greetingLabel.textColor = .white
        
        titleLabel.text = "You are on break!"
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
        contentStack.backgroundColor = .clear
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
        if isBreakRunning {
            showEndBreakConfirmation()
        } else {
            viewModel.startBreak()
        }
    }
}

// MARK: - End Break Confirmation

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
                self?.timerCardView.timerView.update(time: time, progress: progress)
                self?.timerCardView.breakEndsLabel.text =
                "Break ends at \(self?.viewModel.breakEndTime ?? "")"
            }
        }
        
        viewModel.onBreakEnded = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                
                self.timelineView.update(state: .breakEnded)
                
                self.timerCardView.showBreakFinishedState()
                
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
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
                    self?.timelineView.update(state: .breakRunning)
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

extension BreakViewController: BreakHeaderViewDelegate {
    func didTapHelp() {
        let logoutVC = container.makeLogoutViewController()
        navigationController?.pushViewController(logoutVC, animated: true)
    }
}
