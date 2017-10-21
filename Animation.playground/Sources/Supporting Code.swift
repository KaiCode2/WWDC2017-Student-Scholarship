import UIKit

public func delay(_ time: TimeInterval, block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()
        + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
}

public extension Sequence {
    func delayedMap(block: @escaping (Iterator.Element) -> TimeInterval,
                    completion: (() -> Void)? = nil) {
        var iterator = makeIterator()
        func performOperation() {
            guard let item = iterator.next() else { return }
            let wait = block(item)
            delay(wait) {
                performOperation()
            }
        }
        performOperation()
        completion?()
    }
}

public extension UIColor {
    static let semiDarkGray = #colorLiteral(red: 0.33, green: 0.34, blue: 0.37, alpha: 1)
    static let darkBlue = #colorLiteral(red: 0, green: 0.14, blue: 0.32, alpha: 1)

    class var random: UIColor {
        return UIColor(colorLiteralRed: Float(arc4random()%100)/100,
                       green: Float(arc4random()%100)/100,
                       blue: Float(arc4random()%100)/100,
                       alpha: 1)
    }
}

public func animateLabel(label: UILabel,
                  text: String,
                  offset: TimeInterval) {
    DispatchQueue.main.async {
        text.characters.delayedMap(block: { character -> TimeInterval in
            label.text = "\(label.text!)\(character)"
            return offset
        })
    }
}

public protocol ReusableViewType: class {
    static var defaultReuseIdentifier: String { get }
    static var defaultKind: String { get }
}

extension ReusableViewType {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }

    public static var defaultKind: String {
        return String(describing: self) + "Kind"
    }
}

public extension UITableView {
    public func register<T: UITableViewCell>(_: T.Type) where T: ReusableViewType {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableViewType {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
