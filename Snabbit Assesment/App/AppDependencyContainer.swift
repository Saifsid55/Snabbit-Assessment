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
    private lazy var questionnaireService = FirebaseQuestionnaireService()
    
    
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
    
    
    func makeQuestionnaireRepository() -> QuestionnaireRepositoryProtocol {
        
        guard let userId = authService.currentUserId() else {
            fatalError("User not logged in")
        }
        
        return QuestionnaireRepository(
            service: questionnaireService,
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
    
    
    // MARK: - Questionnaire UseCases
    
    private func makeFetchQuestionnaireUseCase() -> FetchQuestionnaireUseCaseProtocol {
        
        let repository = makeQuestionnaireRepository()
        
        return FetchQuestionnaireUseCase(repository: repository)
    }
    
    private func makeSubmitQuestionnaireUseCase() -> SubmitQuestionnaireUseCaseProtocol {
        
        let repository = makeQuestionnaireRepository()
        
        return SubmitQuestionnaireUseCase(repository: repository)
    }
    
    
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
    
    
    func makeQuestionnaireViewModel() -> QuestionnaireViewModel {
        
        let fetchUseCase = makeFetchQuestionnaireUseCase()
        let submitUseCase = makeSubmitQuestionnaireUseCase()
        
        return QuestionnaireViewModel(
            fetchUseCase: fetchUseCase,
            submitUseCase: submitUseCase
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
        
        let vm = makeQuestionnaireViewModel()
        
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
        
        let currentUser =
        GetCurrentUserUseCase(repository: authRepository)
        // ViewModel
        
        let viewModel = BreakViewModel(
            observeBreakUseCase: observeBreak,
            startBreakUseCase: startBreak,
            endBreakUseCase: endBreak, getCurrentUserUseCase: currentUser
        )
        
        
        return BreakViewController(
            viewModel: viewModel,
            container: self
        )
    }
    
    
    func makeLogoutViewController() -> LogoutViewController {
        
        let vm = makeLogoutViewModel()
        
        return LogoutViewController(
            viewModel: vm,
            container: self
        )
    }
}
