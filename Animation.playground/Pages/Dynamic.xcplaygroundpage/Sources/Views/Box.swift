import UIKit


public class Box: UIView, Animateable, TransformDelegate {

    private var initialTapLocation: CGPoint? = nil
    private var lastTapLocation: CGPoint? = nil {
        didSet(newValue) {
            guard newValue != nil else { return }
            delay(1) {
                self.lastTapLocation = nil
            }
        }
    }
    private var isCreating = true {
        didSet(newValue) {
            guard newValue == true else { return }
            delay(1) {
                self.isCreating = false
            }
        }
    }
    private var initialFrame: CGRect = .zero

    public func animate(animations: [Animation]) {
        guard let superview = superview else {
            return
        }
        func setup() {
            UIView.animate(withDuration: 0.1,
                           animations: {
                            superview.alpha = 0
            }) { _ in
                self.frame = self.initialFrame
                self.transform = CGAffineTransform.identity
                UIView.animate(withDuration: 0.1,
                               animations: {
                                superview.alpha = 1
                })
            }
        }
        setup()
        delay(0.5) {
            animations.delayedMap(block: { animation -> TimeInterval in
            if case .translate(let path) = animation.transformation {
            let timeApproximation = (path.boundingBox.width + path.boundingBox.height) / 100
            let translateAnimation = CAKeyframeAnimation(keyPath: "position")
            translateAnimation.path = path
            translateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: Float(animation.curve.controlPoint1.x),
            Float(animation.curve.controlPoint1.y),
            Float(animation.curve.controlPoint2.x), Float(animation.curve.controlPoint2.y))
            translateAnimation.duration = CFTimeInterval(timeApproximation)
            self.layer.add(translateAnimation, forKey: nil)
            return TimeInterval(timeApproximation)
            } else {
                let propertyAnimator = UIViewPropertyAnimator(duration: 0.2,
                                                              timingParameters: animation.curve)
                propertyAnimator.addAnimations {
                    switch animation.transformation {
                    case .translate(_): break
                    case .scale(let factor):
                        self.frame.size.height = self.initialFrame.height * factor
                        self.frame.size.width = self.initialFrame.width * factor
                        self.center = self.center
                    case .rotate(let angle):
                        self.transform = CGAffineTransform(rotationAngle: angle)
                    }
                    self.backgroundColor = animation.color
                }
                propertyAnimator.startAnimation()
                return 0.2
                }
            }) {
                setup()
            }
        }
    }

    public func translate(to point: CGPoint) {
        if isCreating {
            guard let firstTapLocation = initialTapLocation else {
                initialTapLocation = point
                return
            }
            let x = min(firstTapLocation.x, point.x)
            let y = min(firstTapLocation.y, point.y)
            let width = max(firstTapLocation.x, point.x) - x
            let heigth = max(firstTapLocation.y, point.y) - y
            frame = CGRect(x: x, y: y, width: width, height: heigth)
            initialFrame = frame
            backgroundColor = .blue
            
            isCreating = true
        } else {
            guard let lastPoint = lastTapLocation else {
                lastTapLocation = point
                return
            }
            frame.origin.x -= lastPoint.x - point.x
            frame.origin.y -= lastPoint.y - point.y
            lastTapLocation = point
        }
    }

    public func scale(by factor: CGFloat) {
        frame.size.height = initialFrame.height * factor
        frame.size.width = initialFrame.width * factor
    }

    public func rotate(by angle: CGFloat) {
        transform = CGAffineTransform(rotationAngle: angle)
    }
}

