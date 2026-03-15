//
//  LogoutViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit
import FirebaseAuth

final class LogoutViewController: UIViewController {
    
    private let logoutButton = UIButton(type: .system)
    private let resetBreakButton = UIButton(type: .system)
    
    private var viewModel: LogoutViewModelProtocol
    private let container: AppDependencyContainer
    
    init(
        viewModel: LogoutViewModelProtocol,
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
        
        view.backgroundColor = .systemBackground
        title = "Settings"
        
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func bindViewModel() {
        
        viewModel.onLogoutSuccess = { [weak self] in
            self?.navigateToLogin()
        }
        
        viewModel.onError = { error in
            print(error)
        }
        
        viewModel.onResetSuccess = {
            print("Break reset successfully")
        }
    }
}

// MARK: - UI

private extension LogoutViewController {
    
    func setupUI() {
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 10
        
        resetBreakButton.setTitle("Reset Break", for: .normal)
        resetBreakButton.backgroundColor = .systemBlue
        resetBreakButton.setTitleColor(.white, for: .normal)
        resetBreakButton.layer.cornerRadius = 10
        
        let stack = UIStackView(arrangedSubviews: [
            resetBreakButton,
            logoutButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resetBreakButton.heightAnchor.constraint(equalToConstant: 50),
            resetBreakButton.widthAnchor.constraint(equalToConstant: 160),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        logoutButton.addTarget(
            self,
            action: #selector(didTapLogout),
            for: .touchUpInside
        )
        
        resetBreakButton.addTarget(
            self,
            action: #selector(didTapResetBreak),
            for: .touchUpInside
        )
    }
}
// MARK: - Actions

private extension LogoutViewController {
    
    @objc
    func didTapLogout() {
        viewModel.logout()
    }
    
    @objc
    func didTapResetBreak() {
        viewModel.resetBreak()
    }
}
// MARK: - Navigation

private extension LogoutViewController {
    
    func navigateToLogin() {
        
        guard let sceneDelegate =
                UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }
        
        let container = AppDependencyContainer()
        let loginVC = container.makeLoginViewController()
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
