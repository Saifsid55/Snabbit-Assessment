//
//  SectionHeaderView.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//
import UIKit

final class SectionHeaderView: UIView {
    private enum Constants {
        static let titleFontSize: CGFloat = 18
        static let subtitleFontSize: CGFloat = 14
        static let stackSpacing: CGFloat = 4
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.titleFontSize)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.subtitleFontSize)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(title: String, subtitle: String?) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension SectionHeaderView {
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
