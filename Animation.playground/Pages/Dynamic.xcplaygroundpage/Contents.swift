//: [Previous Page: Static](@previous)

import UIKit
import PlaygroundSupport

/*:
 ## Welcome
 First, let's create a Square
 
 ![Create Square](create_square.gif)
 
 Now, you can drag to move the square, or you *rotate* and *resize* the square using the sliders on the bottom.
 
 After creating a series of animations, you can open the animation menu to interact with the animations you created! Just Click this icon:
 
 ![Inidicator](expand_indicator.png)
 
 Now, you can swipe to delete animations you don't want. If you want to edit the timing curve of each animation simply tap on the item then adjust the timing points.
 */

let animationView = DynamicAnimationView(size: CGSize(width: 500,
                                                      height: 600))
PlaygroundPage.current.liveView = animationView

let box = Box()
animationView.addSubview(box)

let interactor = Interactor(view: box)
animationView.set(delegate: interactor)

let controller = ControllerView(frame: CGRect(x: 0, y: animationView.frame.size.height - 150,
                                              width: animationView.frame.width, height: 150),
                                delegate: interactor)
animationView.addSubview(controller)
