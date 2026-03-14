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

        helpButton.setTitle("Help", for: .normal)
        helpButton.layer.cornerRadius = 16
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.white.cgColor

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
