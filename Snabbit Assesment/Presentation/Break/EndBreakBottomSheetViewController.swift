//
//  EndBreakBottomSheetViewController.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import UIKit

final class EndBreakBottomSheetViewController: UIViewController {
    
    var onEndNow: (() -> Void)?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    private let continueButton = UIButton()
    private let endNowButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupContainer()
        setupContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        containerView.transform = CGAffineTransform(translationX: 0, y: 300)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSheet()
    }
    
    
    private func animateSheet() {
        
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.containerView.transform = .identity
        }
    }
    
    private func setupBackground() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissSheet)
        )
        
        view.addGestureRecognizer(tap)
    }
    
    private func setupContainer() {
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        containerView.clipsToBounds = true
        
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 260)
        ])
        
        // Drag handle
        let handle = UIView()
        handle.backgroundColor = .systemGray3
        handle.layer.cornerRadius = 2.5
        
        containerView.addSubview(handle)
        
        handle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            handle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            handle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: 40),
            handle.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    private func setupContent() {
        
        titleLabel.text = "Ending break early?"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        
        messageLabel.text =
        "Are you sure you want to end your break now? Take this time to recharge before your next task."
        
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = .darkGray
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = UIColor.systemGreen
        continueButton.layer.cornerRadius = 10
        
        endNowButton.setTitle("End now", for: .normal)
        endNowButton.setTitleColor(.systemRed, for: .normal)
        endNowButton.layer.borderColor = UIColor.systemRed.cgColor
        endNowButton.layer.borderWidth = 1
        endNowButton.layer.cornerRadius = 10
        
        continueButton.addTarget(
            self,
            action: #selector(dismissSheet),
            for: .touchUpInside
        )
        
        endNowButton.addTarget(
            self,
            action: #selector(endNowTapped),
            for: .touchUpInside
        )
        
        let buttonStack = UIStackView(arrangedSubviews: [
            continueButton,
            endNowButton
        ])
        
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            messageLabel,
            buttonStack
        ])
        
        stack.axis = .vertical
        stack.spacing = 20
        
        containerView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            continueButton.heightAnchor.constraint(equalToConstant: 44),
            endNowButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    private func dismissSheet() {
        UIView.animate(withDuration: 0.25, animations: {
            
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 300)
            
        }) { _ in
            
            self.dismiss(animated: false)
        }
    }
    
    @objc
    private func endNowTapped() {
        
        dismiss(animated: true)
        
        onEndNow?()
    }
}
