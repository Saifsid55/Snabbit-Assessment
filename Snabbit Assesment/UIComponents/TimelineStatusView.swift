//
//  TimelineStatusView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

enum TimelineState {
    case loggedIn
    case breakRunning
    case breakEnded
}

final class TimelineStatusView: UIView {

    // ← Pass position so first/last rows hide their outer lines
    private let loginRow  = TimelineRowView(title: "Login",             position: .first)
    private let lunchRow  = TimelineRowView(title: "Lunch in Progress", position: .middle)
    private let logoutRow = TimelineRowView(title: "Logout",            position: .last)

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stack = UIStackView(arrangedSubviews: [loginRow, lunchRow, logoutRow])
        stack.axis = .vertical
        stack.spacing = 0 

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        update(state: .loggedIn)
    }

    required init?(coder: NSCoder) { fatalError() }

    func update(state: TimelineState) {
        switch state {
        case .loggedIn:
            loginRow.update(state: .completed)
            loginRow.setBottomLineColor(.systemGray4)
            lunchRow.update(state: .pending)
            logoutRow.update(state: .pending)

        case .breakRunning:
            loginRow.update(state: .completed)
            loginRow.setBottomLineColor(.systemOrange)
            lunchRow.update(state: .active)
            logoutRow.update(state: .pending)

        case .breakEnded:
            loginRow.update(state: .completed)
            loginRow.setBottomLineColor(UIColor(red: 0.24, green: 0.78, blue: 0.60, alpha: 1))
            lunchRow.update(state: .completed)
            logoutRow.update(state: .pending)
        }
    }
}
