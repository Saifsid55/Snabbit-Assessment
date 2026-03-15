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
    
    private enum Constants {
        static let circleSize: CGFloat = 32
        static let circleCornerRadius: CGFloat = 16
        static let circleBorderWidth: CGFloat = 2
        static let checkmarkSize: CGFloat = 16
        static let checkmarkIcon = "checkmark"
        static let labelFontSize: CGFloat = 16
        static let labelLeadingOffset: CGFloat = 16
        static let rowHeight: CGFloat = 72
        static let lineWidth: CGFloat = 2
        static let colorAnimKey = "colorAnim"
        static let strokeAnimKey = "strokeAnim"
        static let colorAnimDuration: CFTimeInterval = 0.4
        static let strokeAnimDuration: CFTimeInterval = 0.5
        static let labelColor = UIColor(red: 0.2, green: 0.25, blue: 0.35, alpha: 1)
        static let completedColor = UIColor(red: 0.24, green: 0.78, blue: 0.60, alpha: 1)
        static let pendingColor = UIColor.systemGray4
    }
    
    private var position: Position = .first
    private let topLineLayer = CAShapeLayer()
    private let bottomLineLayer = CAShapeLayer()
    
    private lazy var circle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.circleCornerRadius
        view.layer.borderWidth = Constants.circleBorderWidth
        view.layer.borderColor = Constants.pendingColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var checkmark: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: Constants.checkmarkIcon)
        iv.tintColor = .white
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.labelFontSize, weight: .medium)
        label.textColor = Constants.labelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String, position: Position) {
        self.position = position
        super.init(frame: .zero)
        label.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLinePaths()
    }
}

private extension TimelineRowView {
    func setupUI() {
        circle.addSubview(checkmark)
        addSubview(circle)
        addSubview(label)
        setupLineLayers()
        setupConstraints()
    }
    
    func setupLineLayers() {
        [topLineLayer, bottomLineLayer].forEach {
            $0.lineWidth = Constants.lineWidth
            $0.strokeColor = Constants.pendingColor.cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.strokeEnd = 1.0
            layer.addSublayer($0)
        }
        topLineLayer.isHidden = position == .first
        bottomLineLayer.isHidden = position == .last
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            circle.leadingAnchor.constraint(equalTo: leadingAnchor),
            circle.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: Constants.circleSize),
            circle.heightAnchor.constraint(equalToConstant: Constants.circleSize),
            checkmark.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: Constants.checkmarkSize),
            checkmark.heightAnchor.constraint(equalToConstant: Constants.checkmarkSize),
            label.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: Constants.labelLeadingOffset),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightAnchor.constraint(equalToConstant: Constants.rowHeight)
        ])
    }
    
    func updateLinePaths() {
        let x = circle.frame.midX
        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: x, y: 0))
        topPath.addLine(to: CGPoint(x: x, y: circle.frame.minY))
        topLineLayer.path = topPath.cgPath
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: x, y: circle.frame.maxY))
        bottomPath.addLine(to: CGPoint(x: x, y: bounds.height))
        bottomLineLayer.path = bottomPath.cgPath
    }
    
    func animateLine(_ shapeLayer: CAShapeLayer, to color: UIColor, grow: Bool = false) {
        let colorAnim = CABasicAnimation(keyPath: "strokeColor")
        colorAnim.fromValue = shapeLayer.strokeColor
        colorAnim.toValue = color.cgColor
        colorAnim.duration = Constants.colorAnimDuration
        colorAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.add(colorAnim, forKey: Constants.colorAnimKey)
        guard grow else { return }
        let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnim.fromValue = 0.0
        strokeAnim.toValue = 1.0
        strokeAnim.duration = Constants.strokeAnimDuration
        strokeAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shapeLayer.strokeEnd = 1.0
        shapeLayer.add(strokeAnim, forKey: Constants.strokeAnimKey)
    }
}

extension TimelineRowView {
    func update(state: State) {
        switch state {
        case .completed:
            circle.backgroundColor = Constants.completedColor
            circle.layer.borderColor = Constants.completedColor.cgColor
            checkmark.isHidden = false
            animateLine(topLineLayer, to: Constants.completedColor)
            animateLine(bottomLineLayer, to: Constants.completedColor, grow: true)
        case .active:
            circle.backgroundColor = .systemOrange
            circle.layer.borderColor = UIColor.systemOrange.cgColor
            checkmark.isHidden = true
            animateLine(topLineLayer, to: .systemOrange)
            animateLine(bottomLineLayer, to: Constants.pendingColor)
        case .pending:
            circle.backgroundColor = .clear
            circle.layer.borderColor = Constants.pendingColor.cgColor
            checkmark.isHidden = true
            animateLine(topLineLayer, to: Constants.pendingColor)
            animateLine(bottomLineLayer, to: Constants.pendingColor)
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
