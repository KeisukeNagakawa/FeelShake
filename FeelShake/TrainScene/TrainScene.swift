//
//  GameScene.swift
//  shindo
//
//  Created by Nagakawa Keisuke on 2018/01/17.
//  Copyright © 2018年 Kei. All rights reserved.
//

import SpriteKit
import GameplayKit



class TrainScene: SKScene {
    
    private var label : SKLabelNode?
    private var circle : SKShapeNode?
    private var cNodes : [SKShapeNode?] = []
    private var cStates:[CircleState] = []
    private var last:Double?
    private var lastForSW:Double?
    var center = CGPoint(x:0.0, y:0.0)
    // カウントダウン用のパラメタ
    var startFlag:Bool = false
    // stopwatch用のパラメタ
    var stopwatch: LabelStopwatch!
    let stopwatchLabel = SKLabelNode(fontNamed: timerFont)

    override func didMove(to view: SKView) {
        
        // count down
        let countdownLabel = SKLabelNode.init(fontNamed: basicFont)
        var count:Int = countDownTime

        func countdownAction() {
            count = count - 1
            if count != 0 {
                countdownLabel.text = "\(count)"
            }else {
                countdownLabel.text = "START"
                countdownLabel.fontSize = countdownLabel.fontSize * 0.5
                startFlag = true
                // startとともにストップウォッチ開始
                stopwatch = LabelStopwatch(label: stopwatchLabel)
                stopwatch.start()

                
            }
            
        }
        
        func endCountdown() {
            // カウントダウン終了後の操作
            countdownLabel.removeFromParent()

            
        }

        func countdown(count: Int) {
            countdownLabel.horizontalAlignmentMode = .center
            countdownLabel.verticalAlignmentMode = .baseline
            countdownLabel.position = CGPoint(x:self.frame.midX, y:(self.frame.midY))
            countdownLabel.fontColor = SKColor.black
            countdownLabel.fontSize = 300
            countdownLabel.zPosition = 100
            countdownLabel.text = "\(count)"
            addChild(countdownLabel)
            let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                      SKAction.run(countdownAction)])
            run(SKAction.sequence([SKAction.repeat(counterDecrement, count: count+1),//count+1でSTARTを挿入
                                   SKAction.run(endCountdown)]))
        }
        countdown(count: countDownTime)

        
        
        self.backgroundColor = bgColor
        center = CGPoint(x:self.frame.midX, y:self.frame.midY)


        // Create circle
        let w = (self.size.width + self.size.height) * 0.05 // size is 5% of the view size
        self.circle = SKShapeNode.init(
            rectOf: CGSize.init(width: w * dConst.radRatio, height: w * dConst.radRatio),
            cornerRadius: w * 0.5 * dConst.radRatio)
        self.circle?.fillColor = .blue
        self.circle?.lineWidth = 0.0
        self.alpha = 0.5
        
        // 円のノードを作る
        for i in 0..<dConst.nCircle {
            cNodes.append(self.circle?.copy() as! SKShapeNode?)
            cNodes[i]?.position = center
            self.addChild(cNodes[i]!)
        }
        // 円の状態を作る
        cStates = createCircleStates()
        
        // 戻るボタンを追加
        let button = ButtonNode(fontNamed: basicFont)
        button.fontColor = UIColor.black
        button.text = "Back"
        button.fontSize = fontSizeForButton
        button.position = CGPoint(x:self.frame.midX, y:self.frame.midY*0.2+self.frame.minY*0.8)
        button.didTapButtonClosure = {
            let scene = StartScene(size: self.scene!.size)
            self.view!.presentScene(scene, transition: SKTransition.fade(with: UIColor.white, duration: 2.0))
        }
        self.addChild(button)


        // stop watch labelを追加
        stopwatchLabel.fontSize = fontSizeForCountDown
        stopwatchLabel.text = "15:00"
        stopwatchLabel.position = CGPoint(x: self.frame.midX, y:0.1*self.frame.midY+0.9*self.frame.maxY)
        stopwatchLabel.fontColor = SKColor.black
        self.addChild(stopwatchLabel)




    }
    
    
    
    override func update(_ currentTime: TimeInterval) {

        // Called before each frame is rendered
        // lastが未定義なら値を代入（初回だけ呼ばれる）

        if last == nil { last = currentTime }
        // 先の時間よりもdtだけ経過したらループ内部を実行
        // （だいたいdtおきに実行）
        if currentTime - last! >= Double(pConst.dt) && startFlag == true {
            //--------loop---------------
            // 座標の更新
            updateStates(userAcc: CGPoint(x:0.0, y:0.0), states: &cStates, center: center, pattern:MovingPattern.gas)
            for i in 0..<dConst.nCircle {
                cNodes[i]!.position = cStates[i].pos
            }

            //-----------------------
            last! = currentTime
        }
    }
}

