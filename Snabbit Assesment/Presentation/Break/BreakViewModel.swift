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
    private let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    
    // MARK: - State
    
    private var breakModel: Break?
    private var timerTask: Task<Void, Never>?
    private var state: BreakState = .notStarted
    
    // MARK: - Delegate
    weak var delegate: BreakViewModelDelegate?
    
    // MARK: - Formatter
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    // MARK: - Init
    init(observeBreakUseCase: ObserveBreakUseCaseProtocol,
         startBreakUseCase: StartBreakUseCaseProtocol,
         endBreakUseCase: EndBreakUseCaseProtocol,
         getCurrentUserUseCase: GetCurrentUserUseCaseProtocol) {
        self.observeBreakUseCase = observeBreakUseCase
        self.startBreakUseCase = startBreakUseCase
        self.endBreakUseCase = endBreakUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
    }
    
    // MARK: - Lifecycle
    func loadData() async {
        await fetchUsername()
        observeBreakUseCase.execute { [weak self] breakModel in
            guard let self else { return }
            Task { await self.handleBreakModelUpdate(breakModel) }
        }
    }
    
    // MARK: - Actions
    func didTapBreakButton() async {
        switch state {
        case .notStarted: await startBreak()
        case .running: delegate?.didReceiveError("confirm_end")
        case .ended: break
        }
    }
    
    func endBreakEarly() async {
        do {
            try await endBreakUseCase.execute()
        } catch {
            delegate?.didReceiveError("Failed to end break")
        }
    }
    
    func didResetBreak() {
        breakModel = nil
        state = .notStarted
        stopTimer()
        sendStateUpdate(time: "00:00", progress: 0)
    }
    
    func refreshState() async {
        await applyBreakModelState(breakModel)
    }
    
    // MARK: - Private Actions
    private func startBreak() async {
        do {
            try await startBreakUseCase.execute()
        } catch {
            delegate?.didReceiveError("Failed to start break")
        }
    }
    
    // MARK: - Break Model Handling
    private func handleBreakModelUpdate(_ breakModel: Break?) async {
        self.breakModel = breakModel
        await applyBreakModelState(breakModel)
    }
    
    private func applyBreakModelState(_ breakModel: Break?) async {
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
            updateTime()
        case "ended":
            state = .ended
            stopTimer()
            sendStateUpdate(time: "00:00", progress: 0)
        default:
            break
        }
    }
    
    // MARK: - Timer
    private func startTimer() {
        stopTimer()
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { break }
                self?.updateTime()
            }
        }
    }
    
    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    private func updateTime() {
        guard let breakModel, let startTime = breakModel.startTime, breakModel.duration > 0 else { return }
        
        let endTime = startTime.addingTimeInterval(breakModel.duration)
        let remaining = endTime.timeIntervalSinceNow
        
        guard remaining > 0 else {
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
    
    // MARK: - View State Builder
    private func sendStateUpdate(time: String, progress: Float) {
        let endTimeText: String
        
        if let breakModel, let startTime = breakModel.startTime {
            let endTime: Date
            if breakModel.status == "ended", let actualEndTime = breakModel.endTime {
                endTime = actualEndTime
            } else {
                endTime = startTime.addingTimeInterval(breakModel.duration)
            }
            endTimeText = Self.timeFormatter.string(from: endTime)
        } else {
            endTimeText = "--:--"
        }
        
        let buttonTitle: String
        let buttonColor: UIColor
        let timelineState: TimelineState
        let titleText: String
        
        switch state {
        case .notStarted:
            buttonTitle = "Start my break"
            buttonColor = .systemGreen
            timelineState = .loggedIn
            titleText = "Don't forget to take a break"
        case .running:
            buttonTitle = "End my break"
            buttonColor = .systemRed
            timelineState = .breakRunning
            titleText = "You are on break!"
        case .ended:
            buttonTitle = ""
            buttonColor = .clear
            timelineState = .breakEnded
            titleText = "Break ended at \(endTimeText)"
        }
        
        let viewState = BreakViewState(
            timerText: time,
            progress: progress,
            breakEndsText: breakModel != nil ? "Break ends at \(endTimeText)" : "",
            buttonTitle: buttonTitle,
            buttonColor: buttonColor,
            timelineState: timelineState,
            isBreakFinished: state == .ended,
            titleText: titleText
        )
        
        delegate?.didUpdateState(viewState)
    }
    
    // MARK: - Username
    private func fetchUsername() async {
        do {
            let user = try await getCurrentUserUseCase.execute()
            delegate?.didUpdateUsername(user.username)
        } catch {
            delegate?.didUpdateUsername("User")
        }
    }
    
    // MARK: - Deinit
    deinit {
        timerTask?.cancel()
    }
}
