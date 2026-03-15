//
//  LoginViewModelProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    var delegate: LoginViewModelDelegate? { get set }
    func updateUsername(_ username: String)
    func updatePassword(_ password: String)
    func login()
}
