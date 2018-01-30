//
//  GameScene.swift
//  shindo
//
//  Created by Nagakawa Keisuke on 2018/01/17.
//  Copyright © 2018年 Kei. All rights reserved.
//

import SpriteKit
import GameplayKit



class TrainScene: SKScene, StartSceneDelegateProtocol,TrainSceneCountdownDelegateProtocol,TrainSceneStopwatchDelegateProtocol {
    
    private var circle : SKShapeNode?
    private var cNodes : [SKShapeNode?] = []
    private var cStates:[CircleState] = []
    private var last:Double?
    private var finishedTime:Double?

    private var lastForSW:Double?
    var center = CGPoint(x:0.0, y:0.0)
    // stopwatch用のパラメタ
    var stopwatchOnFlag : Bool = false
    var finishedFlag : Bool = false
    var stopwatch =  LabelStopwatch(label: SKLabelNode(text: "") )
    var stopwatchLabel:SKLabelNode = SKLabelNode(fontNamed: timerFont)
    
    var trainParts = GameSceneParts(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

    


    override func didMove(to view: SKView) {
        // 初期設定
        self.backgroundColor = bgColor
        self.center = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        // ストップウォッチを追加
        stopwatch.delegate = self
        stopwatchLabel.fontSize = 60
        stopwatchLabel.text = "15:00"
        stopwatchLabel.position = CGPoint(x: self.frame.midX, y:0.1*self.frame.midY+0.9*self.frame.maxY)
        stopwatchLabel.fontColor = SKColor.black
        self.addChild(stopwatchLabel)
        
        
        
        // Countdown
        let cd = Countdown(position: CGPoint(x:self.frame.midX, y:self.frame.midY))
        cd.delegate = self
        cd.startCountdown()
    
        // 円のノード（circle）を作る（いわゆるビューみたいなもん）
        cNodes = createInitCircleNodes(num: dConst.nCircle, size: self.size, frame: self.frame)
        for i in 0..<dConst.nCircle {
            addChild(cNodes[i]!)
        }
        // 円の状態（cStat）を作る（
        cStates = createCircleStates()
        
        
        // 戻るボタン関係
        trainParts = GameSceneParts(frame: self.frame)
        trainParts.delegate = self
        trainParts.drawButton(
            withText: "Back",
            position: CGPoint( x: self.frame.midX, y: self.frame.midY*0.2 + self.frame.minY*0.8),
            moveTo: StartScene(size: self.scene!.size))
        


    }
    
    
    
    override func update(_ currentTime: TimeInterval) {

        // Called before each frame is rendered
        // lastが未定義なら値を代入（初回だけ呼ばれる）

        if last == nil { last = currentTime }
        // 先の時間よりもdtだけ経過したらループ内部を実行
        // （だいたいdtおきに実行）
        if currentTime - last! >= Double(pConst.dt) && self.stopwatchOnFlag == true {
            //--------loop---------------
            // 座標の更新
            updateStates(states: &cStates, center: center, pattern:MovingPattern.gas)
            for i in 0..<dConst.nCircle {
                cNodes[i]!.position = cStates[i].pos
            }

            //-----------------------
            last! = currentTime
        }
        
        // ストップウォッチがゼロになった時の挙動
        if finishedFlag == true {
            //trainParts.drawtitle(currentTime
            trainParts.drawTitle(fontNamed:"Avenir-BlackOblique", text: "Finish!!", fontSize:200, position:  center)
            if finishedTime == nil {
                finishedTime = currentTime
            }
            
        }
        // Finish!!を表示して、2秒後に遷移
        if finishedTime != nil && (currentTime - finishedTime! >= Double(2.0)) {
            trainParts.onlyTransition(to: StartScene(size: self.scene!.size))
        }

        
        
    }
}

