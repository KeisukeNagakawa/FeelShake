//
//  aihbel.swift
//  shindo
//
//  Created by Nagakawa Keisuke on 2018/01/18.
//  Copyright © 2018年 Kei. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


func createCircleStates() -> [CircleState]{
    /*
     複数の円の状態を作る
     */
    // repeatingで入れないこと！！
    var res:[CircleState] = []
    for _ in 0..<dConst.nCircle {
        res.append(
            CircleState(
                acc: CGPoint(x:0.0, y:0.0),
                vel: CGPoint(x:CGFloat(arc4random_uniform(10))/1.0-CGFloat(4.5), y:CGFloat(arc4random_uniform(10))/1.0-CGFloat(4.5)),
                dis: CGPoint(x:0.0, y:0.0),
                pos: CGPoint(x:0.0, y:0.0),
                rad: CGFloat(10.0),
                col: UIColor.black
            )
        )
    }
    return res
}


func updateState(userAcc:CGPoint, state:CircleState, center:CGPoint, pattern:MovingPattern, states:[CircleState])->CircleState{
    /*
     ある1つの円のStateを更新する。
     */
    var updatedAcc = CGPoint(x:0.0, y:0.0)
    var updatedVel, updatedDis, updatedPos: CGPoint
    var updatedRad: CGFloat
    var updatedCol: UIColor
    switch pattern {
    case MovingPattern.gas:
        /* 中央からのバネ力 + ランダムな力 + 速度キャップ */
        updatedAcc = calcAcc_Spring_Vis_Random(withDisplacement: state.dis, vel:state.vel)
        updatedVel = integralAcc(withOldDis: state.dis, oldVel: state.vel, curAcc: updatedAcc)
        updatedDis = integralVel(withOldDis: state.dis , oldVel: state.vel, curAcc: updatedAcc)
        updatedPos = disToPos(center:center, dis: updatedDis)
        updatedRad = state.rad
        updatedCol = state.col
        capping(vector: &updatedVel, velocityLimit: velocityLimit)
    case MovingPattern.liquid:
        updatedAcc = LJPotentialForce(forCircle:state , fromCircles: states)
        updatedVel = LJPotentialDis(forPoint: state.pos, ofVelocity: state.vel, withOldForce: state.acc)
        updatedDis = LJPotentialDis(forPoint: state.pos, ofVelocity: state.vel, withOldForce: state.acc)
        updatedPos = disToPos(center:center, dis: updatedDis)
        updatedRad = state.rad
        updatedCol = state.col
        capping(vector: &updatedVel, velocityLimit: velocityLimit)

 
    case MovingPattern.start:
        updatedAcc = CGPoint(
            x:(CGFloat(Float(arc4random_uniform(10))/Float(10.0)-Float(4.5)) - pConst.k_spr_start * state.dis.x)*0.5,
            y:(CGFloat(Float(arc4random_uniform(10))/Float(10.0)-Float(4.5)) - pConst.k_spr_start * state.dis.y)*0.5
        )
        randomizeDirection(ofVector: &updatedAcc)
        updatedVel = integralAcc(withOldDis: state.dis, oldVel: state.vel, curAcc: updatedAcc)
        updatedDis = integralVel(withOldDis: state.dis , oldVel: state.vel, curAcc: updatedAcc)
        updatedDis = CGPoint(
            x:(cgRand()-0.5)*0.1,
            y:(cgRand()-0.5)*0.1
        )
        updatedPos = disToPos(center:center, dis: updatedDis)
        updatedRad = state.rad
        updatedCol = state.col
        capping(vector: &updatedVel, velocityLimit: 0.1*velocityLimit)


    default:
        updatedAcc = CGPoint(x:0.0, y:0.0)
        updatedVel = CGPoint(x:0.0, y:0.0)
        updatedPos = CGPoint(x:0.0, y:0.0)
        updatedDis = CGPoint(x:0.0, y:0.0)
        updatedCol = UIColor.black
        updatedRad = CGFloat(0.0)
        print("error: movingPattern is invalid")
    }
    // 結果を格納するための状態（加速度は上で定義、それ以外を下で定義）
    let resState = CircleState(
        acc: updatedAcc,
        vel: updatedVel,
        dis: updatedDis,
        pos: updatedPos,
        rad: updatedRad,
        col: updatedCol
    )
    return resState
}

func updateStates(userAcc:CGPoint, states: inout [CircleState],  center:CGPoint, pattern: MovingPattern){
    /*
     複数の円の座標を更新するupdateStateのラッパー
     */
    //var result = [CircleState](repeating: state, count: states.count)
    let oldStates = states
    for i in 0..<(states.count){
        states[i] = updateState(userAcc:userAcc, state:states[i], center:center, pattern: pattern, states: oldStates)
    }
}



//------------------
// other tools
//------------------
func capping(vector v: inout CGPoint, velocityLimit c: CGPoint) {
    if abs(v.x) > c.x {
        if v.x > CGFloat(0.0) {
            v.x = c.x
        } else {
            v.x = CGFloat(-1.0) * c.x
        }
    }
    if abs(v.y) > c.y {
        if v.y > CGFloat(0.0) {
            v.y = c.y
        } else {
            v.y = CGFloat(-1.0) * c.y
        }
    }
    
    
}

func calcAcc_Spring_Vis_Random(withDisplacement dis:CGPoint, vel: CGPoint)->CGPoint {
    // 質点に加わる力
    var updatedAcc = CGFloat(-1.0) * pConst.k_spr * dis - pConst.k_vis * vel
    randomizeDirection(ofVector: &updatedAcc)
    return updatedAcc
}

func randomizeDirection(ofVector vec: inout CGPoint) {
    /* 与えられたベクトルの方向をランダムな角度だけ回転させる。*/
    // 2Piの中からランダムな値を生成
    let randomTheta = CGFloat(arc4random_uniform(10))/10.0 * CGFloat(2.0) * CGFloat.pi
    // 80%の確率でランダムにさせる。
    if arc4random_uniform(1000)>800 {
        vec = CGPoint(
            x: CGFloat(cos(randomTheta))*vec.x - CGFloat(sin(randomTheta)) * vec.y,
            y: CGFloat(sin(randomTheta))*vec.x + CGFloat(cos(randomTheta)) * vec.y)
    }
}





func integralAcc(withOldDis dis:CGPoint, oldVel: CGPoint, curAcc: CGPoint) -> CGPoint {
    // 加速度を積分する
    return oldVel + pConst.dt * curAcc
}

func integralVel(withOldDis oldDis: CGPoint, oldVel: CGPoint, curAcc: CGPoint) -> CGPoint {
    // 速度を積分する
    let dt = pConst.dt
    return CGFloat(0.5) * dt * dt * curAcc + dt * oldVel + oldDis
}

func disToPos(center:CGPoint, dis:CGPoint) -> CGPoint{
    // 変異からポジションを生成
    return center + CGFloat(100.0) * dis
}





// Liquid
func LJPotentialForce_ij(I:CGPoint, J:CGPoint) -> CGPoint {
    /*
     I番とJ番のLJポテンシャルを計算。i==jの場合0になる
     */
    let rij = calcDistance(I:I, J:J)
    let Fij: CGPoint
    if rij != CGFloat(0.0) {
        let term1 = CGFloat(12.0 / pow(Double(rij), Double(14.0)))
        let term2 = CGFloat(12.0 / pow(Double(rij), Double(8.0)))
        Fij = (term1 - term2) * ( I - J )
    }else {
        Fij = CGPoint(x:0.0, y:0.0)
    }
    
    return Fij
}

func LJPotentialForce(forCircle II:CircleState, fromCircles GG:[CircleState]) -> CGPoint {
    /*
     ある点に対する力（実質加速度）を計算する
     !! Gは更新させる前のものを利用すること
     参考：http://ceram.material.tohoku.ac.jp/~takamura/class/sozo/node20.html
     */
    let I = II.pos
    let G = GG.map{ $0.pos }
    let n = G.count
    var F = CGPoint(x:0.0, y:0.0)
    for i in 0..<n {
        F = F + LJPotentialForce_ij(I: I, J: G[i])
    }
    // 2重でカウントしているので半分にする。
    F = F * 0.5
    return F
}

func LJPotentialDis(forPoint I: CGPoint, ofVelocity vel: CGPoint,  withOldForce F: CGPoint) -> CGPoint {
    /*
     ある点に対する更新された変位 速度ベルレのアルゴリズム
     ・OldForceを使うこと！
     */

    return I + pConst.dt * vel + 0.5 * F * pConst.dt * pConst.dt
}

func LJPotentialVel(forPoint I: CGPoint, ofVelocity vel: CGPoint,  withOldForce Fold: CGFloat, withNewForce Fnew: CGFloat)->CGPoint {
    /* ある点に対する更新された速度 速度ベルレのアルゴリズム */
    return vel + 0.5 * pConst.dt * (Fnew + Fold)
}


func calcAcc_LJPotential_Random(withDisplacement dis:CGPoint, vel: CGPoint)->CGPoint {
    // 質点に加わる力
    var updatedAcc = CGFloat(-1.0) * pConst.k_spr * dis - pConst.k_vis * vel
    randomizeDirection(ofVector: &updatedAcc)
    return updatedAcc
}








