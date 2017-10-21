import UIKit

public class DynamicAnimationView: AnimationView {
    fileprivate var transformDelegate: TransformDelegate? = nil

    public func set(delegate: TransformDelegate) {
        transformDelegate = delegate
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touchLocation = touches.first?.location(in: self) else { return }
        transformDelegate?.translate(to: touchLocation)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touchLocation = touches.first?.location(in: self) else { return }
        transformDelegate?.translate(to: touchLocation)
    }
}

