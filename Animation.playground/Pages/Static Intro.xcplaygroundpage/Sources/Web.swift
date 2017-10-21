import SpriteKit

public final class WebView: UIView {

    private let sceneView: SKView
    private let scene: SKScene


    public init(size: CGSize) {
        sceneView = SKView(frame: CGRect(origin: .zero, size: size))
        scene = SKScene(size: size)
        super.init(frame: CGRect(origin: .zero, size: size))
        setupScene()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var nodes: [SKShapeNode] = []
    private var lines: [[SKShapeNode]] = []

    func setupScene() {
        backgroundColor = .clear
        clipsToBounds = false
        sceneView.backgroundColor = .clear
        sceneView.clipsToBounds = false
        scene.backgroundColor = .clear
        nodes = (0...3).map { _ -> SKShapeNode in
            let node = SKShapeNode(circleOfRadius: 10)
            node.position = CGPoint(x: CGFloat(arc4random()).truncatingRemainder(dividingBy: frame.size.width - 10) + 10,
                                    y: CGFloat(arc4random()).truncatingRemainder(dividingBy: frame.size.height - 10) + 10)
            node.fillColor = .black
            scene.addChild(node)
            return node
        }
        lines = nodes.enumerated().map({ nodeIndex, node in
            guard nodeIndex != 0 else { return [] }
            return nodes.enumerated().flatMap({ otherNodeIndex, otherNode -> SKShapeNode? in
                guard nodeIndex > otherNodeIndex else {
                    return nil
                }
                let path = CGMutablePath()
                path.move(to: node.position)
                path.addLine(to: otherNode.position)

                let shape = SKShapeNode()
                shape.path = path
                shape.strokeColor = .white
                shape.lineWidth = 2
                shape.zPosition = -1
                scene.addChild(shape)
                return shape
            })
        })

        sceneView.presentScene(scene)
        addSubview(sceneView)
    }

    public func firstAnimation(duration: TimeInterval) {
        lines.forEach({ $0.forEach({ line in
            line.run(SKAction.fadeAlpha(to: 0, duration: duration))
        })
        })
        nodes.forEach { node in
            node.run(SKAction.move(to: self.sceneView.center,
                                   duration: duration))
        }
    }

    public func secondAnimation(duration: TimeInterval) {
        guard let firstNode = nodes.first else { return }
        nodes.enumerated().forEach { nodeIndex, node in
            node.run(SKAction.moveBy(x: CGFloat(nodeIndex * 30) - 60,
                                     y: 0,
                                     duration: duration))
        }
        let path = CGMutablePath()
        path.move(to: CGPoint(x: firstNode.position.x - 60,
                              y: firstNode.position.y))
        path.addLine(to: CGPoint(x: firstNode.position.x + 30,
                                 y: firstNode.position.y))

        let shape = SKShapeNode()
        shape.path = path
        shape.strokeColor = .white
        shape.lineWidth = 2
        shape.zPosition = -1
        scene.addChild(shape)
        lines.append([shape])
    }

    public func thirdAnimation(duration: TimeInterval) {
        nodes[0].run(SKAction.moveBy(x: 20, y: -20, duration: duration))
        nodes[1].run(SKAction.moveBy(x: -10, y: 20, duration: duration))
        nodes[2].run(SKAction.moveBy(x: -60, y: 0, duration: duration))
        nodes[3].run(SKAction.moveBy(x: 20, y: 0, duration: duration))
        lines.removeLast()
        let firstLinePath = CGMutablePath()
        firstLinePath.move(to: CGPoint(x: nodes[0].position.x + 20,
                                       y: nodes[0].position.y - 20))
        firstLinePath.addLine(to: CGPoint(x: nodes[2].position.x - 60,
                                          y: nodes[2].position.y))
        let firstLine = SKShapeNode()
        firstLine.path = firstLinePath
        firstLine.strokeColor = .white
        firstLine.lineWidth = 2
        firstLine.zPosition = -1
        scene.addChild(firstLine)

        let secondLinePath = CGMutablePath()
        secondLinePath.move(to: CGPoint(x: nodes[1].position.x - 10,
                                       y: nodes[1].position.y + 20))
        secondLinePath.addLine(to: CGPoint(x: nodes[2].position.x - 60,
                                          y: nodes[2].position.y))
        let secondLine = SKShapeNode()
        secondLine.path = secondLinePath
        secondLine.strokeColor = .white
        secondLine.lineWidth = 2
        secondLine.zPosition = -1
        scene.addChild(secondLine)

        let thirdLinePath = CGMutablePath()
        thirdLinePath.move(to: CGPoint(x: nodes[2].position.x - 60,
                                        y: nodes[2].position.y))
        thirdLinePath.addLine(to: CGPoint(x: nodes[3].position.x + 20,
                                           y: nodes[3].position.y))
        let thirdLine = SKShapeNode()
        thirdLine.path = thirdLinePath
        thirdLine.strokeColor = .white
        thirdLine.lineWidth = 2
        thirdLine.zPosition = -1
        scene.addChild(thirdLine)

        lines.append([firstLine, secondLine, thirdLine])
    }
}
