//
//  CircularTimerView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class CircularTimerView: UIView {
    private enum Constants {
        static let gapAngle: CGFloat = .pi / 2.5
        static let arcRadius: CGFloat = 70
        static let arcLineWidth: CGFloat = 12
        static let trackAlpha: CGFloat = 0.2
        static let timeFontSize: CGFloat = 28
        static let breakFontSize: CGFloat = 18
        static let breakLabelAlpha: CGFloat = 0.85
        static let breakLabelOffset: CGFloat = 68
        static let timeLabelDefault = "00:00"
        static let breakLabelText = "Break"
    }
    
    private var currentProgress: Float = 1.0
    private var startAngle: CGFloat { (.pi / 2) + (Constants.gapAngle / 2) }
    private var endAngle: CGFloat { (.pi / 2) - (Constants.gapAngle / 2) + 2 * .pi }
    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.timeFontSize, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = Constants.timeLabelDefault
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var breakLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.breakLabelText
        label.font = .systemFont(ofSize: Constants.breakFontSize, weight: .semibold)
        label.textColor = UIColor.white.withAlphaComponent(Constants.breakLabelAlpha)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
}

private extension CircularTimerView {
    func setupLayers() {
        trackLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let arcPath = UIBezierPath(
            arcCenter: center,
            radius: Constants.arcRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        ).cgPath
        trackLayer.path = arcPath
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(Constants.trackAlpha).cgColor
        trackLayer.lineWidth = Constants.arcLineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        layer.insertSublayer(trackLayer, at: 0)
        progressLayer.path = arcPath
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = Constants.arcLineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(currentProgress)
        layer.insertSublayer(progressLayer, at: 1)
    }
    
    func setupLabels() {
        addSubview(timeLabel)
        addSubview(breakLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            breakLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            breakLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.breakLabelOffset)
        ])
    }
}

extension CircularTimerView {
    func update(time: String, progress: Float) {
        timeLabel.text = time
        currentProgress = 1.0 - progress
        progressLayer.strokeEnd = CGFloat(currentProgress)
    }
}
