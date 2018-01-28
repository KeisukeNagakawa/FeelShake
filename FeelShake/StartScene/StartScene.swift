
//
//  StartScene.swift
//  shindo
//
//  Created by Nagakawa Keisuke on 2018/01/20.
//  Copyright © 2018年 Kei. All rights reserved.
//

import Foundation
import SpriteKit


class StartScene: SKScene {
    
    private var circle : SKShapeNode?
    private var cNodes : [SKShapeNode?] = []
    private var cStates:[CircleState] = []
    private var last:Double?
    var center = CGPoint(x:0.0, y:0.0)

    override func didMove(to view: SKView) {
        print("startScene:\(self.frame.minX), \(self.frame.maxX)")
        // 背景を追加
        self.backgroundColor = bgColor
        

        
        // オブジェを追加
        center = CGPoint(x:self.frame.midX, y:self.frame.midY*0.6 + self.frame.maxY*0.4)
        let w = (self.size.width + self.size.height) * 0.40 //
        self.circle = SKShapeNode.init(
            rectOf: CGSize.init(width: w * dConst.radRatio, height: w * dConst.radRatio),
            cornerRadius: w * 0.5 * dConst.radRatio)
        self.circle?.fillColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
        self.circle?.lineWidth = 0.0
        for i in 0..<1 {
            cNodes.append(self.circle?.copy() as! SKShapeNode?)
            cNodes[i]?.position = center
            self.addChild(cNodes[i]!)
        }
        cStates = createCircleStates()
        

        
        let slightlyUpperCenterY = (self.frame.maxY*0.30 + self.frame.midY * 0.7)
        // タイトルを追加
        let titleLabel = SKLabelNode(fontNamed: "HiraKakuProN-W3")
        titleLabel.fontColor = UIColor.black
        titleLabel.text = "絶対震感"
        titleLabel.fontSize = 100
        titleLabel.position = CGPoint(
            x:self.frame.midX,
            y:0.45 * slightlyUpperCenterY + 0.55 * self.frame.minY
        )
        self.addChild(titleLabel)
        
        
        // メニュー
        // トレーニングボタン関係
        let d = 0.5 * (self.frame.maxX - self.frame.minX)
        let midX = self.frame.midX
        let menuY = slightlyUpperCenterY*0.2+self.frame.minY*0.8
        let buttonLeft = ButtonNode(fontNamed: basicFont)
        buttonLeft.fontColor = UIColor.black
        buttonLeft.text = "トレーニング"
        buttonLeft.fontSize = fontSizeForMenu
        buttonLeft.position = CGPoint(
            x: midX - d * 0.6,
            y: menuY
        )
        buttonLeft.didTapButtonClosure = {
            let scene = TrainScene(size: self.scene!.size)
            self.view!.presentScene(scene, transition: SKTransition.fade(with: UIColor.white, duration: transitionTime))
        }
        self.addChild(buttonLeft)


        // チャレンジボタンを追加
        let buttonMid = ButtonNode(fontNamed: basicFont)
        buttonMid.fontColor = UIColor.black
        buttonMid.text = "チャレンジ"
        buttonMid.fontSize = fontSizeForMenu
        buttonMid.position = CGPoint(
            x:midX,
            y:menuY
        )
        
        buttonMid.didTapButtonClosure = {
            let scene = TrainScene(size: self.scene!.size)
            self.view!.presentScene(scene, transition: SKTransition.fade(with: UIColor.white, duration: transitionTime))
//            self.view!.presentScene(scene, transition: SKTransition.test())
        }
        self.addChild(buttonMid)

        // 揺れから検索ボタンを追加
        let buttonRight = ButtonNode(fontNamed: basicFont)
        buttonRight.fontColor = UIColor.black
        buttonRight.text = "ゆれから検索"
        buttonRight.fontSize = fontSizeForMenu
        buttonRight.position = CGPoint(
            x: midX + d * 0.6,
            y: menuY
        )
        buttonRight.didTapButtonClosure = {
            let scene = TrainScene(size: self.scene!.size)
            self.view!.presentScene(scene, transition: SKTransition.fade(with: UIColor.white, duration: transitionTime))
        }
        self.addChild(buttonRight)



    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // lastが未定義なら値を代入（初回だけ呼ばれる）
        if last == nil { last = currentTime }
        // 先の時間よりもdtだけ経過したらループ内部を実行
        // （だいたいdtおきに実行）
        if currentTime - last! >= Double(pConst.dt) {
            //--------loop---------------
            // 座標の更新
            updateStates(userAcc: CGPoint(x:0.0, y:0.0), states: &cStates, center: center, pattern:MovingPattern.start)
            for i in 0..<1 {
                cNodes[i]!.position = cStates[i].pos
            }
            
            //-----------------------
            last! = currentTime
        }
        
    }
}



