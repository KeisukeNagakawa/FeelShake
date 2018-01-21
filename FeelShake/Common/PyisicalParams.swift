//
//  PhysicsConstants.swift
//  movecircle204003
//
//  Created by Nagakawa Keisuke on 2018/01/16.
//  Copyright © 2018年 Kei. All rights reserved.
//


import Foundation
import UIKit

// 物理定数
struct PhysicalConst{
    var g = CGFloat(9.8)
    var dt = CGFloat(0.01)
    var ccc = CGFloat(100.0)
    var gravPoint = CGPoint(x:30.0, y:30.0)
    var k_spr = CGFloat(100.0)
    var k_spr_start = CGFloat(200.0)
    var k_vis = CGFloat(0.1)
}
let pConst = PhysicalConst()

// 描画定数
struct DrawingConst{
    var nCircle: Int = 25
    var radRatio: CGFloat = 0.7
}
let dConst = DrawingConst()

// 速度の上限値
let velocityLimit = CGPoint(
    x: 10.0,
    y: 10.0
)


// 円の状態
struct CircleState {
    // circle state
    var acc = CGPoint(x:0.0, y:0.0)
    var vel = CGPoint(x:0.0, y:0.0)
    var dis = CGPoint(x:0.0, y:0.0)
    var pos = CGPoint(x:0.0, y:0.0)
    var rad = CGFloat(1.0)
    var col = UIColor.black
}

// 円の運動状態
enum MovingPattern:Int {
    case solid = 0
    case liquid = 1
    case gas = 2
    case start = 3
}




