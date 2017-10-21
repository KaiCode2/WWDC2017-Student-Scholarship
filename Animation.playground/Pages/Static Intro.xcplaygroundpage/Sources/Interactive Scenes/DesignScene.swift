import UIKit

public final class DesignScene: UIViewController, Scene {
    public var presentableView: UIView { return view }
    public var completionDelegate: SceneCompletionDelegate

    fileprivate let touchDown = Audio(sound: .touch_down)
    fileprivate let touchUp = Audio(sound: .touch_up)

    fileprivate let feedbackGenerator = UISelectionFeedbackGenerator()
    fileprivate let redButton: UIButton
    fileprivate var topLabel: UILabel?

    fileprivate var hasBeenTapped = false

    public init(delegate: SceneCompletionDelegate) {
        self.completionDelegate = delegate
        feedbackGenerator.prepare()
        self.topLabel = nil
        self.redButton = UIButton(type: .system)
        super.init(nibName: nil, bundle: nil)
        self.redButton.addTarget(self,
                                 action: #selector(self.buttonTapped),
                                 for: .touchUpInside)
        self.redButton.addTarget(self,
                                 action: #selector(self.buttonWillTap),
                                 for: .touchDown)
    }


    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func willDisplay() {
        guard let superview = view.superview else { return }
        view.backgroundColor = .white
        topLabel = UILabel(frame: CGRect(x: 0, y: superview.center.y,
                                         width: superview.frame.width, height: 50))
        topLabel?.text = "Good Design communicates intentions,"
        topLabel?.textAlignment = .center
        topLabel?.alpha = 0
        view.addSubview(topLabel!)

        redButton.setImage(#imageLiteral(resourceName: "red_button_normal.png").withRenderingMode(.alwaysOriginal), for: .normal)
        redButton.setImage(#imageLiteral(resourceName: "red_button_selected.png").withRenderingMode(.alwaysOriginal), for: .selected)
        redButton.frame.size = CGSize(width: 75, height: 75)
        redButton.alpha = 0
        redButton.center = superview.center
        redButton.frame.origin.y -= 175
        view.addSubview(redButton)

        UIViewPropertyAnimator(duration: 0.5,
                               dampingRatio: 0.4) {
                                self.topLabel?.frame.origin.y -= 25
                                self.topLabel?.alpha = 1

                                self.redButton.frame.origin.y = superview.center.y - 150
                                self.redButton.alpha = 1
            }.startAnimation(afterDelay: 0.5)
        delay(1) { 
            self.pulse()
        }
    }

    private func pulse() {
        guard hasBeenTapped == false,
        let superview = view.superview else { return }

        let expandAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                    dampingRatio: 0.3,
                                                    animations: {
                                                        guard self.hasBeenTapped == false else { return }
                                                        self.redButton.frame = CGRect(origin: CGPoint(x: superview.center.x - 40,
                                                                                                      y: self.redButton.frame.origin.y),
                                                                                      size: CGSize(width: 80,
                                                                                                   height: 80))
        })
        let shrinkAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                    dampingRatio: 0.3) { 
                                                        guard self.hasBeenTapped == false else { return }
                                                        self.redButton.frame = CGRect(origin: CGPoint(x: superview.center.x - 37.5,
                                                                                                      y: self.redButton.frame.origin.y),
                                                                                      size: CGSize(width: 75,
                                                                                                   height: 75))
        }
        expandAnimator.addCompletion({ (_) in
            shrinkAnimator.startAnimation()
        })
        expandAnimator.startAnimation(afterDelay: 2)

        delay(5) {
            self.pulse()
        }

    }

    @objc private func buttonTapped() {
        guard let superview = view.superview else { return }
        touchUp.play()
        hasBeenTapped = true
        redButton.isUserInteractionEnabled = false
        feedbackGenerator.selectionChanged()

        let outroLabel = UILabel(frame: CGRect(x: 0, y: superview.center.y,
                                               width: superview.frame.width, height: 50))
        outroLabel.text = "delightfully."
        outroLabel.textAlignment = .center
        outroLabel.alpha = 0
        view.addSubview(outroLabel)
        let animator = UIViewPropertyAnimator(duration: 0.5,
                               dampingRatio: 0.4) {
                                outroLabel.frame.origin.y -= 25
                                outroLabel.alpha = 1

                                self.redButton.frame = CGRect(origin: CGPoint(x: self.redButton.frame.origin.x + (self.redButton.frame.width/2),
                                                                              y: self.redButton.frame.origin.y + (self.redButton.frame.height/2)),
                                                              size: .zero)
                                self.redButton.alpha = 0

                                self.topLabel?.frame.origin.y -= 25
        }
        animator.addCompletion { position in
            guard position == .end else { return }
            delay(2.5, block: { 
                self.view.subviews.forEach({ $0.removeFromSuperview() })
                self.completionDelegate.complete()
            })
        }
        animator.startAnimation()
    }

    @objc private func buttonWillTap() {
        touchDown.play()
    }
}


