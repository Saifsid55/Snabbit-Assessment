//
//  BreakViewModelProtocol.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

protocol BreakViewModelProtocol {

    var remainingTime: String { get }
    
    var onTimerUpdate: ((String, Float) -> Void)? { get set }
    
    var onBreakEnded: (() -> Void)? { get set }
    
    var breakEndTime: String { get }
    
    var onBreakStateChanged: ((BreakState) -> Void)? { get set }
    
    var onBreakFinishedUIUpdate: (() -> Void)? { get set }
    
    func startBreak()
    
    func endBreakEarly()
}
