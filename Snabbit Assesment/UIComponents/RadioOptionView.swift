
import UIKit

final class RadioOptionView: UIView {
    
    private let outerCircle = UIView()
    private let innerCircle = UIView()
    private let label = UILabel()
    
    var onTap: (() -> Void)?
    
    init(title: String) {
        super.init(frame: .zero)
        setupUI(title: title)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI(title: String) {
        
        outerCircle.layer.cornerRadius = 12
        outerCircle.layer.borderWidth = 2
        outerCircle.layer.borderColor = UIColor.lightGray.cgColor
        
        outerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            outerCircle.widthAnchor.constraint(equalToConstant: 24),
            outerCircle.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        innerCircle.backgroundColor = .systemPurple
        innerCircle.layer.cornerRadius = 6
        innerCircle.isHidden = true
        
        outerCircle.addSubview(innerCircle)
        
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            innerCircle.centerXAnchor.constraint(equalTo: outerCircle.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 12),
            innerCircle.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        label.text = title
        label.font = .systemFont(ofSize: 16)
        
        let stack = UIStackView(arrangedSubviews: [outerCircle, label])
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap() {
        onTap?()
    }
    
    func setSelected(_ selected: Bool) {
        innerCircle.isHidden = !selected
        outerCircle.layer.borderColor = selected ? UIColor.systemPurple.cgColor : UIColor.lightGray.cgColor
    }
}
