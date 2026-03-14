
import UIKit

final class CheckboxView: UIView {
    
    private let checkbox = UIView()
    private let label = UILabel()
    
    private var isChecked = false
    
    var onToggle: (() -> Void)?
    
    init(title: String) {
        super.init(frame: .zero)
        
        setupUI(title: title)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI(title: String) {
        
        checkbox.layer.cornerRadius = 6
        checkbox.layer.borderWidth = 2
        checkbox.layer.borderColor = UIColor.lightGray.cgColor
        
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        label.text = title
        label.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [checkbox, label])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggle))
        addGestureRecognizer(tap)
    }
    
    @objc
    private func toggle() {
        
        isChecked.toggle()
        updateUI()
        
        onToggle?()
    }
    
    private func updateUI() {
        
        checkbox.backgroundColor = isChecked ? .systemPurple : .clear
    }
}
