//
//  BreakTimerCardView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakTimerCardView: UIView {
    
    var titleLabel: UILabel!
    var timerView: CircularTimerView!
    var breakEndsLabel: UILabel!
    var endBreakButton: UIButton!
    var stack: UIStackView!
    var backgroundImageView: UIImageView!
    var breakFinishedLabel: UILabel!
    var successView: RippleSuccessView!
    private var topSpacer: UIView!
    private var bottomSpacer: UIView!
    
    private var timerHeightConstraint: NSLayoutConstraint!
    private var endBreakButtonHeightConstraint: NSLayoutConstraint!
    private var spacerEqualHeightConstraint: NSLayoutConstraint!
    private var topSpacerFixedConstraint: NSLayoutConstraint!
    private var bottomSpacerFixedConstraint: NSLayoutConstraint!
    
    private enum CardDisplayState {
        case preBreak, timer, finished
    }
    private var currentDisplayState: CardDisplayState?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupUI() {
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        setupBackground()
        setupStack()
        createTitleLabel()
        setupTimerView()
        setupSuccessView()
        setupBreakEndsLabel()
        setupEndBreakButton()
        setupBreakFinishedLabel()
    }
    
    private func setupBackground() {
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "timerCardBG")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        insertSubview(backgroundImageView, at: 0)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        backgroundImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        backgroundImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    
    private func setupStack() {
        stack = UIStackView()
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        topSpacer = UIView()
        bottomSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        
        topSpacerFixedConstraint = topSpacer.heightAnchor.constraint(equalToConstant: 24)
        bottomSpacerFixedConstraint = bottomSpacer.heightAnchor.constraint(equalToConstant: 24)
        
        stack.addArrangedSubview(topSpacer)
    }
    
    private func createTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "We value your hard work! \n Take this time to relax"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        stack.addArrangedSubview(titleLabel)
    }
    
    private func setupTimerView() {
        timerView = CircularTimerView()
        timerView.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(timerView)
        
        timerHeightConstraint = timerView.heightAnchor.constraint(equalToConstant: 300)
        
        NSLayoutConstraint.activate([
            timerHeightConstraint,
            timerView.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func setupBreakEndsLabel() {
        breakEndsLabel = UILabel()
        breakEndsLabel.text = "Break ends at --:-- --"
        breakEndsLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        breakEndsLabel.font = .systemFont(ofSize: 14, weight: .medium)
        breakEndsLabel.textAlignment = .center
        breakEndsLabel.isHidden = true
        stack.addArrangedSubview(breakEndsLabel)
    }
    
    private func setupEndBreakButton() {
        endBreakButton = UIButton()
        endBreakButton.translatesAutoresizingMaskIntoConstraints = false
        endBreakButton.setTitle("End my break", for: .normal)
        endBreakButton.backgroundColor = .systemRed
        endBreakButton.layer.cornerRadius = 10
        endBreakButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        stack.addArrangedSubview(endBreakButton)
        
        endBreakButtonHeightConstraint = endBreakButton.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([
            endBreakButtonHeightConstraint,
            endBreakButton.widthAnchor.constraint(equalTo: stack.widthAnchor)
        ])
        
        stack.addArrangedSubview(bottomSpacer)
        
        spacerEqualHeightConstraint = topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor)
        spacerEqualHeightConstraint.isActive = true
    }
    
    private func setupSuccessView() {
        
        successView = RippleSuccessView()
        successView.isHidden = true
        
        stack.addArrangedSubview(successView)
        
        successView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            successView.widthAnchor.constraint(equalToConstant: 180),
            successView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func setupBreakFinishedLabel() {
        
        breakFinishedLabel = UILabel()
        breakFinishedLabel.text = "Hope you are feeling refreshed and ready to start working again"
        breakFinishedLabel.textColor = .white
        breakFinishedLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        breakFinishedLabel.textAlignment = .center
        breakFinishedLabel.numberOfLines = 0
        breakFinishedLabel.isHidden = true
        
        stack.insertArrangedSubview(breakFinishedLabel, at: stack.arrangedSubviews.count - 1)
    }
    
    func showPreBreakState() {
        guard currentDisplayState != .preBreak else { return }
        currentDisplayState = .preBreak
        
        stack.spacing = 8
        
        spacerEqualHeightConstraint.isActive = false
        topSpacerFixedConstraint.constant = 8
        bottomSpacerFixedConstraint.constant = 8
        topSpacerFixedConstraint.isActive = true
        bottomSpacerFixedConstraint.isActive = true
        
        timerHeightConstraint.isActive = true
        endBreakButtonHeightConstraint.isActive = true
        
        titleLabel.isHidden = false
        timerView.isHidden = false
        endBreakButton.isHidden = false
        breakEndsLabel.isHidden = true
        
        successView.isHidden = true
        breakFinishedLabel.isHidden = true
        successView.stopRippleAnimation()  // ← ensure clean state
        
        UIView.animate(withDuration: 0.25) { self.layoutIfNeeded() }
    }
    
    func showTimerState() {
        guard currentDisplayState != .timer else { return }
        currentDisplayState = .timer
        
        stack.spacing = 12
        
        timerHeightConstraint.isActive = true
        endBreakButtonHeightConstraint.isActive = true
        topSpacerFixedConstraint.isActive = false
        bottomSpacerFixedConstraint.isActive = false
        spacerEqualHeightConstraint.isActive = true
        
        titleLabel.isHidden = false
        timerView.isHidden = false
        endBreakButton.isHidden = false
        breakEndsLabel.isHidden = false
        
        successView.isHidden = true
        breakFinishedLabel.isHidden = true
        successView.stopRippleAnimation()  // ← stop before hiding
        
        UIView.animate(withDuration: 0.35) { self.layoutIfNeeded() }
    }
    
    func showBreakFinishedState() {
        // Do NOT guard here — always restart animation on re-entry
        let isFirstEntry = currentDisplayState != .finished
        currentDisplayState = .finished
        
        if isFirstEntry {
            timerHeightConstraint.isActive = false
            endBreakButtonHeightConstraint.isActive = false
            spacerEqualHeightConstraint.isActive = false
            topSpacerFixedConstraint.isActive = true
            bottomSpacerFixedConstraint.isActive = true
            
            titleLabel.isHidden = true
            timerView.isHidden = true
            breakEndsLabel.isHidden = true
            endBreakButton.isHidden = true
            breakFinishedLabel.isHidden = false
            successView.isHidden = false
            
            UIView.animate(withDuration: 0.35) { self.layoutIfNeeded() }
        }
        
        // Always stop then restart — fixes the "back from logout" animation freeze
        successView.stopRippleAnimation()
        successView.startRippleAnimation()  // ← clean restart every time
    }
    
}
