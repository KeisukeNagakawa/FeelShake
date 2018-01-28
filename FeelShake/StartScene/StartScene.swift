
//
//  StartScene.swift
//  shindo
//
//  Created by Nagakawa Keisuke on 2018/01/20.
//  Copyright © 2018年 Kei. All rights reserved.
//

import Foundation
import SpriteKit


// メインシーン。代理人としても利用する
class StartScene: SKScene, StartSceneDelegateProtocol{
    
    // 他の場所で変更されたくないのでprivateにしておく
    private var circle : SKShapeNode?
    private var cNodes : [SKShapeNode?] = []
    private var cStates:[CircleState] = []
    private var last:Double?
    var center = CGPoint(x:0.0, y:0.0)
    var circleCenter  = CGPoint(x:0.0, y:0.0)

    override func didMove(to view: SKView) {
        print("startScene:\(self.frame.minX), \(self.frame.maxX)")
        // 初期設定
        self.backgroundColor = bgColor
        self.center = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.circleCenter = CGPoint(
            x:self.frame.midX,
            y:0.5*self.frame.midY + 0.5*self.frame.maxY)
        let startObj = StartSceneObjects(frame: self.frame)
        startObj.delegate = self

        // 円のオブジェを追加
        circle = startObj.CreateStartSceneCircleNode()
        self.addChild(self.circle!)
        cStates = createCircleStates(num:1)
        

        // タイトルを追加
        let titleX = self.frame.midX
        let titleY = 0.5 * self.frame.midY + 0.5 * self.frame.minY
        startObj.drawTitle( text: "絶対震度感覚",position: CGPoint(x:titleX, y:titleY))

        
        // トレーニングボタン関係
        let d = self.frame.maxX - self.frame.midX
        let menuY = self.frame.midY*0.15+self.frame.minY*0.85
        startObj.drawButton(
            withText: "トレーニング",
            position: CGPoint( x: self.frame.midX - d * 0.4, y: menuY),
            moveTo: TrainScene(size: self.scene!.size))

        startObj.drawButton(
            withText: "チャレンジ",
            position: CGPoint( x: self.frame.midX + d * 0.4, y: menuY),
            moveTo: TrainScene(size: self.scene!.size)
        )


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
            updateStates(
                states: &cStates,
                center: self.circleCenter,
                pattern:MovingPattern.start)
            self.circle!.position = cStates[0].pos
            
            //-----------------------
            last! = currentTime
        }
        
    }
}



