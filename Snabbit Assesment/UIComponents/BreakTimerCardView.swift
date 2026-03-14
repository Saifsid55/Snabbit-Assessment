//
//  BreakTimerCardView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakTimerCardView: UIView {
    
    let timerView = CircularTimerView()
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let breakEndsLabel = UILabel()
    
    let endBreakButton = UIButton()
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupUI() {
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        titleLabel.text = "We value your hard work!"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "Take this time to relax"
        subtitleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textAlignment = .center
        
        breakEndsLabel.textColor = .white
        breakEndsLabel.font = .systemFont(ofSize: 14)
        breakEndsLabel.textAlignment = .center
        
        endBreakButton.setTitle("End my break", for: .normal)
        endBreakButton.backgroundColor = .systemRed
        endBreakButton.layer.cornerRadius = 10
        endBreakButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            timerView,
            breakEndsLabel,
            endBreakButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center   // IMPORTANT
        
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        timerView.translatesAutoresizingMaskIntoConstraints = false
        endBreakButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            timerView.heightAnchor.constraint(equalToConstant: 180),
            timerView.widthAnchor.constraint(equalToConstant: 180),
//            timerView.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            
            endBreakButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupGradient() {
        
        gradientLayer.colors = [
            UIColor(red: 0.45, green: 0.30, blue: 0.95, alpha: 1).cgColor,
            UIColor(red: 0.22, green: 0.47, blue: 0.90, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
