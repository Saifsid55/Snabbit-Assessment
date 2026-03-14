//
//  BreakTimerCardView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakTimerCardView: UIView {
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var timerView: CircularTimerView!
    var breakEndsLabel: UILabel!
    var endBreakButton: UIButton!
    var stack: UIStackView!
    var backgroundImageView: UIImageView!
    var breakFinishedLabel: UILabel!
    var successView: RippleSuccessView!
    
    private var timerHeightConstraint: NSLayoutConstraint!
    private var endBreakButtonHeightConstraint: NSLayoutConstraint!
    
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
        subTitleLabel()
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
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    private func setupStack() {
        stack = UIStackView()
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        
        NSLayoutConstraint.activate([
            
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ])
    }
    
    
    private func createTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "We value your hard work!"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0          // ← ADD THIS
        titleLabel.setContentHuggingPriority(.required, for: .vertical)  // ← ADD THIS
        
        stack.addArrangedSubview(titleLabel)
    }
    
    private func subTitleLabel() {
        subtitleLabel = UILabel()
        subtitleLabel.text = "Take this time to relax"
        subtitleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0       // ← ADD THIS
        subtitleLabel.setContentHuggingPriority(.required, for: .vertical)  // ← ADD THIS
        
        stack.addArrangedSubview(subtitleLabel)
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
        breakEndsLabel.text = "Break ends at --:-- --"  // ← placeholder until VM updates it
        breakEndsLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        breakEndsLabel.font = .systemFont(ofSize: 14, weight: .medium)
        breakEndsLabel.textAlignment = .center
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
        breakFinishedLabel.text =
        "Hope you are feeling refreshed and ready to start working again"
        
        breakFinishedLabel.textColor = .white
        breakFinishedLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        breakFinishedLabel.textAlignment = .center
        breakFinishedLabel.numberOfLines = 0
        breakFinishedLabel.isHidden = true
        
        stack.addArrangedSubview(breakFinishedLabel)
    }
    
    func showBreakFinishedState() {
        
        timerHeightConstraint.isActive = false
        endBreakButtonHeightConstraint.isActive = false
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
        timerView.isHidden = true
        breakEndsLabel.isHidden = true
        endBreakButton.isHidden = true
        
        successView.isHidden = false
        breakFinishedLabel.isHidden = false
        
        UIView.animate(withDuration: 0.35) {
            self.layoutIfNeeded()
        }
    }
}
