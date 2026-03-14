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
        setupBreakEndsLabel()
        setupEndBreakButton()
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
        
        NSLayoutConstraint.activate([
            timerView.heightAnchor.constraint(equalToConstant: 200),
            timerView.widthAnchor.constraint(equalToConstant: 180),
            timerView.centerXAnchor.constraint(equalTo: stack.centerXAnchor)
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
        
        NSLayoutConstraint.activate([
            endBreakButton.heightAnchor.constraint(equalToConstant: 44),
            endBreakButton.widthAnchor.constraint(equalTo: stack.widthAnchor)  // ← ADD THIS
        ])
    }
    
}
