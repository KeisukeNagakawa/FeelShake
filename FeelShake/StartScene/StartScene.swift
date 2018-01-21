
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
        // 背景を追加
        self.backgroundColor = bgColor
        
        // オブジェを追加
        center = CGPoint(x:self.frame.midX, y:self.frame.midY*0.6 + self.frame.maxY*0.5)
        let w = (self.size.width + self.size.height) * 0.25 //
        self.circle = SKShapeNode.init(
            rectOf: CGSize.init(width: w * dConst.radRatio, height: w * dConst.radRatio),
            cornerRadius: w * 0.5 * dConst.radRatio)
        self.circle?.fillColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.circle?.lineWidth = 0.0
        for i in 0..<3 {
            cNodes.append(self.circle?.copy() as! SKShapeNode?)
            cNodes[i]?.position = center
            self.addChild(cNodes[i]!)
        }
        cStates = createCircleStates()
        

        
        let slightlyUpperCenterY = (self.frame.maxY*0.20 + self.frame.midY * 0.8)
        // タイトルを追加
        let titleLabel = SKLabelNode(fontNamed: basicFont)
        titleLabel.fontColor = UIColor.black
        titleLabel.text = "Feelshake"
        titleLabel.fontSize = 80
        titleLabel.position = CGPoint(
            x:self.frame.midX,
            y:(slightlyUpperCenterY+self.frame.minY)*0.5)
        self.addChild(titleLabel)
        
        // トレーニングボタン関係
        let buttonLeft = ButtonNode(fontNamed: basicFont)
        buttonLeft.fontColor = UIColor.black
        buttonLeft.text = "トレーニング"
        buttonLeft.fontSize = 30
        buttonLeft.position = CGPoint(
            x:(self.frame.midX + self.frame.minX)*0.5,
            y:(slightlyUpperCenterY*0.2+self.frame.minY*0.8))
        buttonLeft.didTapButtonClosure = {
            let scene = GameScene(size: self.scene!.size)
            scene.scaleMode = SKSceneScaleMode.aspectFill
            self.view!.presentScene(scene)
        }
        self.addChild(buttonLeft)

        // チャレンジボタンを追加
        let buttonRight = ButtonNode(fontNamed: basicFont)
        buttonRight.fontColor = UIColor.black
        buttonRight.text = "チャレンジ"
        buttonRight.fontSize = 30
        buttonRight.position = CGPoint(
            x:(self.frame.midX + self.frame.maxX)*0.5,
            y:(slightlyUpperCenterY*0.2+self.frame.minY*0.8))
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
            for i in 0..<3 {
                cNodes[i]!.position = cStates[i].pos
            }
            
            //-----------------------
            last! = currentTime
        }
        
    }
}



