//
//  EndBreakBottomSheetViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import UIKit

protocol EndBreakBottomSheetDelegate: AnyObject {
    func endBreakBottomSheetDidTapEndNow(_ sheet: EndBreakBottomSheetViewController)
}

final class EndBreakBottomSheetViewController: UIViewController {
    private enum Constants {
        static let containerHeight: CGFloat = 260
        static let containerRadius: CGFloat = 20
        static let handleWidth: CGFloat = 40
        static let handleHeight: CGFloat = 5
        static let handleRadius: CGFloat = 2.5
        static let handleTopInset: CGFloat = 8
        static let stackSpacing: CGFloat = 20
        static let buttonStackSpacing: CGFloat = 12
        static let buttonHeight: CGFloat = 44
        static let buttonRadius: CGFloat = 10
        static let stackInset: CGFloat = 24
        static let stackHorizontalInset: CGFloat = 20
        static let titleFontSize: CGFloat = 20
        static let slideOffset: CGFloat = 300
        static let appearDuration: CGFloat = 0.35
        static let dismissDuration: CGFloat = 0.25
        static let overlayAlpha: CGFloat = 0.3
        static let titleText = "Ending break early?"
        static let messageText = "Are you sure you want to end your break now? Take this time to recharge before your next task."
        static let continueTitle = "Continue"
        static let endNowTitle = "End now"
        static let endNowBorderWidth: CGFloat = 1
    }
    
    weak var delegate: EndBreakBottomSheetDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.containerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var handle: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.layer.cornerRadius = Constants.handleRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.messageText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.continueTitle, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = Constants.buttonRadius
        button.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var endNowButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.endNowTitle, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = Constants.endNowBorderWidth
        button.layer.cornerRadius = Constants.buttonRadius
        button.addTarget(self, action: #selector(endNowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [continueButton, endNowButton])
        stack.axis = .horizontal
        stack.spacing = Constants.buttonStackSpacing
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, messageLabel, buttonStack])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.transform = CGAffineTransform(translationX: 0, y: Constants.slideOffset)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: Constants.appearDuration) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(Constants.overlayAlpha)
            self.containerView.transform = .identity
        }
    }
}

private extension EndBreakBottomSheetViewController {
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSheet)))
        view.addSubview(containerView)
        containerView.addSubview(handle)
        containerView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Constants.containerHeight),
            handle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.handleTopInset),
            handle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: Constants.handleWidth),
            handle.heightAnchor.constraint(equalToConstant: Constants.handleHeight),
            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.stackInset),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.stackHorizontalInset),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.stackHorizontalInset),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.stackInset),
            continueButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            endNowButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    @objc func dismissSheet() {
        UIView.animate(withDuration: Constants.dismissDuration, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.containerView.transform = CGAffineTransform(translationX: 0, y: Constants.slideOffset)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc func endNowTapped() {
        dismiss(animated: true)
        delegate?.endBreakBottomSheetDidTapEndNow(self)
    }
}
