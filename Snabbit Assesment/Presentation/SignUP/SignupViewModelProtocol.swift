//
//  SignupViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import Foundation

protocol SignupViewModelProtocol {
    
    var isSignupEnabled: ((Bool) -> Void)? { get set }
    var onSignupSuccess: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func updateEmail(_ email: String)
    func updateUsername(_ username: String)
    func updatePassword(_ password: String)
    func updateConfirmPassword(_ password: String)
    
    func signup()
}
