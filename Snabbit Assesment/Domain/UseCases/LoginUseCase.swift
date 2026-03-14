

import Foundation

final class LoginUseCase {

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        if email.contains("@") {

            repository.login(
                email: email,
                password: password,
                completion: completion
            )

        } else {

            repository.getEmail(from: email) { [weak self] result in

                switch result {

                case .success(let realEmail):

                    self?.repository.login(
                        email: realEmail,
                        password: password,
                        completion: completion
                    )

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
