//
//  SectionHeaderView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import UIKit

final class SectionHeaderView: UIView {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    init(title: String, subtitle: String?) {
        super.init(frame: .zero)
        setup(title: title, subtitle: subtitle)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup(title: String, subtitle: String?) {

        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 18)

        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4

        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
