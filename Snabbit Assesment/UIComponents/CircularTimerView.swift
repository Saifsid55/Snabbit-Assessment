//
//  CircularTimerView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class CircularTimerView: UIView {
    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let timeLabel = UILabel()
    private let breakLabel = UILabel()
    private var currentProgress: Float = 1.0
    
    // 60° gap at the bottom
    private let gapAngle: CGFloat = .pi / 3
    
    // Arc starts bottom-left, goes clockwise, ends bottom-right
    private var startAngle: CGFloat { (.pi / 2) + (gapAngle / 2) }
    private var endAngle:   CGFloat { (.pi / 2) - (gapAngle / 2) + 2 * .pi }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    
    private func setupLayers() {
        trackLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius: CGFloat = 70
        
        let arcPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        // Track (dim background arc)
        trackLayer.path = arcPath.cgPath
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        trackLayer.lineWidth = 12
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        layer.insertSublayer(trackLayer, at: 0)
        
        // Progress (white foreground arc, drains as time passes)
        progressLayer.path = arcPath.cgPath
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 12
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(currentProgress)
        layer.insertSublayer(progressLayer, at: 1)
    }
    
    private func setupLabels() {
        // Time in the center
        timeLabel.font = .systemFont(ofSize: 28, weight: .bold)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.text = "00:00"
        
        // "Break" in the bottom gap between arc ends
        breakLabel.text = "Break"
        breakLabel.font = .systemFont(ofSize: 13)
        breakLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        breakLabel.textAlignment = .center
        
        addSubview(timeLabel)
        addSubview(breakLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        breakLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Time label: center of the circle
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Break label: sits in the gap at the bottom
            // radius(70) * sin(60°) ≈ 61pts below center
            breakLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            breakLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 68)
        ])
    }
    
    func update(time: String, progress: Float) {
        timeLabel.text = time
        currentProgress = 1.0 - progress
        progressLayer.strokeEnd = CGFloat(currentProgress)
    }
}
