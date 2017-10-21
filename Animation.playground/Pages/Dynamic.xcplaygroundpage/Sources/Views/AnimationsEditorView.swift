import UIKit

public final class AnimationsEditorView: UIView, UITableViewDataSource, UITableViewDelegate {
    fileprivate let delegate: AnimationEditorType
    fileprivate var tableView: UITableView
    fileprivate let blurView: UIVisualEffectView

    fileprivate var animationEditorCallout: AnimationCellCallout? = nil

    public init(delegate: AnimationEditorType) {
        self.delegate = delegate
        tableView = UITableView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 200,
                                              height: 450))

        tableView.register(AnimationCell.self)
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.contentSize = CGSize(width: 150, height: 75)
        tableView.backgroundColor = .clear
        let darkBlurEffect = UIBlurEffect(style: .extraLight)
        blurView = UIVisualEffectView(effect: darkBlurEffect)
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 200,
                                                             height: 450)))
        blurView.frame = frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        backgroundColor = .clear
        addSubview(blurView)
        addSubview(tableView)
    }

    public func willRemove() {
        guard let editor = animationEditorCallout else { return }
        UIView.animate(withDuration: 0.2,
                       animations: { 
                        editor.alpha = 0
        }) { _ in
            editor.removeFromSuperview()
            self.animationEditorCallout = nil
        }
    }

    func layout() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.getAnimations().count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let animation = delegate.getAnimations()[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as AnimationCell
        cell.set(animation: animation)
        return cell
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate.delete(atIndex: indexPath.row)
            tableView.reloadData()
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let superview = superview else { return }
        let animation = delegate.getAnimations()[indexPath.row]
        if let previousEditor = animationEditorCallout {
            if animation == previousEditor.animation {
                previousEditor.update()
                previousEditor.removeFromSuperview()
                animationEditorCallout = nil
                return
            }
            previousEditor.update()
            previousEditor.removeFromSuperview()
            animationEditorCallout = nil
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let locationForEditor = tableView.rectForRow(at: indexPath).origin.y + 25
        animationEditorCallout = AnimationCellCallout(frame: CGRect(x: frame.origin.x + frame.width,
                                                                 y: locationForEditor,
                                                                 width: 115, height: 115),
                                                   delegate: delegate)
        animationEditorCallout?.layout(animation: delegate.getAnimations()[indexPath.row])
        superview.addSubview(animationEditorCallout!)
    }
}

