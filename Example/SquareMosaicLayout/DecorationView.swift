import UIKit

final class DecorationView: UIView {
    
    private lazy var view = UIView()
    
    required init() {
        super.init(frame: .zero)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = Array<NSLayoutConstraint>()
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[V]|",
                options: [],
                metrics: nil,
                views: ["V": view]
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[V]|",
                options: [],
                metrics: nil,
                views: ["V": view]
            )
        )
        constraints.activate()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.cornerRadius = offset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
