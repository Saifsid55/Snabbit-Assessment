import Foundation

final class SignupViewModel: SignupViewModelProtocol {
    weak var delegate: SignupViewModelDelegate?
    
    private let signupUseCase: SignupUseCase
    private var email = ""
    private var username = ""
    private var password = ""
    private var confirmPassword = ""
    
    init(signupUseCase: SignupUseCase) {
        self.signupUseCase = signupUseCase
    }
    
    func updateEmail(_ email: String) {
        self.email = email
        validate()
    }
    
    func updateUsername(_ username: String) {
        self.username = username
        validate()
    }
    
    func updatePassword(_ password: String) {
        self.password = password
        validate()
    }
    
    func updateConfirmPassword(_ confirmPassword: String) {
        self.confirmPassword = confirmPassword
        validate()
    }
    
    func signup() {
        guard password == confirmPassword else {
            delegate?.viewModelDidFailWithError("Passwords do not match")
            return
        }
        signupUseCase.execute(email: email, username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.delegate?.viewModelDidSignupSuccessfully()
                case .failure(let error):
                    self?.delegate?.viewModelDidFailWithError(error.localizedDescription)
                }
            }
        }
    }
    
    private func validate() {
        let isValid = !email.isEmpty
        && !username.isEmpty
        && !password.isEmpty
        && password == confirmPassword
        delegate?.viewModelDidUpdateSignupState(isValid)
    }
}
