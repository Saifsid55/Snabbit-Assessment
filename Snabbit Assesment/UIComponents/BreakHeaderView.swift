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
    
    private let menuButton = UIButton(type: .system)
    
    private let helpView = UIView()
    private let helpImageView = UIImageView()
    private let helpLabel = UILabel()
    
    private let coffeeIconView = UIView()
    private let coffeeImageView = UIImageView()

    weak var delegate: BreakHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 44)
    }
    
    private func setupUI() {
        setupMenuButton()
        setupHelpButton()
        setupCoffeeButton()
        setupStack()
    }
    
    private func setupMenuButton() {
        menuButton.setImage(
            UIImage(
                systemName: "line.3.horizontal",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
            ),
            for: .normal
        )
        menuButton.tintColor = .white
    }
    
    private func setupHelpButton() {
        // Container
        helpView.layer.cornerRadius = 8
        helpView.layer.borderWidth = 1
        helpView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        helpView.clipsToBounds = true

        // Icon
        helpImageView.image = UIImage(systemName: "phone.fill")?.withRenderingMode(.alwaysTemplate)
        helpImageView.tintColor = .white
        helpImageView.contentMode = .scaleAspectFit
        helpImageView.translatesAutoresizingMaskIntoConstraints = false

        // Label
        helpLabel.text = "Help"
        helpLabel.textColor = .white
        helpLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        helpLabel.translatesAutoresizingMaskIntoConstraints = false

        // Inner stack
        let innerStack = UIStackView(arrangedSubviews: [helpImageView, helpLabel])
        innerStack.axis = .horizontal
        innerStack.spacing = 6
        innerStack.alignment = .center
        innerStack.translatesAutoresizingMaskIntoConstraints = false

        helpView.addSubview(innerStack)

        NSLayoutConstraint.activate([
            helpImageView.widthAnchor.constraint(equalToConstant: 16),
            helpImageView.heightAnchor.constraint(equalToConstant: 16),

            innerStack.centerXAnchor.constraint(equalTo: helpView.centerXAnchor),
            innerStack.centerYAnchor.constraint(equalTo: helpView.centerYAnchor),
            innerStack.leadingAnchor.constraint(equalTo: helpView.leadingAnchor, constant: 14),
            innerStack.trailingAnchor.constraint(equalTo: helpView.trailingAnchor, constant: -14),
        ])
        
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(helpTapped))
        helpView.addGestureRecognizer(gesture)
    }
    private func setupCoffeeButton() {
        
        coffeeIconView.layer.cornerRadius = 8
        coffeeIconView.layer.borderWidth = 1
        coffeeIconView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        coffeeIconView.clipsToBounds = true
        
        // Image inside
        let image = UIImage(named: "coffee")?.withRenderingMode(.alwaysTemplate)
        coffeeImageView.image = image
        coffeeImageView.tintColor = .white
        coffeeImageView.contentMode = .scaleAspectFit
        coffeeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        coffeeIconView.addSubview(coffeeImageView)
        
        NSLayoutConstraint.activate([
            coffeeImageView.centerXAnchor.constraint(equalTo: coffeeIconView.centerXAnchor),
            coffeeImageView.centerYAnchor.constraint(equalTo: coffeeIconView.centerYAnchor),
            coffeeImageView.widthAnchor.constraint(equalToConstant: 20),
            coffeeImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupStack() {
        
        let rightStack = UIStackView(arrangedSubviews: [
            helpView,
            coffeeIconView
        ])
        
        rightStack.axis = .horizontal
        rightStack.spacing = 12
        rightStack.alignment = .center
        
        
        // MARK: Main Stack
        
        let stack = UIStackView(arrangedSubviews: [
            menuButton,
            UIView(),
            rightStack
        ])
        
        stack.axis = .horizontal
        stack.alignment = .center
        
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            helpView.heightAnchor.constraint(equalToConstant: 36),
            coffeeIconView.heightAnchor.constraint(equalToConstant: 36),
            coffeeIconView.widthAnchor.constraint(equalToConstant: 48)
        ])
    }
}

extension BreakHeaderView {
    @objc func helpTapped() {
        delegate?.didTapHelp()
    }
}
