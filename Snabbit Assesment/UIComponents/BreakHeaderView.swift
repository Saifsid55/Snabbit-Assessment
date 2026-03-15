//
//  Untitled.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 14/03/26.
//

import UIKit

protocol BreakHeaderViewDelegate: AnyObject {
    func didTapHelp()
}

final class BreakHeaderView: UIView {
    private enum Constants {
        static let height: CGFloat = 44
        static let helpText = "Help"
        static let helpIcon = "phone.fill"
        static let menuIcon = "line.3.horizontal"
        static let coffeeImageName = "coffee"
        static let borderRadius: CGFloat = 8
        static let borderWidth: CGFloat = 1
        static let borderAlpha: CGFloat = 0.7
        static let iconSize: CGFloat = 16
        static let coffeeIconSize: CGFloat = 20
        static let coffeeViewWidth: CGFloat = 48
        static let actionViewHeight: CGFloat = 36
        static let innerStackSpacing: CGFloat = 6
        static let rightStackSpacing: CGFloat = 12
        static let horizontalInset: CGFloat = 14
        static let helpFontSize: CGFloat = 15
        static let menuIconSize: CGFloat = 20
    }
    
    weak var delegate: BreakHeaderViewDelegate?
    
    // MARK: - Views
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(
                systemName: Constants.menuIcon,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.menuIconSize, weight: .medium)
            ),
            for: .normal
        )
        button.tintColor = .white
        return button
    }()
    
    private lazy var helpImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: Constants.helpIcon)?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            iv.heightAnchor.constraint(equalToConstant: Constants.iconSize)
        ])
        return iv
    }()
    
    private lazy var helpLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.helpText
        label.textColor = .white
        label.font = .systemFont(ofSize: Constants.helpFontSize, weight: .regular)
        return label
    }()
    
    private lazy var helpInnerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [helpImageView, helpLabel])
        stack.axis = .horizontal
        stack.spacing = Constants.innerStackSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var helpView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.borderRadius
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.white.withAlphaComponent(Constants.borderAlpha).cgColor
        view.clipsToBounds = true
        view.addSubview(helpInnerStack)
        NSLayoutConstraint.activate([
            helpInnerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helpInnerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            helpInnerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            helpInnerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset)
        ])
        let gesture = UITapGestureRecognizer(target: self, action: #selector(helpTapped))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private lazy var coffeeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.coffeeImageName)?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: Constants.coffeeIconSize),
            iv.heightAnchor.constraint(equalToConstant: Constants.coffeeIconSize)
        ])
        return iv
    }()
    
    private lazy var coffeeIconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.borderRadius
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.white.withAlphaComponent(Constants.borderAlpha).cgColor
        view.clipsToBounds = true
        view.addSubview(coffeeImageView)
        NSLayoutConstraint.activate([
            coffeeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coffeeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    private lazy var rightStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [helpView, coffeeIconView])
        stack.axis = .horizontal
        stack.spacing = Constants.rightStackSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [menuButton, UIView(), rightStack])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Constants.height)
    }
}

// MARK: - Setup

private extension BreakHeaderView {
    func setupUI() {
        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            helpView.heightAnchor.constraint(equalToConstant: Constants.actionViewHeight),
            coffeeIconView.heightAnchor.constraint(equalToConstant: Constants.actionViewHeight),
            coffeeIconView.widthAnchor.constraint(equalToConstant: Constants.coffeeViewWidth)
        ])
    }
}

// MARK: - Actions

private extension BreakHeaderView {
    @objc func helpTapped() {
        delegate?.didTapHelp()
    }
}
