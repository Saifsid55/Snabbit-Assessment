

import Foundation

final class SignupUseCase {

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        email: String,
        username: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        repository.isUsernameAvailable(username) { [weak self] result in

            switch result {

            case .success(let available):

                if !available {

                    completion(.failure(
                        NSError(
                            domain: "",
                            code: 409,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                "Username already taken"
                            ]
                        )
                    ))
                    return
                }

                self?.repository.signup(
                    email: email,
                    password: password
                ) { result in

                    switch result {

                    case .success(let uid):

                        self?.repository.saveUserProfile(
                            uid: uid,
                            email: email,
                            username: username,
                            completion: completion
                        )

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
