//
//  BreakViewModelProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//


import Foundation

protocol BreakViewModelProtocol: AnyObject {
    
    // MARK: - Binding
    
    var onStateChange: ((BreakViewState) -> Void)? { get set }
    
    var onError: ((String) -> Void)? { get set }
    
    // MARK: - Actions
    
    func startBreak()
    
    func endBreakEarly()
    
    func refreshState()
    
    func didTapBreakButton()
    
    func viewDidLoad()
}
