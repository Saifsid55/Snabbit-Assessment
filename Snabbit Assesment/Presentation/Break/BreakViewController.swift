//
//  BreakViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        
        enum Assets {
            static let headerBackground = "breakHeaderBG"
        }
        
        enum Strings {
            static let errorTitle        = "Error"
            static let errorActionTitle  = "OK"
            static let confirmEndKey     = "confirm_end"
            static func greeting(_ name: String) -> String { "Hi, \(name)!" }
        }
        
        enum Layout {
            static let headerBackgroundHeight: CGFloat = 280
            static let headerHeight: CGFloat           = 44
            static let headerHorizontalPadding: CGFloat = 20
            static let scrollViewTopSpacing: CGFloat   = 16
            static let contentTopSpacing: CGFloat      = 16
            static let contentHorizontalPadding: CGFloat = 20
            static let contentStackWidth: CGFloat      = -40
        }
        
        enum Typography {
            static let greetingFontSize: CGFloat = 14
            static let titleFontSize: CGFloat    = 24
        }
        
        enum Spacing {
            static let greetingStack: CGFloat = 4
            static let contentStack: CGFloat  = 24
        }
    }
    
    // MARK: - ViewModel & Container
    private let viewModel: BreakViewModelProtocol
    private let container: AppDependencyContainer
    
    // MARK: - Computed Views
    private lazy var headerBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Assets.headerBackground)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var headerView: BreakHeaderView = {
        let view = BreakHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.Typography.greetingFontSize, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.Typography.titleFontSize, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var greetingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Spacing.greetingStack
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var timerCardView = BreakTimerCardView()
    private var timelineView = TimelineStatusView()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Spacing.contentStack
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    init(viewModel: BreakViewModelProtocol, container: AppDependencyContainer) {
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
        setupActions()
        viewModel.delegate = self
        Task { await viewModel.loadData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        Task { await viewModel.refreshState() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerCardView.successView.stopRippleAnimation()
    }
}

// MARK: - Layout
private extension BreakViewController {
    
    func setupLayout() {
        setupHeaderBackground()
        setupHeaderView()
        setupScrollView()
        setupGreeting()
        setupContent()
    }
    
    func setupHeaderBackground() {
        view.insertSubview(headerBackgroundImageView, at: 0)
        NSLayoutConstraint.activate([
            headerBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBackgroundImageView.heightAnchor.constraint(equalToConstant: Constants.Layout.headerBackgroundHeight)
        ])
    }
    
    func setupHeaderView() {
        view.addSubview(headerView)
        headerView.delegate = self
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.headerHorizontalPadding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.headerHorizontalPadding),
            headerView.heightAnchor.constraint(equalToConstant: Constants.Layout.headerHeight)
        ])
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.Layout.scrollViewTopSpacing),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupGreeting() {
        greetingStack.addArrangedSubview(greetingLabel)
        greetingStack.addArrangedSubview(titleLabel)
    }
    
    func setupContent() {
        scrollView.addSubview(contentStack)
        contentStack.addArrangedSubview(greetingStack)
        contentStack.addArrangedSubview(timerCardView)
        contentStack.addArrangedSubview(timelineView)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.Layout.contentTopSpacing),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.Layout.contentHorizontalPadding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.Layout.contentHorizontalPadding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: Constants.Layout.contentStackWidth)
        ])
    }
}

// MARK: - Actions
private extension BreakViewController {
    
    func setupActions() {
        timerCardView.endBreakButton.addTarget(self, action: #selector(didTapBreakButton), for: .touchUpInside)
    }
    
    @objc func didTapBreakButton() {
        Task { await viewModel.didTapBreakButton() }
    }
}

// MARK: - BreakViewModelDelegate
extension BreakViewController: BreakViewModelDelegate {
    
    func didUpdateState(_ state: BreakViewState) {
        MainActor.assumeIsolated {
            applyState(state)
        }
    }
    
    func didUpdateUsername(_ username: String) {
        MainActor.assumeIsolated {
            greetingLabel.text = Constants.Strings.greeting(username)
        }
    }
    
    func didReceiveError(_ error: String) {
        MainActor.assumeIsolated {
            if error == Constants.Strings.confirmEndKey {
                showEndBreakConfirmation()
            } else {
                showError(message: error)
            }
        }
    }
    
    private func applyState(_ state: BreakViewState) {
        titleLabel.text = state.titleText
        timerCardView.timerView.update(time: state.timerText, progress: state.progress)
        timerCardView.breakEndsLabel.text = state.breakEndsText
        timerCardView.breakEndsLabel.isHidden = state.breakEndsText.contains("--")
        timerCardView.endBreakButton.setTitle(state.buttonTitle, for: .normal)
        timerCardView.endBreakButton.backgroundColor = state.buttonColor
        timelineView.update(state: state.timelineState)
        
        if state.isBreakFinished {
            timerCardView.showBreakFinishedState()
        } else if state.timerText == "00:00" {
            timerCardView.showPreBreakState()
        } else {
            timerCardView.showTimerState()
        }
    }
}

// MARK: - End Break Confirmation
private extension BreakViewController {
    
    func showEndBreakConfirmation() {
        let sheet = EndBreakBottomSheetViewController()
        sheet.modalPresentationStyle = .overFullScreen
        sheet.onEndNow = { [weak self] in
            Task { await self?.viewModel.endBreakEarly() }
        }
        present(sheet, animated: true)
    }
}

// MARK: - Error
private extension BreakViewController {
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: Constants.Strings.errorTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.Strings.errorActionTitle, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - BreakHeaderViewDelegate
extension BreakViewController: BreakHeaderViewDelegate {
    
    func didTapHelp() {
        let logoutVC = container.makeLogoutViewController()
        logoutVC.onResetSuccess = { [weak self] in
            self?.viewModel.didResetBreak()
        }
        navigationController?.pushViewController(logoutVC, animated: true)
    }
}
