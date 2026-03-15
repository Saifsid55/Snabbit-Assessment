//
//  TimelineRowView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import UIKit

final class TimelineRowView: UIView {
    
    enum State { case completed, active, pending }
    enum Position { case first, middle, last }
    
    private let circle = UIView()
    private let checkmark = UIImageView()
    private let label = UILabel()
    
    // ← Replace UIView lines with shape layers
    private let topLineLayer = CAShapeLayer()
    private let bottomLineLayer = CAShapeLayer()
    
    private var position: Position = .first
    
    init(title: String, position: Position) {
        self.position = position
        super.init(frame: .zero)
        setupUI(title: title, position: position)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLinePaths()
    }
    
    private func updateLinePaths() {
        let x = circle.frame.midX
        
        // Top line path: from top of view to top of circle
        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: x, y: 0))
        topPath.addLine(to: CGPoint(x: x, y: circle.frame.minY))
        topLineLayer.path = topPath.cgPath
        
        // Bottom line path: from bottom of circle to bottom of view
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: x, y: circle.frame.maxY))
        bottomPath.addLine(to: CGPoint(x: x, y: bounds.height))
        bottomLineLayer.path = bottomPath.cgPath
    }
    
    private func setupUI(title: String, position: Position) {
        
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 0.2, green: 0.25, blue: 0.35, alpha: 1)
        
        // Circle
        circle.layer.cornerRadius = 16
        circle.layer.borderWidth = 2
        circle.layer.borderColor = UIColor.systemGray4.cgColor
        
        // Checkmark
        checkmark.image = UIImage(systemName: "checkmark")
        checkmark.tintColor = .white
        checkmark.isHidden = true
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        circle.addSubview(checkmark)
        
        // Setup line layers
        [topLineLayer, bottomLineLayer].forEach {
            $0.lineWidth = 2
            $0.strokeColor = UIColor.systemGray4.cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.strokeEnd = 1.0
            layer.addSublayer($0)
        }
        
        topLineLayer.isHidden = (position == .first)
        bottomLineLayer.isHidden = (position == .last)
        
        [circle, label].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            circle.leadingAnchor.constraint(equalTo: leadingAnchor),
            circle.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: 32),
            circle.heightAnchor.constraint(equalToConstant: 32),
            
            checkmark.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 16),
            checkmark.heightAnchor.constraint(equalToConstant: 16),
            
            label.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    // ← Animate a layer's color and stroke
    private func animateLine(_ shapeLayer: CAShapeLayer, to color: UIColor, grow: Bool = false) {
        
        // Color animation
        let colorAnim = CABasicAnimation(keyPath: "strokeColor")
        colorAnim.fromValue = shapeLayer.strokeColor
        colorAnim.toValue = color.cgColor
        colorAnim.duration = 0.4
        colorAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.add(colorAnim, forKey: "colorAnim")
        
        // Grow animation (strokeEnd 0 → 1)
        if grow {
            let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnim.fromValue = 0.0
            strokeAnim.toValue = 1.0
            strokeAnim.duration = 0.5
            strokeAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            shapeLayer.strokeEnd = 1.0
            shapeLayer.add(strokeAnim, forKey: "strokeAnim")
        }
    }
    
    func update(state: State) {
        let green = UIColor(red: 0.24, green: 0.78, blue: 0.60, alpha: 1)
        
        switch state {
        case .completed:
            circle.backgroundColor = green
            circle.layer.borderColor = green.cgColor
            checkmark.isHidden = false
            animateLine(topLineLayer, to: green)
            animateLine(bottomLineLayer, to: green, grow: true) // ← grows down
            
        case .active:
            circle.backgroundColor = .systemOrange
            circle.layer.borderColor = UIColor.systemOrange.cgColor
            checkmark.isHidden = true
            animateLine(topLineLayer, to: .systemOrange)
            animateLine(bottomLineLayer, to: .systemGray4)
            
        case .pending:
            circle.backgroundColor = .clear
            circle.layer.borderColor = UIColor.systemGray4.cgColor
            checkmark.isHidden = true
            animateLine(topLineLayer, to: .systemGray4)
            animateLine(bottomLineLayer, to: .systemGray4)
        }
    }
    
    func setBottomLineColor(_ color: UIColor, animated: Bool = true) {
        if animated {
            animateLine(bottomLineLayer, to: color, grow: true)
        } else {
            bottomLineLayer.strokeColor = color.cgColor
        }
    }
}
