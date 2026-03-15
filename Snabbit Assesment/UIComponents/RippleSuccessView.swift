//
//  RippleSuccessView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import UIKit

final class RippleSuccessView: UIView {
    
    private let checkCircle = UIView()
    private let checkmark = UIImageView()
    
    private var rippleLayers: [CAShapeLayer] = [] 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckmark()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupCheckmark() {
        
        checkCircle.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        checkCircle.layer.cornerRadius = 50
        
        addSubview(checkCircle)
        
        checkCircle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkCircle.widthAnchor.constraint(equalToConstant: 100),
            checkCircle.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        checkmark.image = UIImage(systemName: "checkmark")
        checkmark.tintColor = UIColor.systemBlue
        checkmark.contentMode = .scaleAspectFit
        
        checkCircle.addSubview(checkmark)
        
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkmark.centerXAnchor.constraint(equalTo: checkCircle.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: checkCircle.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 40),
            checkmark.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Start Ripple
    
    func startRippleAnimation() {
        
        layoutIfNeeded()
        
        createRipple(delay: 0)
        createRipple(delay: 0.5)
        createRipple(delay: 1.0)
    }
    
    // MARK: - Stop Ripple
    
    func stopRippleAnimation() {
        
        rippleLayers.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
        
        rippleLayers.removeAll()
    }
    
    // MARK: - Ripple Creation
    
    private func createRipple(delay: TimeInterval) {
        
        let rippleLayer = CAShapeLayer()
        
        let rippleSize: CGFloat = 120
        
        rippleLayer.frame = CGRect(
            x: (bounds.width - rippleSize) / 2,
            y: (bounds.height - rippleSize) / 2,
            width: rippleSize,
            height: rippleSize
        )
        
        let circlePath = UIBezierPath(
            ovalIn: CGRect(x: 0, y: 0, width: rippleSize, height: rippleSize)
        )
        
        rippleLayer.path = circlePath.cgPath
        rippleLayer.fillColor = UIColor.white.withAlphaComponent(0.25).cgColor
        
        layer.insertSublayer(rippleLayer, below: checkCircle.layer)
        
        rippleLayers.append(rippleLayer)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 2.3
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0.6
        opacity.toValue = 0
        
        let group = CAAnimationGroup()
        group.animations = [scale, opacity]
        group.duration = 2
        group.repeatCount = .infinity
        group.beginTime = CACurrentMediaTime() + delay
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        rippleLayer.add(group, forKey: "ripple")
    }
}
