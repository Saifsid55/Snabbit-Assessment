
//
//  RadioOptionView.swift
//

import UIKit

final class RadioOptionView: UIView {

    // MARK: Public

    var onTap: (() -> Void)?

    // MARK: Private

    private let outerRing: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 11
        view.layer.borderWidth  = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let innerDot: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // MARK: Init

    init() {
        super.init(frame: .zero)
        setupView()
        setSelected(false)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: Public API

    func setSelected(_ selected: Bool) {
        if selected {
            outerRing.layer.borderColor = AppColors.radioSelected.cgColor
            innerDot.backgroundColor    = AppColors.radioSelected
            innerDot.isHidden = false
        } else {
            outerRing.layer.borderColor = AppColors.radioUnselected.cgColor
            innerDot.isHidden = true
        }
    }
}

// MARK: - Layout

private extension RadioOptionView {

    func setupView() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        addSubview(outerRing)
        outerRing.addSubview(innerDot)

        NSLayoutConstraint.activate([
            outerRing.widthAnchor.constraint(equalToConstant: 22),
            outerRing.heightAnchor.constraint(equalToConstant: 22),
            outerRing.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerRing.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerRing.topAnchor.constraint(equalTo: topAnchor),
            outerRing.bottomAnchor.constraint(equalTo: bottomAnchor),

            innerDot.widthAnchor.constraint(equalToConstant: 12),
            innerDot.heightAnchor.constraint(equalToConstant: 12),
            innerDot.centerXAnchor.constraint(equalTo: outerRing.centerXAnchor),
            innerDot.centerYAnchor.constraint(equalTo: outerRing.centerYAnchor)
        ])
    }
}

@objc private extension RadioOptionView {
    func handleTap() { onTap?() }
}
