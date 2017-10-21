import UIKit

public protocol Scene {
    var presentableView: UIView { get }
    func willDisplay()
    var completionDelegate: SceneCompletionDelegate { get set }
}

public protocol SceneCompletionDelegate {
    func complete()
}

public final class AnimationScene: UIViewController, Scene {
    public var completionDelegate: SceneCompletionDelegate
    public var presentableView: UIView { return view }

    public var animationDelay: TimeInterval = 0
    public var setup: (() -> Void)? {
        didSet {
            guard let setup = setup else { return }
            setup()
        }
    }
    public var tearDown: (() -> Void)?
    public var animations: [() -> TimeInterval] = []


    public init(delegate: SceneCompletionDelegate) {
        self.completionDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func willDisplay() {
        setup?()
        delay(animationDelay) { 
            self.animate()
        }
    }

    private func animate() {
        delay(animationDelay) {
            self.animations.append({
                self.tearDown?()
                self.completionDelegate.complete()
                return 0
            })
            self.animations.delayedMap(block: { return $0() })
        }
    }
}
