//
//  TimelineStatusView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

final class TimelineStatusView: UIView {

    private func makeRow(title: String, color: UIColor) -> UIView {

        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 6

        dot.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: 12),
            dot.heightAnchor.constraint(equalToConstant: 12)
        ])

        let label = UILabel()
        label.text = title

        let stack = UIStackView(arrangedSubviews: [dot, label])
        stack.axis = .horizontal
        stack.spacing = 8

        return stack
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let login = makeRow(title: "Login", color: .systemGreen)
        let lunch = makeRow(title: "Lunch in Progress", color: .systemOrange)
        let logout = makeRow(title: "Logout", color: .systemGray)

        let stack = UIStackView(arrangedSubviews: [login, lunch, logout])
        stack.axis = .vertical
        stack.spacing = 16

        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
