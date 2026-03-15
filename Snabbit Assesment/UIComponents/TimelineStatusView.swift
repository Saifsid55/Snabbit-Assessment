//
//  TimelineStatusView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

enum TimelineState {
    case loggedIn, breakRunning, breakEnded
}

final class TimelineStatusView: UIView {
    private enum Constants {
        static let stackSpacing: CGFloat = 0
        static let loginTitle = "Login"
        static let lunchTitle = "Lunch in Progress"
        static let logoutTitle = "Logout"
        static let completedColor = UIColor(red: 0.24, green: 0.78, blue: 0.60, alpha: 1)
    }
    
    private lazy var loginRow = TimelineRowView(title: Constants.loginTitle, position: .first)
    private lazy var lunchRow = TimelineRowView(title: Constants.lunchTitle, position: .middle)
    private lazy var logoutRow = TimelineRowView(title: Constants.logoutTitle, position: .last)
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginRow, lunchRow, logoutRow])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        update(state: .loggedIn)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension TimelineStatusView {
    func setupUI() {
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension TimelineStatusView {
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
            loginRow.setBottomLineColor(Constants.completedColor)
            lunchRow.update(state: .completed)
            logoutRow.update(state: .pending)
        }
    }
}
