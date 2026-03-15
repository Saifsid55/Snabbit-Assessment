//
//  BreakTimerCardView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakTimerCardView: UIView {
    private enum Constants {
        static let cardCornerRadius: CGFloat = 16
        static let stackSpacingDefault: CGFloat = 12
        static let stackSpacingCompact: CGFloat = 8
        static let stackHorizontalInset: CGFloat = 20
        static let titleText = "We value your hard work! \n Take this time to relax"
        static let titleFontSize: CGFloat = 18
        static let timerSize: CGFloat = 300
        static let timerWidth: CGFloat = 280
        static let breakEndsText = "Break ends at --:-- --"
        static let breakEndsAlpha: CGFloat = 0.85
        static let breakEndsFontSize: CGFloat = 14
        static let endBreakTitle = "End my break"
        static let endBreakFontSize: CGFloat = 16
        static let endBreakButtonHeight: CGFloat = 44
        static let endBreakCornerRadius: CGFloat = 10
        static let successViewSize: CGFloat = 180
        static let breakFinishedText = "Hope you are feeling refreshed and ready to start working again"
        static let breakFinishedFontSize: CGFloat = 16
        static let spacerFixedHeight: CGFloat = 24
        static let spacerCompactHeight: CGFloat = 8
        static let backgroundImageName = "timerCardBG"
        static let animationDurationShort: CGFloat = 0.25
        static let animationDurationDefault: CGFloat = 0.35
    }
    
    private enum CardDisplayState {
        case preBreak, timer, finished
    }
    
    private var currentDisplayState: CardDisplayState?
    private var timerHeightConstraint: NSLayoutConstraint!
    private var endBreakButtonHeightConstraint: NSLayoutConstraint!
    private var spacerEqualHeightConstraint: NSLayoutConstraint!
    private var topSpacerFixedConstraint: NSLayoutConstraint!
    private var bottomSpacerFixedConstraint: NSLayoutConstraint!
    
    // MARK: - Views
    
    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.backgroundImageName)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setContentHuggingPriority(.defaultLow, for: .vertical)
        iv.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return iv
    }()
    
    private lazy var topSpacer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var bottomSpacer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.textColor = .white
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    var timerView: CircularTimerView = {
        let view = CircularTimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var breakEndsLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.breakEndsText
        label.textColor = UIColor.white.withAlphaComponent(Constants.breakEndsAlpha)
        label.font = .systemFont(ofSize: Constants.breakEndsFontSize, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    var endBreakButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.endBreakTitle, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = Constants.endBreakCornerRadius
        button.titleLabel?.font = .systemFont(ofSize: Constants.endBreakFontSize, weight: .semibold)
        return button
    }()
    
    var successView: RippleSuccessView = {
        let view = RippleSuccessView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var breakFinishedLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.breakFinishedText
        label.textColor = .white
        label.font = .systemFont(ofSize: Constants.breakFinishedFontSize, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacingDefault
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Setup

private extension BreakTimerCardView {
    func setupUI() {
        layer.cornerRadius = Constants.cardCornerRadius
        clipsToBounds = true
        setupBackground()
        setupStack()
        setupConstraints()
    }
    
    func setupBackground() {
        insertSubview(backgroundImageView, at: 0)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }
    
    func setupStack() {
        addSubview(stack)
        stack.addArrangedSubview(topSpacer)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(timerView)
        stack.addArrangedSubview(successView)
        stack.addArrangedSubview(breakEndsLabel)
        stack.addArrangedSubview(breakFinishedLabel)
        stack.addArrangedSubview(endBreakButton)
        stack.addArrangedSubview(bottomSpacer)
    }
    
    func setupConstraints() {
        timerHeightConstraint = timerView.heightAnchor.constraint(equalToConstant: Constants.timerSize)
        endBreakButtonHeightConstraint = endBreakButton.heightAnchor.constraint(equalToConstant: Constants.endBreakButtonHeight)
        spacerEqualHeightConstraint = topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor)
        topSpacerFixedConstraint = topSpacer.heightAnchor.constraint(equalToConstant: Constants.spacerFixedHeight)
        bottomSpacerFixedConstraint = bottomSpacer.heightAnchor.constraint(equalToConstant: Constants.spacerFixedHeight)
        spacerEqualHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackHorizontalInset),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.stackHorizontalInset),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            timerHeightConstraint,
            timerView.widthAnchor.constraint(equalToConstant: Constants.timerWidth),
            endBreakButtonHeightConstraint,
            endBreakButton.widthAnchor.constraint(equalTo: stack.widthAnchor),
            successView.widthAnchor.constraint(equalToConstant: Constants.successViewSize),
            successView.heightAnchor.constraint(equalToConstant: Constants.successViewSize)
        ])
    }
}

// MARK: - State

extension BreakTimerCardView {
    func showPreBreakState() {
        guard currentDisplayState != .preBreak else { return }
        currentDisplayState = .preBreak
        stack.spacing = Constants.stackSpacingCompact
        spacerEqualHeightConstraint.isActive = false
        topSpacerFixedConstraint.constant = Constants.spacerCompactHeight
        bottomSpacerFixedConstraint.constant = Constants.spacerCompactHeight
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
        successView.stopRippleAnimation()
        UIView.animate(withDuration: Constants.animationDurationShort) { self.layoutIfNeeded() }
    }
    
    func showTimerState() {
        guard currentDisplayState != .timer else { return }
        currentDisplayState = .timer
        stack.spacing = Constants.stackSpacingDefault
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
        successView.stopRippleAnimation()
        UIView.animate(withDuration: Constants.animationDurationDefault) { self.layoutIfNeeded() }
    }
    
    func showBreakFinishedState() {
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
            UIView.animate(withDuration: Constants.animationDurationDefault) { self.layoutIfNeeded() }
        }
        successView.stopRippleAnimation()
        successView.startRippleAnimation()
    }
}
