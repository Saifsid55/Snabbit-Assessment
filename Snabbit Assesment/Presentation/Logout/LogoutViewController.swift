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
    
    private var viewModel: LogoutViewModelProtocol
    private let container: AppDependencyContainer
    
    init(viewModel: LogoutViewModelProtocol,
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
    }
}

// MARK: - UI

private extension LogoutViewController {
    
    func setupUI() {
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        logoutButton.backgroundColor = .systemRed
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 10
        
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 160),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        logoutButton.addTarget(
            self,
            action: #selector(didTapLogout),
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
