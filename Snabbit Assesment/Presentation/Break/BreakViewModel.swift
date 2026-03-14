//
//  Untitled.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import Foundation

final class BreakViewModel: BreakViewModelProtocol {
    
    private let fetchBreakUseCase: FetchBreakUseCaseProtocol
    private let endBreakUseCase: EndBreakUseCaseProtocol
    
    private var breakModel: Break?
    
    private var timer: Timer?
    
    private var state: BreakState = .notStarted
    
    var onBreakStateChanged: ((BreakState) -> Void)?
    
    var onTimerUpdate: ((String, Float) -> Void)?
    
    var onBreakFinishedUIUpdate: (() -> Void)?
    
    var onBreakEnded: (() -> Void)?
    
    var remainingTime: String = ""
    
    var breakEndTime: String = ""
    
    init(fetchBreakUseCase: FetchBreakUseCaseProtocol,
         endBreakUseCase: EndBreakUseCaseProtocol) {
        
        self.fetchBreakUseCase = fetchBreakUseCase
        self.endBreakUseCase = endBreakUseCase
    }
    
    func startBreak() {
        
        Task {
            
            let breakData = try await fetchBreakUseCase.execute()
            
            self.breakModel = breakData
            
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            breakEndTime = formatter.string(from: breakData.endTime)
            
            state = .running
            onBreakStateChanged?(.running)
            
            startTimer()
        }
    }
    
    private func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1,
                                     repeats: true) { [weak self] _ in
            
            self?.updateTime()
        }
    }
    
    private func updateTime() {
        
        guard let breakModel else { return }
        
        let remaining = breakModel.endTime.timeIntervalSinceNow
        
        if remaining <= 0 {
            
            timer?.invalidate()
            
            state = .ended
            
            onBreakFinishedUIUpdate?()
            onBreakEnded?()
            
            return
        }
        
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        let progress = Float(remaining / breakModel.duration)
        
        onTimerUpdate?(timeString, progress)
    }
    
    func endBreakEarly() {
        Task {
            try await endBreakUseCase.execute()
            
            timer?.invalidate()
            
            state = .ended
            
            onBreakFinishedUIUpdate?()
            onBreakEnded?()
        }
    }
}
