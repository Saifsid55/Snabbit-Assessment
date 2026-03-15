//
//  AppDependencyContainer.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

//
//  AppDependencyContainer.swift
//  Snabbit Assesment
//

import UIKit

final class AppDependencyContainer {
    
    // MARK: - Services
    
    private lazy var authService = FirebaseAuthService()
    private lazy var userService = UserService()
    private lazy var breakService = FirebaseBreakService()
    
    
    // MARK: - Repositories
    
    private lazy var authRepository: AuthRepositoryProtocol =
    AuthRepository(
        authService: authService,
        userService: userService
    )
    
    private func makeBreakRepository() -> BreakRepository {
        
        guard let userId = authService.currentUserId() else {
            fatalError("User not logged in")
        }
        
        return BreakRepository(
            service: breakService,
            userId: userId
        )
    }
    
    
    // MARK: - Auth UseCases
    
    private lazy var loginUseCase =
    LoginUseCase(repository: authRepository)
    
    private lazy var signupUseCase =
    SignupUseCase(repository: authRepository)
    
    private lazy var logoutUseCase =
    LogoutUseCase(repository: authRepository)
    
    
    // MARK: - ViewModels
    
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: loginUseCase)
    }
    
    func makeSignupViewModel() -> SignupViewModel {
        SignupViewModel(signupUseCase: signupUseCase)
    }
    
    func makeLogoutViewModel() -> LogoutViewModel {
        
        let repository = makeBreakRepository()
        
        let resetBreakUseCase =
        ResetBreakUseCase(repository: repository)
        
        return LogoutViewModel(
            logoutUseCase: logoutUseCase,
            resetBreakUseCase: resetBreakUseCase
        )
    }
    
    
    // MARK: - ViewControllers
    
    func makeLoginViewController() -> UIViewController {
        
        let vm = makeLoginViewModel()
        
        return LoginViewController(
            viewModel: vm,
            container: self
        )
    }
    
    
    func makeSignupViewController() -> UIViewController {
        
        let vm = makeSignupViewModel()
        
        return SignupViewController(
            viewModel: vm,
            container: self
        )
    }
    
    
    func makeQuestionnaireViewController() -> UIViewController {
        
        let vm = QuestionnaireViewModel()
        
        return QuestionnaireViewController(
            viewModel: vm,
            container: self
        )
    }
    
    
    func makeBreakViewController() -> BreakViewController {
        
        let repository = makeBreakRepository()
        
        // Break UseCases
        
        let observeBreak =
        ObserveBreakUseCase(repository: repository)
        
        let startBreak =
        StartBreakUseCase(repository: repository)
        
        let endBreak =
        EndBreakUseCase(repository: repository)
        
        
        // ViewModel
        
        let viewModel = BreakViewModel(
            observeBreakUseCase: observeBreak,
            startBreakUseCase: startBreak,
            endBreakUseCase: endBreak
        )
        
        
        return BreakViewController(
            viewModel: viewModel,
            container: self
        )
    }
    
    
    func makeLogoutViewController() -> UIViewController {
        
        let vm = makeLogoutViewModel()
        
        return LogoutViewController(
            viewModel: vm,
            container: self
        )
    }
}
