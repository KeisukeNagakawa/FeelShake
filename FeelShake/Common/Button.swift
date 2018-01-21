import SpriteKit

class ButtonNode: SKLabelNode {
    
    var didTapButtonClosure: (() -> Void)?
    
    override init() {
        super.init()
        isUserInteractionEnabled = true
    }
    override init(fontNamed fontName: String?) {
        super.init(fontNamed: fontName)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIResponder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        setHighlighted(highlighted: true)
    }
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        setHighlighted(highlighted: false)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setHighlighted(highlighted: false)
        didTapButtonClosure?()
    }
    
    //MARK: - private
    
    private func setHighlighted(highlighted: Bool) {
        removeAllActions()
        let alpha: CGFloat = highlighted ? 0.5 : 0
        let color: UIColor = UIColor(white: 1.0, alpha: alpha)
        let highlightAction: SKAction = SKAction.customAction(withDuration: 0.24) { (node, elapsedTime) -> Void in
            self.fontColor = color
        }
        run(highlightAction)
    }
}
