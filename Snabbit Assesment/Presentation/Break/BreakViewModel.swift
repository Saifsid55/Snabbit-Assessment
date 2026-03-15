//
//  Untitled.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import Foundation
import UIKit

final class BreakViewModel: BreakViewModelProtocol {
    
    // MARK: - Dependencies
    
    private let observeBreakUseCase: ObserveBreakUseCaseProtocol
    private let endBreakUseCase: EndBreakUseCaseProtocol
    private let startBreakUseCase: StartBreakUseCaseProtocol
    
    // MARK: - State
    
    private var breakModel: Break?
    private var timer: Timer?
    
    private var state: BreakState = .notStarted
    
    // MARK: - Binding
    
    var onStateChange: ((BreakViewState) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Formatter
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    // MARK: - Init
    
    init(
        observeBreakUseCase: ObserveBreakUseCaseProtocol,
        startBreakUseCase: StartBreakUseCaseProtocol,
        endBreakUseCase: EndBreakUseCaseProtocol
    ) {
        self.observeBreakUseCase = observeBreakUseCase
        self.startBreakUseCase = startBreakUseCase
        self.endBreakUseCase = endBreakUseCase
    }
    
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        
        observeBreakUseCase.execute { [weak self] breakModel in
            
            guard let self else { return }
            
            self.breakModel = breakModel
            
            if breakModel == nil {
                self.state = .notStarted
                self.stopTimer()
                self.sendStateUpdate(time: "00:00", progress: 0)
                return
            }
            
            switch breakModel!.status {
                
            case "not_started":
                self.state = .notStarted
                self.stopTimer()
                self.sendStateUpdate(time: "00:00", progress: 0)
                
            case "running":
                self.state = .running
                self.startTimer()
                
            case "ended":
                self.state = .ended
                self.stopTimer()
                self.sendStateUpdate(time: "00:00", progress: 0)
                
            default:
                break
            }
        }
    }
    
    // MARK: - Actions
    
    func didTapBreakButton() {
        
        switch state {
            
        case .notStarted:
            startBreak()
            
        case .running:
            onError?("confirm_end")
            
        case .ended:
            break
        }
    }
    
    func startBreak() {
        Task {
            do {
                try await startBreakUseCase.execute()
            } catch {
                onError?("Failed to start break")
            }
        }
    }
    
    func endBreakEarly() {
        
        Task {
            do {
                
                try await endBreakUseCase.execute()
                
            } catch {
                onError?("Failed to end break")
            }
        }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        
        stopTimer()
        
        timer = Timer(
            timeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            self?.updateTime()
        }
        
        if let timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Timer Update
    
    private func updateTime() {
        
        guard let breakModel else { return }
        guard let startTime = breakModel.startTime else { return }
        
        let endTime = startTime.addingTimeInterval(breakModel.duration)
        let remaining = endTime.timeIntervalSinceNow
        
        if remaining <= 0 {
            
            stopTimer()
            
            state = .ended
            
            sendStateUpdate(time: "00:00", progress: 0)
            
            return
        }
        
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        let progress = Float(remaining / breakModel.duration)
        
        sendStateUpdate(time: timeString, progress: progress)
    }
    
    // MARK: - Refresh Update
    
    func refreshState() {
        
        guard let breakModel else {
            state = .notStarted
            stopTimer()
            sendStateUpdate(time: "00:00", progress: 0)
            return
        }
        
        switch breakModel.status {
            
        case "not_started":
            state = .notStarted
            stopTimer()
            sendStateUpdate(time: "00:00", progress: 0)
            
        case "running":
            state = .running
            startTimer()
            
        case "ended":
            state = .ended
            stopTimer()
            sendStateUpdate(time: "00:00", progress: 0)
            
        default:
            break
        }
    }
    
    // MARK: - View State Builder
    
    private func sendStateUpdate(time: String, progress: Float) {
        
        let endTimeText: String
        
        if let breakModel,
           let startTime = breakModel.startTime {
            
            let endTime = startTime.addingTimeInterval(breakModel.duration)
            endTimeText = Self.timeFormatter.string(from: endTime)
            
        } else {
            endTimeText = "--:--"
        }
        
        let buttonTitle: String
        let buttonColor: UIColor
        let timelineState: TimelineState
        
        switch state {
            
        case .notStarted:
            buttonTitle = "Start my break"
            buttonColor = .systemGreen
            timelineState = .loggedIn
            
        case .running:
            buttonTitle = "End my break"
            buttonColor = .systemRed
            timelineState = .breakRunning
            
        case .ended:
            buttonTitle = ""
            buttonColor = .clear
            timelineState = .breakEnded
        }
        
        let viewState = BreakViewState(
            timerText: time,
            progress: progress,
            breakEndsText: breakModel != nil ? "Break ends at \(endTimeText)" : "",
            buttonTitle: buttonTitle,
            buttonColor: buttonColor,
            timelineState: timelineState,
            isBreakFinished: state == .ended
        )
        
        onStateChange?(viewState)
    }
    
    deinit {
        timer?.invalidate()
    }
}
