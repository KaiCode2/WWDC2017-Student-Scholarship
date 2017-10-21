import UIKit

public protocol TransformDelegate {
    func translate(to point: CGPoint)
    func scale(by factor: CGFloat)
    func rotate(by angle: CGFloat)
}

public protocol AnimationControllerType {
    func animate()
}

public protocol AnimationEditorType {
    func getAnimations() -> [Animation]
    func setAnimation(updateHandler handler: @escaping ([Animation]) -> Void)
    func update(animation: Animation)
    func delete(atIndex index: Int)
}

public protocol Animateable {
    func animate(animations: [Animation])
}

public final class Interactor: TransformDelegate, AnimationControllerType, AnimationEditorType {
    var animations: [Animation] {
        didSet(newValue) {
            handler?(newValue)
        }
    }
    private var handler: (([Animation]) -> Void)? = nil
    public func getAnimations() -> [Animation] { return self.animations }
    public func setAnimation(updateHandler handler: @escaping ([Animation]) -> Void) {
        self.handler = handler
    }
    var view: TransformDelegate & Animateable

    private var scaleDirection: Bool? = nil
    private var rotateDirection: Bool? = nil

    public init(view: TransformDelegate & Animateable) {
        self.view = view
        self.animations = []
    }


    public func translate(to point: CGPoint) {
        guard let last = animations.last else {
            let path = CGMutablePath()
            path.move(to: point)
            appendAnimation(transformation: .translate(path))
            return
        }
        switch last.transformation {
        case .translate(let path):
            let newPath = path
            newPath.addLine(to: point)
            guard let index = animations.index(of: last) else { return }
            animations[index].transformation = .translate(newPath)
        default:
            let path = CGMutablePath()
            path.move(to: point)
            appendAnimation(transformation: .translate(path))
        }
        view.translate(to: point)
    }

    public func scale(by factor: CGFloat) {
        guard let last = animations.last else {
            appendAnimation(transformation: .scale(factor))
            return
        }
        switch last.transformation {
        case .scale(let lastFactor):
            guard let direction = scaleDirection else {
                scaleDirection = factor >= lastFactor
                return
            }
            if (factor >= lastFactor) == direction {
                guard let index = animations.index(of: last) else { return }
                animations[index].transformation = .scale(factor)
            } else {
                appendAnimation(transformation: .scale(factor))
            }
            scaleDirection = factor >= lastFactor
        default: appendAnimation(transformation: .scale(factor))
        }
        view.scale(by: factor)
    }

    public func rotate(by angle: CGFloat) {
        guard let last = animations.last else {
            appendAnimation(transformation: .rotate(angle))
            return
        }
        switch last.transformation {
        case .rotate(let lastAngle):
            guard let direction = rotateDirection else {
                rotateDirection = angle >= lastAngle
                return
            }
            if (angle >= lastAngle) == direction {
                guard let index = animations.index(of: last) else { return }
                animations[index].transformation = .rotate(angle)
            } else {
                appendAnimation(transformation: .rotate(angle))
            }
            rotateDirection = angle >= lastAngle
        default: appendAnimation(transformation: .rotate(angle))
        }
        view.rotate(by: angle)
    }

    public func animate() {
        animations.remove(at: 0)
        view.animate(animations: animations)
        animations = []
    }


    public func update(animation: Animation) {
        guard let index = animations.index(of: animation) else { return }
        animations[index] = animation
    }

    public func delete(atIndex index: Int) {
        animations.remove(at: index)
    }

    private func appendAnimation(transformation: Animation.Transormation) {
        let animation = Animation(transformation: transformation,
                                  curve: UICubicTimingParameters(controlPoint1: CGPoint(x: 1, y: 1),
                                                                 controlPoint2: CGPoint(x: 0, y: 0)),
                                  color: .random)
        animations.append(animation)
    }
}
