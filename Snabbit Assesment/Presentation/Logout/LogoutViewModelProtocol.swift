//
//  LogoutViewModelProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import Foundation

protocol LogoutViewModelProtocol {
    
    var onLogoutSuccess: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func logout()
}
