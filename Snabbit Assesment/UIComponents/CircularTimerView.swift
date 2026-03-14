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

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayers()
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupLayers() {

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = 70

        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 2 * .pi,
            clockwise: true
        )

        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        trackLayer.lineWidth = 12
        trackLayer.fillColor = UIColor.clear.cgColor

        layer.addSublayer(trackLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 12
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0

        layer.addSublayer(progressLayer)
    }

    private func setupLabel() {

        timeLabel.font = .systemFont(ofSize: 28, weight: .bold)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center

        addSubview(timeLabel)

        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func update(time: String, progress: Float) {

        timeLabel.text = time

        progressLayer.strokeEnd = CGFloat(progress)
    }
}
