//
//  GameScene.swift
//  shindo
//
//  Created by Nagakawa Keisuke on 2018/01/17.
//  Copyright © 2018年 Kei. All rights reserved.
//

import SpriteKit
import GameplayKit



class TrainScene: SKScene, StartSceneDelegateProtocol, TrainSceneCountdownDelegateProtocol,TrainSceneStopwatchDelegateProtocol {
    
    private var circle : SKShapeNode?
    private var cNodes : [SKShapeNode?] = []
    private var cStates:[CircleState] = []
    private var last:Double?
    private var lastForSW:Double?
    var center = CGPoint(x:0.0, y:0.0)
    // カウントダウン用のパラメタ
    var startFlag : Bool = false
    // stopwatch用のパラメタ
    var stopwatch =  LabelStopwatch(label: SKLabelNode(text: "") )
    var stopwatchLabel:SKLabelNode = SKLabelNode(fontNamed: timerFont)
    


    override func didMove(to view: SKView) {
        // 初期設定
        self.backgroundColor = bgColor
        self.center = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        // ストップウォッチを追加
        stopwatch.delegate = self
        stopwatchLabel.fontSize = fontSizeForCountDown
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
        
        
        // トレーニングボタン関係
        let trainParts = GameSceneParts(frame: self.frame)
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
        if currentTime - last! >= Double(pConst.dt) && self.startFlag == true {
            //--------loop---------------
            // 座標の更新
            updateStates(states: &cStates, center: center, pattern:MovingPattern.gas)
            for i in 0..<dConst.nCircle {
                cNodes[i]!.position = cStates[i].pos
            }

            //-----------------------
            last! = currentTime
        }
    }
}

