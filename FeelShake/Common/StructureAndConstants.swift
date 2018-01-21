//
//  PhysicsConstants.swift
//  movecircle204003
//
//  Created by Nagakawa Keisuke on 2018/01/16.
//  Copyright © 2018年 Kei. All rights reserved.
//


import Foundation
import UIKit

// ---------------
// STRUCTURE
// ---------------
struct PhysicalConst{
    var g:CGFloat
    var dt:CGFloat
    var ccc:CGFloat
    var gravPoint:CGPoint
    var k_spr:CGFloat
    var k_spr_start: CGFloat
    var k_vis:CGFloat
    
}


struct DrawingConst{
    // 描画に関する定数
    var nCircle: Int
    var radRatio: CGFloat
    
}


struct CircleState {
    // circle state
    var acc: CGPoint
    var vel: CGPoint
    var dis: CGPoint
    var pos: CGPoint
    var rad: CGFloat
    var col: UIColor
}
// ---------------
// enumurate
// ---------------

enum MovingPattern:Int {
    case solid = 0
    case liquid = 1
    case gas = 2
    case start = 3
}


// ---------------
// Constant
// ---------------

let pConst = PhysicalConst(
    g:CGFloat(9.8),
    dt:CGFloat(0.01),
    ccc:CGFloat(100.0),
    gravPoint: CGPoint(x:30.0, y:30.0),
    k_spr: CGFloat(100.0),
    k_spr_start: CGFloat(200.0),
    k_vis: CGFloat(0.1)
)

let dConst =  DrawingConst(
    nCircle: 25,
    radRatio: 0.7
)

let velocityLimit = CGPoint(
    x: 10.0,
    y: 10.0
)


let font:String = "HiraKakuProN-W6"

let bgColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
