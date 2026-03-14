//
//  AppDependencyContainer.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class AppDependencyContainer {

    // MARK: Services

    private lazy var authService = FirebaseAuthService()
    private lazy var userService = UserService()

    // MARK: Repository

    private lazy var authRepository: AuthRepositoryProtocol =
        AuthRepository(
            authService: authService,
            userService: userService
        )

    // MARK: UseCases

    private lazy var loginUseCase =
        LoginUseCase(repository: authRepository)

    private lazy var signupUseCase =
        SignupUseCase(repository: authRepository)

    // MARK: ViewModels

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: loginUseCase)
    }

    func makeSignupViewModel() -> SignupViewModel {
        SignupViewModel(signupUseCase: signupUseCase)
    }

    // MARK: ViewControllers

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

        return QuestionnaireViewController(viewModel: vm, container: self)
    }
    
    func makeBreakViewController() -> BreakViewController {

        let repository = BreakRepository()

        let fetchBreak = FetchBreakUseCase(repository: repository)

        let endBreak = EndBreakUseCase(repository: repository)

        let viewModel = BreakViewModel(
            fetchBreakUseCase: fetchBreak,
            endBreakUseCase: endBreak
        )

        return BreakViewController(viewModel: viewModel, container: self)
    }
}
