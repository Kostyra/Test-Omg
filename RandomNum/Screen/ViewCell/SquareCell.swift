import UIKit

final class SquareCell: UICollectionViewCell {
    static let id = "SquareCellIdentifier"
    private var isZoomed = false
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.delegate = self
        self.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(numberLabel)
        numberLabel.frame = contentView.bounds
    }
    
    func config(number: Int) {
        numberLabel.text = number.description
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            if !isZoomed {
                UIView.animate(withDuration: 0.2) { self.transform = self.transform.scaledBy(x: 0.8, y: 0.8) }
                isZoomed = true
            }
        case .ended, .cancelled:
            if isZoomed {
                UIView.animate(withDuration: 0.2) { self.transform = .identity }
                isZoomed = false
            }
        default:
            break
        }
    }
}

extension SquareCell: UIGestureRecognizerDelegate {
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { return true }
}
