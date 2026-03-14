//
//  LoginViewModelProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import Foundation

import Foundation

protocol LoginViewModelProtocol {
    
    var isContinueEnabled: ((Bool) -> Void)? { get set }
    
    func updateUsername(_ username: String)
    func updatePassword(_ password: String)
}
