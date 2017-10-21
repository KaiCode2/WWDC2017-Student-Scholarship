import UIKit

public final class ProcessScene: UIViewController, Scene {
    public var completionDelegate: SceneCompletionDelegate
    public var presentableView: UIView { return view }

    public init(delegate: SceneCompletionDelegate) {
        self.completionDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    fileprivate var topLabel: UILabel? {
        guard let superview = view.superview else { return nil }
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 30,
                                          width: superview.frame.width,
                                          height: 100))
        label.textAlignment = .center
        label.textColor = .white
        label.text = "I Turn Coffee..."
        return label
    }

    fileprivate var workingImage = UIImageView(image: #imageLiteral(resourceName: "Kai_working.png"))
    fileprivate var coffeeCup = UIImageView(image: #imageLiteral(resourceName: "Coffee.png"))
    fileprivate var iPhone = UIImageView(image: #imageLiteral(resourceName: "iPhone.png"))


    fileprivate let animator = UIViewPropertyAnimator(duration: 0.1,
                                                      dampingRatio: 0.45,
                                                      animations: nil)

    fileprivate lazy var dragIndicator = UIImageView(image: #imageLiteral(resourceName: "drag_indicator.png"))
    fileprivate var touchHasOccured = false

    public func willDisplay() {
        guard let superview = view.superview else { return }
        view.backgroundColor = .darkBlue

        workingImage.frame.size = CGSize(width: 100, height: 100)
        workingImage.center = superview.center
        workingImage.contentMode = .scaleAspectFit
        workingImage.alpha = 0
        view.addSubview(workingImage)

        coffeeCup.frame = CGRect(x: 50,
                                 y: (superview.frame.height / 2) - 20,
                                 width: 35,
                                 height: 70)
        coffeeCup.contentMode = .scaleAspectFit
        coffeeCup.alpha = 0
        view.addSubview(coffeeCup)
        view.sendSubview(toBack: coffeeCup)

        topLabel?.alpha = 0
        view.addSubview(topLabel!)

        iPhone.frame.size = CGSize(width: 30, height: 60)
        iPhone.center = superview.center
        iPhone.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        iPhone.alpha = 0
        view.addSubview(iPhone)
        view.sendSubview(toBack: iPhone)


        let topLeftFinalLabel = UILabel(frame: .zero)
        topLeftFinalLabel.text = "into "
        topLeftFinalLabel.textColor = .white
        topLeftFinalLabel.textAlignment = .right
        topLeftFinalLabel.center = superview.center
        topLeftFinalLabel.frame.origin = CGPoint(x: (superview.frame.width/2) - 125,
                                             y: (superview.frame.height/2) + 100)
        topLeftFinalLabel.frame.size = CGSize(width: 100, height: 25)
        topLeftFinalLabel.alpha = 0
        let topFinalLabel = UILabel(frame: .zero)
        topFinalLabel.text = "Ideas,"
        topFinalLabel.textColor = .white
        topFinalLabel.textAlignment = .right
        topFinalLabel.frame.origin = CGPoint(x: (superview.frame.width/2) - 75,
                                             y: (superview.frame.height/2) + 100)
        topFinalLabel.frame.size = CGSize(width: 100, height: 25)
        topFinalLabel.alpha = 0
        let middleFinalLabel = UILabel(frame: .zero)
        middleFinalLabel.text = "Code,"
        middleFinalLabel.textColor = .white
        middleFinalLabel.textAlignment = .right
        middleFinalLabel.frame.origin = CGPoint(x: (superview.frame.width/2) - 75,
                                                y: (superview.frame.height/2) + 125)
        middleFinalLabel.frame.size = CGSize(width: 100, height: 25)
        middleFinalLabel.alpha = 0
        let bottomFinalLabel = UILabel(frame: .zero)
        bottomFinalLabel.text = "Apps."
        bottomFinalLabel.textColor = .white
        bottomFinalLabel.textAlignment = .right
        bottomFinalLabel.frame.origin = CGPoint(x: (superview.frame.width/2) - 75,
                                                y: (superview.frame.height/2) + 150)
        bottomFinalLabel.frame.size = CGSize(width: 100, height: 25)
        bottomFinalLabel.alpha = 0

        view.addSubview(topLeftFinalLabel)
        view.addSubview(topFinalLabel)
        view.addSubview(middleFinalLabel)
        view.addSubview(bottomFinalLabel)

        animator.addAnimations {
            self.coffeeCup.frame.origin = CGPoint(x: (superview.frame.width/2) - 20,
                                                  y: (superview.frame.height/2) - 20)
            self.coffeeCup.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        }
        animator.addCompletion { position in
            switch position {
            case .end:
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: { 
                                self.iPhone.frame.origin = CGPoint(x: superview.frame.width - 50,
                                                                   y: (superview.frame.height/2) - 20)
                                self.iPhone.transform = CGAffineTransform(rotationAngle: 0)
                }) { _ in
                    [topLeftFinalLabel, topFinalLabel, middleFinalLabel, bottomFinalLabel].delayedMap(block: { (label) -> TimeInterval in
                        UIView.animate(withDuration: 0.1, animations: { 
                            label.alpha = 1
                        })
                        if label == topLeftFinalLabel { return 0 }
                        return 0.5
                    })

                        UIView.animate(withDuration: 1.5,
                                       delay: 2,
                                       options: .curveEaseInOut,
                                       animations: { 
                                        topFinalLabel.center = superview.center
                                        self.view.subviews.forEach({ subview in
                                            guard subview != topFinalLabel else { return }
                                            subview.frame.origin.x -= 500
                                        })
                                        self.view.backgroundColor = .semiDarkGray

                        }, completion: { _ in
                            self.completionDelegate.complete()
                        })

                }
            case .start: break
            case .current: break
            }
        }

        delay(5) { 
            self.interactionHint()
        }

        UIView.animate(withDuration: 0.2) { 
            self.topLabel?.alpha = 1
            self.coffeeCup.alpha = 1
            self.workingImage.alpha = 1
            self.iPhone.alpha = 1
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHasOccured = true
        guard let touch = touches.first else { return }
        if animator.fractionComplete >= 0.9 {
            animator.startAnimation()
        }
        animator.fractionComplete += (touch.location(in: view).x - touch.previousLocation(in: view).x) / 100
    }

    private func interactionHint() {
        guard touchHasOccured == false,
            let superview = view.superview else { return }
        dragIndicator.alpha = 0
        dragIndicator.frame = CGRect(x: 50,
                                     y: superview.center.y + 100,
                                     width: 50,
                                     height: 50)
        view.addSubview(dragIndicator)

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { 
                        self.dragIndicator.alpha = 1
                        self.dragIndicator.center.x = superview.center.x
        }, completion: nil)
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       options: .curveEaseOut,
                       animations: {
                        self.dragIndicator.alpha = 0
                        self.dragIndicator.center.x = superview.frame.width - 50
        }) { _ in
            delay(0.9) {
                self.interactionHint()
            }
        }
    }
}


