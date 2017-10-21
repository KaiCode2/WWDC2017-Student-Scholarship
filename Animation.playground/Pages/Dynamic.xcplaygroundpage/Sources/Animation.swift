import UIKit

public struct Animation {
    public enum Transormation {
        case translate(CGMutablePath)
        case rotate(CGFloat)
        case scale(CGFloat)
    }

    var transformation: Transormation
    var curve: UICubicTimingParameters
    var color: UIColor

    fileprivate let id = UUID()
}

extension Animation: Equatable {
    public static func ==(lhs: Animation, rhs: Animation) -> Bool {
        return lhs.id == rhs.id
    }
}

