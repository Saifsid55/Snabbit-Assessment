
import UIKit
 
final class CheckboxView: UIView {
 
    // MARK: Public
 
    var onToggle: (() -> Void)?
 
    // MARK: Private
 
    private var isChecked = false
 
    private let box: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderWidth  = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
 
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: "checkmark",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
 
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    // MARK: Init
 
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
        updateAppearance()
    }
 
    required init?(coder: NSCoder) { fatalError() }
}
 
// MARK: - Layout
 
private extension CheckboxView {
 
    func setupView() {
 
        // Tap gesture on the whole row
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        addGestureRecognizer(tap)
 
        // Box
        addSubview(box)
        box.addSubview(checkmarkImageView)
 
        NSLayoutConstraint.activate([
            box.widthAnchor.constraint(equalToConstant: 22),
            box.heightAnchor.constraint(equalToConstant: 22),
            box.leadingAnchor.constraint(equalTo: leadingAnchor),
            box.centerYAnchor.constraint(equalTo: centerYAnchor),
 
            checkmarkImageView.centerXAnchor.constraint(equalTo: box.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: box.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 13),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 13)
        ])
 
        // Label
        addSubview(titleLabel)
 
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: box.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }
 
    func updateAppearance() {
        if isChecked {
            box.backgroundColor  = AppColors.checkboxChecked
            box.layer.borderColor = AppColors.checkboxChecked.cgColor
            checkmarkImageView.isHidden = false
        } else {
            box.backgroundColor  = .clear
            box.layer.borderColor = AppColors.checkboxUnchecked.cgColor
            checkmarkImageView.isHidden = true
        }
    }
}
 
// MARK: - Actions
 
@objc private extension CheckboxView {
 
    func handleTap() {
        isChecked.toggle()
        updateAppearance()
        onToggle?()
    }
}
