import UIKit

open class AnimationView: UIView, SceneCompletionDelegate {
    public var scenes: [Scene] = []

    public init(size: CGSize = CGSize(width: 250, height: 100)) {
        super.init(frame: CGRect(origin: .zero, size: size))
        backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public func animate() {
        guard let scene = scenes.first else { return }
        addSubview(scene.presentableView)
        scene.willDisplay()
    }

    public func complete() {
        scenes.removeFirst()
        animate()
    }
}
