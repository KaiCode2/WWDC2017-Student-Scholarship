//: [Next Page: Dynamic](@next)

import UIKit
import PlaygroundSupport

/*:
 ### Hello 🍏
 
 This playground page showcases a series of interactive scenes about myself and the work I do.
 
 - Important: Please ensure the asistant editor is open and it is displaying the live view
 
 At the end, check out [the next page](@next) to design your own animations!
 
 
 Enjoy,

 Kai

 */


let animationView = AnimationView(size: CGSize(width: 400,
                                               height: 500))
PlaygroundPage.current.liveView = animationView


let firstScene = AnimationScene(delegate: animationView)

let helloLabel = UILabel(frame: .zero)
let faceImageView = UIImageView(image: #imageLiteral(resourceName: "Kai_Face_WIP.png"))

let audio = Audio(sound: .typing)

firstScene.setup = {
    firstScene.view.addSubview(helloLabel)
    firstScene.view.addSubview(faceImageView)

    helloLabel.frame.size = CGSize(width: 100, height: 25)
    helloLabel.center = animationView.center
    helloLabel.text = ""
    helloLabel.textColor = .darkGray

    faceImageView.contentMode = .scaleAspectFit
    faceImageView.frame = CGRect(x: (animationView.frame.width / 2) - 50,
                                 y: (animationView.frame.height / 2) - 50,
                                 width: 100,
                                 height: 100)
    faceImageView.alpha = 0
}

firstScene.tearDown = {
    helloLabel.removeFromSuperview()
    faceImageView.removeFromSuperview()
}

firstScene.animations.append {
    let animationDelay = 0.5
    let offset = 0.1
    let text = "Hello, I'm Kai"

    delay(animationDelay) {
        animateLabel(label: helloLabel, text: text, offset: offset)
        audio.play(count: 15, delay: 0.1)
    }
    return 4
}

firstScene.animations.append {
    let introAnimator = UIViewPropertyAnimator(duration: 0.5,
                                               dampingRatio: 0.45) {
                                                faceImageView.alpha = 1.0
                                                faceImageView.frame.origin.y = (animationView.frame.height / 2) - 100
                                                helloLabel.frame.origin.y = (animationView.frame.height / 2) + 50
    }
    introAnimator.startAnimation()
    return 1
}

firstScene.animations.append { () -> TimeInterval in
    let bezierParam = UICubicTimingParameters(controlPoint1: CGPoint(x: 0, y: 1),
                                              controlPoint2: CGPoint(x: 0.3, y: 1.2))
    let outroAnimator = UIViewPropertyAnimator(duration: 0.5, timingParameters: bezierParam)
    outroAnimator.addAnimations {
        faceImageView.center = animationView.center
        helloLabel.center = animationView.center
        helloLabel.textColor = .white
        faceImageView.alpha = 0
        firstScene.view.backgroundColor = .darkBlue
    }
    outroAnimator.startAnimation()
    return 1
}

let processAnimationScene = AnimationScene(delegate: animationView)
let processTopLabel = UILabel(frame: .zero)
let globe = GlobeView(size: CGSize(width: 100, height: 100))
processAnimationScene.setup = {
    processAnimationScene.view.backgroundColor = .semiDarkGray

    processTopLabel.text = "Ideas,"
    processTopLabel.textAlignment = .center
    processTopLabel.textColor = .white
    processTopLabel.frame.origin = CGPoint(x: 0,
                                           y: (animationView.frame.height/2) - 12.5)
    processTopLabel.frame.size = CGSize(width: animationView.frame.width,
                                        height: 25)
    processAnimationScene.view.addSubview(processTopLabel)
}
processAnimationScene.tearDown = {
    processAnimationScene.view.subviews.forEach({ $0.removeFromSuperview() })
}

processAnimationScene.animations.append { () -> TimeInterval in
    animateLabel(label: processTopLabel,
                 text: " that can change the",
                 offset: 0.1)
    globe.alpha = 0
    globe.frame.origin = CGPoint(x: animationView.center.x - 50,
                                 y: animationView.center.y)
    UIViewPropertyAnimator(duration: 1,
                           dampingRatio: 0.5,
                           animations: {
                            globe.alpha = 1
                            globe.frame.origin.y -= 150
    }).startAnimation(afterDelay: 3)
    processAnimationScene.view.addSubview(globe)
    return 6
}
processAnimationScene.animations.append { () -> TimeInterval in
    let outroLabel = UILabel(frame: CGRect(x: 0,
                                           y: animationView.center.y + 25,
                                           width: animationView.frame.width,
                                           height: 50))
    outroLabel.alpha = 0
    outroLabel.textAlignment = .center
    outroLabel.textColor = .white
    outroLabel.text = "But ideas alone are not enough."
    processAnimationScene.view.addSubview(outroLabel)
    UIViewPropertyAnimator(duration: 0.5,
                           dampingRatio: 0.5,
                           animations: {
                            processTopLabel.alpha = 0
                            processTopLabel.center.y -= 25
                            outroLabel.alpha = 1
                            outroLabel.center.y = animationView.center.y
    }).startAnimation()
    return 5
}

processAnimationScene.animations.append { () -> TimeInterval in
    UIView.animate(withDuration: 0.1, animations: {
        processAnimationScene.view.backgroundColor = .white
        processAnimationScene.view.subviews.forEach({ $0.alpha = 0 })
    })
    return 0.2
}

let developmentScene = AnimationScene(delegate: animationView)
let developmentLabel = UILabel(frame: .zero)
let codeAnimationImageView = UIImageView(frame: .zero)
developmentScene.setup = {
    developmentLabel.text = "Delight, brought to life through code."
    developmentLabel.textColor = .white
    developmentLabel.textAlignment = .center
    developmentLabel.frame = CGRect(x: 10,
                                    y: 120,
                                    width: animationView.frame.width - 20,
                                    height: 50)
    developmentLabel.alpha = 0
    developmentScene.view.addSubview(developmentLabel)

    developmentScene.view.backgroundColor = .black
    codeAnimationImageView.contentMode = .scaleAspectFit
    codeAnimationImageView.frame = CGRect(x: 0, y: animationView.center.y,
                                          width: animationView.frame.width,
                                          height: 300)
    codeAnimationImageView.animationImages = (0...47).flatMap({ index -> UIImage? in
        guard let image = UIImage(named: "Code_animation/code_\(index)") else { return nil }
        return image
    })
    codeAnimationImageView.image = UIImage(named: "Code_animation/code_47")
    codeAnimationImageView.animationDuration = 5
    codeAnimationImageView.animationRepeatCount = 1

    developmentScene.view.addSubview(codeAnimationImageView)
}

developmentScene.animations.append {
    UIViewPropertyAnimator(duration: 0.5,
                           dampingRatio: 0.3,
                           animations: { 
                            developmentLabel.alpha = 1
                            developmentLabel.frame.origin.y -= 20
    }).startAnimation(afterDelay: 0.2)
    codeAnimationImageView.startAnimating()
    return 6
}

developmentScene.tearDown = {
    developmentScene.view.subviews.forEach({ $0.removeFromSuperview() })
}

let someScene = AnimationScene(delegate: animationView)
let firstLabel = UILabel(frame: .zero)
let secondLabel = UILabel(frame: .zero)
let thirdLabel = UILabel(frame: .zero)
let web = WebView(size: CGSize(width: 200, height: 200))
someScene.setup = {
    someScene.view.backgroundColor = .semiDarkGray
    let labelRect = CGRect(x: 20,
                           y: animationView.center.y + 25,
                           width: 250,
                           height: 50)
    firstLabel.frame = labelRect
    firstLabel.text = "It takes Powerful Ideas,"
    firstLabel.textColor = .white
    firstLabel.textAlignment = .center
    firstLabel.alpha = 0
    someScene.view.addSubview(firstLabel)

    secondLabel.frame = labelRect
    secondLabel.text = "Concise Design,"
    secondLabel.textColor = .white
    secondLabel.textAlignment = .center
    secondLabel.alpha = 0
    someScene.view.addSubview(secondLabel)

    web.frame.origin = CGPoint(x: animationView.frame.width - 200,
                               y: animationView.center.y - 100)
    web.alpha = 0
    someScene.view.addSubview(web)
}
someScene.tearDown = {
    someScene.view.subviews.forEach({ $0.removeFromSuperview() })
}

someScene.animations.append { () -> TimeInterval in
    let animator = UIViewPropertyAnimator(duration: 0.5,
                                          dampingRatio: 0.5,
                                          animations: {
                                            firstLabel.frame.origin.y -= 50
                                            firstLabel.alpha = 1
                                            web.alpha = 1
    })
    animator.startAnimation(afterDelay: 1)
    return 4
}

someScene.animations.append { () -> TimeInterval in
    UIViewPropertyAnimator(duration: 0.5,
                           dampingRatio: 0.5,
                           animations: { 
                            firstLabel.frame.origin.y -= 50
                            firstLabel.alpha = 0
                            secondLabel.frame.origin.y -= 50
                            secondLabel.alpha = 1
    }).startAnimation()
    web.firstAnimation(duration: 0.5)
    return 3
}

someScene.animations.append { () -> TimeInterval in
    firstLabel.text = "and Quality Code."
    firstLabel.frame.origin.y = animationView.center.y + 25
    UIViewPropertyAnimator(duration: 0.5,
                           dampingRatio: 0.5,
                           animations: {
                            secondLabel.frame.origin.y -= 50
                            secondLabel.alpha = 0
                            firstLabel.frame.origin.y -= 50
                            firstLabel.alpha = 1
    }).startAnimation()
    web.secondAnimation(duration: 0.5)
    return 3
}

someScene.animations.append { () -> TimeInterval in
    secondLabel.text = "But most of all,"
    secondLabel.frame.origin.y = animationView.center.y + 25
    UIViewPropertyAnimator(duration: 0.5,
                           dampingRatio: 0.5,
                           animations: {
                            firstLabel.frame.origin.y -= 50
                            firstLabel.alpha = 0
                            secondLabel.frame.origin.y -= 50
                            secondLabel.alpha = 1
    }).startAnimation()
    web.thirdAnimation(duration: 0.5)
    return 3
}

someScene.animations.append { () -> TimeInterval in
    firstLabel.text = "Dare the change the world."
    firstLabel.textAlignment = .left
    firstLabel.frame.origin.y = animationView.center.y + 25
    UIViewPropertyAnimator(duration: 0.5,
                           dampingRatio: 0.5,
                           animations: {
                            secondLabel.frame.origin.y -= 50
                            secondLabel.alpha = 0
                            firstLabel.frame.origin.y -= 50
                            firstLabel.alpha = 1
    }).startAnimation()
    return 4
}

someScene.animations.append { () -> TimeInterval in
    secondLabel.text = "Differently"
    secondLabel.frame.origin.y = animationView.center.y + 25
    UIViewPropertyAnimator(duration: 0.5,
                           dampingRatio: 0.5,
                           animations: {
                            firstLabel.frame.origin.y -= 50
                            firstLabel.alpha = 0
                            secondLabel.frame.origin.y -= 50
                            secondLabel.alpha = 1
    }).startAnimation()
    return 2
}

let processScene = ProcessScene(delegate: animationView)
let designScene = DesignScene(delegate: animationView)
let finalScene = WWDCScene(delegate: animationView)
animationView.scenes.append(firstScene)
animationView.scenes.append(processScene)
animationView.scenes.append(processAnimationScene)
animationView.scenes.append(designScene)
animationView.scenes.append(developmentScene)
animationView.scenes.append(someScene)
animationView.scenes.append(finalScene)
animationView.animate()




