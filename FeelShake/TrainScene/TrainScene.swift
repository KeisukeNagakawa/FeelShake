//
//  GameScene.swift
//  shindo
//
//  Created by Nagakawa Keisuke on 2018/01/17.
//  Copyright © 2018年 Kei. All rights reserved.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var circle : SKShapeNode?
    private var cNodes : [SKShapeNode?] = []
    private var cStates:[CircleState] = []
    private var last:Double?
    var center = CGPoint(x:0.0, y:0.0)

    
    override func didMove(to view: SKView) {
        self.backgroundColor = bgColor
        center = CGPoint(x:self.frame.midX, y:self.frame.midY)

        // Create circle
        let w = (self.size.width + self.size.height) * 0.05 // size is 5% of the view size
        self.circle = SKShapeNode.init(
            rectOf: CGSize.init(width: w * dConst.radRatio, height: w * dConst.radRatio),
            cornerRadius: w * 0.5 * dConst.radRatio)
        self.circle?.fillColor = .red
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
        button.fontSize = 30
        button.position = CGPoint(x:self.frame.midX, y:self.frame.midY*0.2+self.frame.minY*0.8)
        let transition: () -> () = {
            let scene = StartScene(size: self.scene!.size)
            scene.scaleMode = SKSceneScaleMode.aspectFill
            self.view!.presentScene(scene)
        }
        button.didTapButtonClosure =  transition
        self.addChild(button)


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
            updateStates(userAcc: CGPoint(x:0.0, y:0.0), states: &cStates, center: center, pattern:MovingPattern.gas)
            for i in 0..<dConst.nCircle {
                cNodes[i]!.position = cStates[i].pos
            }

            //-----------------------
            last! = currentTime
        }
        
    }
}
