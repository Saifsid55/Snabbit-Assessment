//
//  BreakViewModelProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//


import Foundation

protocol BreakViewModelProtocol: AnyObject {
    var delegate: BreakViewModelDelegate? { get set }
    func loadData() async
    func refreshState() async
    func didTapBreakButton() async
    func endBreakEarly() async
    func didResetBreak()
}

protocol BreakViewModelDelegate: AnyObject {
    func didUpdateState(_ state: BreakViewState)
    func didUpdateUsername(_ username: String)
    func didReceiveError(_ error: String)
}
