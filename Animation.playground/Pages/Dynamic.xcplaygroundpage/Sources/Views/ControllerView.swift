import UIKit

public class ControllerView: UIView {
    fileprivate let animateButton: UIButton
    fileprivate let rotationSlider: UISlider
    fileprivate let sizeSlider: UISlider
    fileprivate let expandButton: UIButton

    fileprivate var animationsEditor: AnimationsEditorView? = nil
    fileprivate var isExpanded = false

    fileprivate var blurView: UIVisualEffectView {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = frame.size
        return blurView
    }

    fileprivate let delegate: TransformDelegate & AnimationControllerType & AnimationEditorType

    public init(frame: CGRect, delegate: TransformDelegate & AnimationControllerType & AnimationEditorType) {
        self.delegate = delegate

        self.animateButton = UIButton(type: .system)
        self.expandButton = UIButton(type: .system)
        self.rotationSlider = UISlider()
        self.sizeSlider = UISlider()
        super.init(frame: frame)
        
        addSubview(blurView)

        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 0,
                                           left: 10,
                                           bottom: 0,
                                           right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.frame = CGRect(x: 0,
                             y: 0,
                             width: frame.size.width,
                             height: frame.size.height).insetBy(dx: 10, dy: 0)

        let sliderStack = UIStackView()
        sliderStack.alignment = .fill
        sliderStack.axis = .vertical
        sliderStack.distribution = .fill
        sliderStack.spacing = 25
        sliderStack.layoutMargins = UIEdgeInsets(top: 10,
                                                 left: 10,
                                                 bottom: 10,
                                                 right: 10)
        sliderStack.isLayoutMarginsRelativeArrangement = true
        sliderStack.frame = CGRect(x: 0,
                                   y: 50,
                                   width: stack.frame.size.width / 2,
                                   height: stack.frame.size.height - 10)

        sizeSlider.frame.size = CGSize(width: 100, height: 100)
        rotationSlider.frame.size = CGSize(width: 100, height: 100)

        sizeSlider.minimumValue = 0
        sizeSlider.maximumValue = 2
        sizeSlider.setValue(1, animated: false)
        sliderStack.addArrangedSubview(rotationSlider)
        sliderStack.addArrangedSubview(sizeSlider)
        stack.addArrangedSubview(animateButton)
        stack.addArrangedSubview(sliderStack)

        animateButton.setTitle("Animate", for: .normal)
        animateButton.setTitleColor(.black, for: .normal)
        animateButton.backgroundColor = .clear
        animateButton.addTarget(self,
                                action: #selector(self.buttonWasTapped),
                                for: .touchUpInside)

        rotationSlider.addTarget(self,
                                 action: #selector(self.handleRotation),
                                 for: .touchDragInside)

        sizeSlider.addTarget(self,
                             action: #selector(self.handleResize),
                             for: .touchDragInside)
        addSubview(stack)


        expandButton.setImage(#imageLiteral(resourceName: "expand.png").withRenderingMode(.alwaysOriginal),
                              for: .normal)
        expandButton.frame = CGRect(x: 32,
                                    y: 10,
                                    width: 32,
                                    height: 20)
        expandButton.addTarget(self,
                               action: #selector(self.expand),
                               for: .touchUpInside)
        expandButton.alpha = 0.75
        addSubview(expandButton)

        delegate.setAnimation(updateHandler: { _ in
            guard let animation = self.animationsEditor else { return }
            animation.layout()
        })
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc private func handleRotation() {
        delegate.rotate(by: CGFloat(rotationSlider.value) * CGFloat.pi)
    }

    @objc private func handleResize() {
        delegate.scale(by: CGFloat(sizeSlider.value))
    }

    @objc private func buttonWasTapped() {
        sizeSlider.setValue(1, animated: false)
        rotationSlider.setValue(0, animated: false)
        delegate.animate()
        if isExpanded { expand() }
    }

    @objc private func expand() {
        guard let superview = superview else { return }
        if isExpanded {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.expandButton.transform = CGAffineTransform(rotationAngle: self.isExpanded ? 0 : CGFloat.pi)
                            self.animationsEditor?.alpha = 0
            }, completion: { _ in
                self.animationsEditor?.willRemove()
                self.animationsEditor?.removeFromSuperview()
            })
        } else {
            animationsEditor = AnimationsEditorView(delegate: delegate)
            animationsEditor?.alpha = 0
            superview.addSubview(animationsEditor!)
            animationsEditor?.layout()
            UIView.animate(withDuration: 0.2) {
                self.expandButton.transform = CGAffineTransform(rotationAngle: self.isExpanded ? 0 : CGFloat.pi)
                self.animationsEditor?.alpha = 1
            }
        }
        isExpanded = !isExpanded
    }
}
