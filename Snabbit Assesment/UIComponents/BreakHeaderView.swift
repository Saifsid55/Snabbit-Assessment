//
//  Untitled.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class BreakHeaderView: UIView {
    
    let menuButton = UIButton(type: .system)
    let helpButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        menuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        menuButton.tintColor = .label
        
        // Use configuration instead of deprecated contentEdgeInsets
        var config = UIButton.Configuration.plain()
        config.title = "Help"
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
        helpButton.configuration = config
        
        helpButton.layer.cornerRadius = 16
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        let stack = UIStackView(arrangedSubviews: [menuButton, UIView(), helpButton])
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
