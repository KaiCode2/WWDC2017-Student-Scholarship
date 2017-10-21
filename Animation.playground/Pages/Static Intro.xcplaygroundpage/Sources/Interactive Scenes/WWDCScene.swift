import UIKit
import SpriteKit
import GameKit

public final class WWDCScene: UIViewController, Scene {
    public var completionDelegate: SceneCompletionDelegate
    public var presentableView: UIView { return view }

    fileprivate lazy var dragIndicator: UIImageView? = UIImageView(image: #imageLiteral(resourceName: "drag_indicator.png"))
    private var touchHasOccured = false

    public init(delegate: SceneCompletionDelegate) {
        self.completionDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func willDisplay() {
        guard let superview = view.superview else { return }
        let spriteView = SKView(frame: superview.frame)

        let scene = WWDC(size: superview.frame.size)
        spriteView.presentScene(scene)

        view.addSubview(spriteView)

        delay(10) {
            self.interactionHint()
        }
    }

    func interactionHint() {
        guard touchHasOccured == false,
            let superview = view.superview else { return }

        dragIndicator?.frame = CGRect(x: 50,
                                     y: (superview.frame.height/2) - 100,
                                     width: 75,
                                     height: 75)
        view.addSubview(dragIndicator!)

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.dragIndicator?.alpha = 1
                        self.dragIndicator?.center.x = superview.center.x
        }, completion: nil)
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       options: .curveEaseOut,
                       animations: {
                        self.dragIndicator?.alpha = 0
                        self.dragIndicator?.center.x = superview.frame.width - 50
        }) { _ in
            delay(0.9) {
                self.interactionHint()
            }
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard touchHasOccured == true else {
            touchHasOccured = true
            dragIndicator?.removeFromSuperview()
            dragIndicator = nil
            return
        }
    }
    
}

fileprivate final class WWDC: SKScene {
    var textures = [SKTexture]()
    let logoNodeName = "wwdcLogo"
    let personNodeName = "person"


    override public func didMove(to view: SKView) {
        super.didMove(to: view)
        setUpScene()
    }

    func setUpScene() {
        guard let view = view else { return }
        backgroundColor = UIColor(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        scaleMode = .resizeFill
        physicsWorld.gravity = CGVector.zero
        view.isMultipleTouchEnabled = true


        let wwdclogo = SKSpriteNode(imageNamed: "Logo")
        wwdclogo.name = logoNodeName
        wwdclogo.setScale(0.375)
        wwdclogo.position = CGPoint(x: frame.midX, y: frame.midY)
        wwdclogo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wwdclogo.size.width * 1.25, height: wwdclogo.size.height * 2.5))
        wwdclogo.physicsBody?.isDynamic = false
        addChild(wwdclogo)

        let blur = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.frame
        view.addSubview(blurView)

        let imageView = UIImageView(frame: .zero)
        imageView.center = view.center
        imageView.image = #imageLiteral(resourceName: "Kai_Face_WIP.png")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        let topLabel = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 50))
        topLabel.text = "So here's to the crazy ones,"
        topLabel.textAlignment = .center
        view.addSubview(topLabel)

        let bottomLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height - 100,
                                                width: view.frame.width, height: 50))
        bottomLabel.text = "I hope to join you at"
        bottomLabel.textAlignment = .center
        view.addSubview(bottomLabel)

        let expandAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                    dampingRatio: 0.45) {
                                                        imageView.frame.size = CGSize(width: 100, height: 100)
                                                        imageView.center = view.center
        }
        let imageSwapAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                       dampingRatio: 0.45) {
                                                        imageView.frame.size = .zero
                                                        imageView.center = view.center
        }
        let reExpandAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                      dampingRatio: 0.45) {
                                                        imageView.frame.size = CGSize(width: 100, height: 100)
                                                        imageView.center = view.center
        }
        let placementAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                       dampingRatio: 0.45) { 
                                                        imageView.frame = CGRect(x: view.center.x - 25,
                                                                                 y: view.center.y - 100,
                                                                                 width: 50,
                                                                                 height: 50)
                                                        blurView.alpha = 0
                                                        topLabel.alpha = 0
                                                        bottomLabel.alpha = 0
        }
        expandAnimator.addCompletion { postition in
            guard postition == .end else { return }
            delay(1, block: {
                imageSwapAnimator.startAnimation()
            })
        }
        imageSwapAnimator.addCompletion { position in
            guard position == .end else { return }
            imageView.image = #imageLiteral(resourceName: "Persons/Person14.png")
            reExpandAnimator.startAnimation()
        }
        reExpandAnimator.addCompletion { position in
            guard position == .end else { return }
            delay(1, block: { 
                placementAnimator.startAnimation()
            })
        }
        placementAnimator.addCompletion { position in
            guard position == .end else { return }
            imageView.removeFromSuperview()
            blurView.removeFromSuperview()
            
            let person = SKSpriteNode(texture: self.textures[14])
            person.position = CGPoint(x: view.center.x, y: view.center.y + 100)
            person.size = CGSize(width: 50, height: 50)
            let moveAction = SKAction.move(by: CGVector(dx: 0,
                                                        dy: 450),
                                           duration: 5)
            person.run(moveAction)
            self.addChild(person)
        }

        delay(2) {
            expandAnimator.startAnimation()
        }


        delay(5) {
            self.generateIndefinetly()
        }

        for i in 0...250 {
            textures.append(SKTexture(imageNamed: "Persons/Person\(i).png"))
        }
    }

    override public func didSimulatePhysics() {
        enumerateChildNodes(withName: personNodeName) { (node, stop) in
            if node.position.y < -50 || node.position.y > self.frame.size.height + 50 || node.position.x < -50 || node.position.x > self.frame.size.width + 50 {
                node.removeFromParent()
            }
        }
    }

    func generateIndefinetly() {
        let randomPoint = arc4random() % 5
        switch randomPoint {
        case 0: createRandomNode(at: CGPoint(x: 0, y: 0))
        case 1: createRandomNode(at: CGPoint(x: frame.width, y: 0))
        case 2: createRandomNode(at: CGPoint(x: 0, y: frame.height))
        case 3: createRandomNode(at: CGPoint(x: frame.width, y: frame.height))
        default: createRandomNode(at: CGPoint(x: frame.midX, y: frame.midY))
        }
        delay(0.1, block: {
            self.generateIndefinetly()
        })
    }

    func createRandomNode(at point: CGPoint) {
        let texture = textures[GKRandomSource.sharedRandom().nextInt(upperBound: textures.count)]

        let person = SKSpriteNode(texture: texture)
        person.name = personNodeName
        person.setScale(0.4)
        person.position = CGPoint(x: point.x, y: point.y)

        let radius = max(person.frame.size.width/2,
                         person.frame.size.height/2)
        let distanceBetweenNodes: CGFloat = 1.2
        person.physicsBody = SKPhysicsBody(circleOfRadius: radius*distanceBetweenNodes)


        let moveAction = SKAction.move(by: CGVector(dx: CGFloat(Int(arc4random() % 1000) - 500),
                                                    dy: CGFloat(Int(arc4random() % 1000) - 500)),
                                       duration: 5)
        person.run(moveAction)
        
        addChild(person)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handle(touches: touches)
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handle(touches: touches)
    }

    private func handle(touches: Set<UITouch>) {
        touches.forEach() { touch in
            let location = touch.location(in: self)
            createRandomNode(at: location)
        }
    }
}
