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
    
    var onTimerUpdate: ((String, Float) -> Void)?
    
    var onBreakEnded: (() -> Void)?
    
    var remainingTime: String = ""

    var breakEndTime: String = ""
    
    init(fetchBreakUseCase: FetchBreakUseCaseProtocol,
         endBreakUseCase: EndBreakUseCaseProtocol) {
        
        self.fetchBreakUseCase = fetchBreakUseCase
        self.endBreakUseCase = endBreakUseCase
    }
    
    func start() {
        
        Task {

                let breakData = try await fetchBreakUseCase.execute()

                self.breakModel = breakData

                // Format break end time
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"

                breakEndTime = formatter.string(from: breakData.endTime)

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
            
            onBreakEnded?()
        }
    }
}
