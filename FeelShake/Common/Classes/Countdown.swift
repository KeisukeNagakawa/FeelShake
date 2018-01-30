//
//  Countdown.swift
//  FeelShake
//
//  Created by Nagakawa Keisuke on 2018/01/28.
//  Copyright © 2018年 Kei. All rights reserved.
//

import Foundation
import SpriteKit


// Train Sceneのカウントダウンに関するdelegateのプロトコル（約束）
protocol TrainSceneCountdownDelegateProtocol {
    func addChild(_ node: SKNode) -> Void
    func run(_ action: SKAction) -> Void
    var stopwatch: LabelStopwatch {get set}
//    var stopwatch =  LabelStopwatch(label: SKLabelNode(text: "") )

    var stopwatchOnFlag:Bool {set get}
    
//    var view: SKView? { get }

}

class Countdown {

    let countdownLabel = SKLabelNode.init(fontNamed: "Avenir-BlackOblique")
    var stopwatchOnFlag = false
    var count:Int = countDownTime
    var position:CGPoint
    var delegate: TrainSceneCountdownDelegateProtocol!

    
    init(position p :CGPoint){
        self.position = p
    }

    func countdownAction() {
        self.count +=  -1
        if self.count != 0 {
            self.countdownLabel.text = "\(count)"
        }else {
            self.countdownLabel.text = "START"
            self.countdownLabel.fontSize = countdownLabel.fontSize * 0.5
            delegate.stopwatchOnFlag = true
            print(delegate.stopwatch)
            delegate.stopwatch.start()

            // startとともにストップウォッチ開始
        }
    }

    func endCountdown() {
        // カウントダウン終了後の操作
        countdownLabel.removeFromParent()
    }

    func startCountdown(count: Int = countDownTime) {
        self.countdownLabel.horizontalAlignmentMode = .center
        self.countdownLabel.verticalAlignmentMode = .baseline
        self.countdownLabel.position = self.position
        self.countdownLabel.fontColor = SKColor.black
        self.countdownLabel.fontSize = 300
        self.countdownLabel.zPosition = 100
        self.countdownLabel.text = "\(count)"
        delegate.addChild(countdownLabel)
        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                  SKAction.run(countdownAction)])
        delegate.run(SKAction.sequence([SKAction.repeat(counterDecrement, count: count+1),//count+1でSTARTを挿入
            SKAction.run(endCountdown)]))
    }

}
