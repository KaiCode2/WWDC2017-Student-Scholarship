import SceneKit

public final class GlobeView: UIView {
    private struct constants {
        static let rotateActionKey = "rotate"
    }
    let sceneView: SCNView
    let scene: SCNScene
    let sphere: SCNSphere
    let node: SCNNode
    let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: -2*CGFloat.pi, z: 0, duration: 5))

    public init(size: CGSize) {
        self.sceneView = SCNView(frame: CGRect(origin: .zero,
                                               size: size))
        self.scene = SCNScene()
        self.sphere = SCNSphere(radius: 5)
        self.node = SCNNode(geometry: sphere)
        super.init(frame: CGRect(origin: .zero, size: size))
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        sphere.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "globe.png")
        scene.rootNode.addChildNode(node)
        sceneView.backgroundColor = .clear
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        addSubview(sceneView)

        node.runAction(rotateAction, forKey: constants.rotateActionKey)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        node.removeAction(forKey: constants.rotateActionKey)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        node.runAction(rotateAction, forKey: constants.rotateActionKey)
    }
}
