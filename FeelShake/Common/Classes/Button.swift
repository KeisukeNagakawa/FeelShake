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
        setHighlightedAndShaked(highlighted: true)
    }
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        //setHighlightedAndShaked(highlighted: false)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setWaited(for: Double(0.40))
    }
    
    //MARK: - private
    private func setWaited(for time:Double){

        let wait = SKAction.wait(forDuration: time)
        run(wait, completion: didTapButtonClosure!)
    }
    private func setHighlightedAndShaked(highlighted: Bool) {
        removeAllActions()
        var randActions:[SKAction]=[]
        var randAction:SKAction
        var randx, randy:CGFloat
        let randDt:Double = 0.01
        let originalPos = self.position
        var s:Int = 1
        let moveToOriginAction = SKAction.move(to: originalPos, duration: randDt)
        for _ in 0..<10 {
            s *= -1
            randx = (cgRand()-0.5) * 0.1 // -0.05~0.05
            randy = (cgRand()-0.5) * 0.1 // -0.05~0.05
            randAction = SKAction.moveBy(
                x: self.position.x * randx,
                y: self.position.y * randy,
                duration: randDt)
            randActions.append(randAction)
            randActions.append(moveToOriginAction)//逐一戻る
        }
        print(self.position)
        randActions.append(SKAction.wait(forDuration: 10.0))
        let sequence = SKAction.sequence(randActions)
        run(sequence)
    }
}
