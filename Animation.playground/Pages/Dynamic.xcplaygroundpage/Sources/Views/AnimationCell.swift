import UIKit

public final class AnimationCell: UITableViewCell, ReusableViewType {
    private let titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 150, height: 50))
    public func set(animation: Animation) {
        backgroundColor = .clear
        switch animation.transformation {
        case .translate(_): titleLabel.text = "Translate"
        case .rotate(_): titleLabel.text = "Rotate"
        case .scale(_): titleLabel.text = "Scale"
        }
        addSubview(titleLabel)
    }
}

public final class AnimationCellCallout: UIView {
    let delegate: AnimationEditorType
    public init(frame: CGRect, delegate: AnimationEditorType) {
        self.delegate = delegate
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let firstPin = UIImageView(image: #imageLiteral(resourceName: "drag.png"))
    private let secondPin = UIImageView(image: #imageLiteral(resourceName: "drag.png"))
    private var currentPin: UIImageView? = nil

    public var animation: Animation? = nil

    public func layout(animation: Animation) {
        self.animation = animation
        firstPin.frame.size = CGSize(width: 15, height: 15)
        firstPin.frame.origin = CGPoint(x: animation.curve.controlPoint1.x * 100,
                                        y: animation.curve.controlPoint1.y * 100)

        secondPin.frame.size = CGSize(width: 15, height: 15)
        secondPin.frame.origin = CGPoint(x: animation.curve.controlPoint2.x * 100,
                                         y: animation.curve.controlPoint2.y * 100)

        addSubview(firstPin)
        addSubview(secondPin)
        backgroundColor = .semiDarkGray
        alpha = 0.9
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        if abs(location.x - firstPin.center.x) <= 30 &&
            abs(location.y - firstPin.center.y) <= 30 {
            firstPin.center = location
            currentPin = firstPin
        } else if abs(location.x - secondPin.center.x) <= 30 &&
            abs(location.y - secondPin.center.y) <= 30 {
            secondPin.center = location
            currentPin = secondPin
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self),
            let pin = currentPin else {
                return
        }
        pin.center = location
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        update()
    }

    public func update() {
        guard var animation = animation else { return }
        let firstPoint = CGPoint(x: firstPin.frame.origin.x / 100,
                                 y: firstPin.frame.origin.y / 100)
        let secondPoint = CGPoint(x: secondPin.frame.origin.x / 100,
                                  y: secondPin.frame.origin.y / 100)
        animation.curve = UICubicTimingParameters(controlPoint1: firstPoint,
                                                  controlPoint2: secondPoint)
        delegate.update(animation: animation)
    }
}
