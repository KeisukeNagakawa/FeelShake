//
//  extension.swift
//  movecircle204003
//
//  Created by Nagakawa Keisuke on 2018/01/14.
//  Copyright © 2018年 Kei. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint{
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        let x = left.x + right.x
        let y = left.y + right.y
        return CGPoint(x:x, y:y)
    }
    static func + (left: CGPoint, right: CGFloat) -> CGPoint {
        let x = left.x + right
        let y = left.y + right
        return CGPoint(x:x, y:y)
    }
    static func + (left: CGFloat, right: CGPoint) -> CGPoint {
        let x = left + right.x
        let y = left + right.y
        return CGPoint(x:x, y:y)
    }
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        let x = left.x - right.x
        let y = left.y - right.y
        return CGPoint(x:x, y:y)
    }
    static func - (left: CGPoint, right: CGFloat) -> CGPoint {
        let x = left.x - right
        let y = left.y - right
        return CGPoint(x:x, y:y)
    }
    static func - (left: CGFloat, right: CGPoint) -> CGPoint {
        let x = left - right.x
        let y = left - right.y
        return CGPoint(x:x, y:y)
    }
    static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        let x = left.x * right.x
        let y = left.y * right.y
        return CGPoint(x:x, y:y)
    }
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        let x = left.x * right
        let y = left.y * right
        return CGPoint(x:x, y:y)
    }
    static func * (left: CGFloat, right: CGPoint) -> CGPoint {
        let x = left * right.x
        let y = left * right.y
        return CGPoint(x:x, y:y)
    }
    static func / (left: CGPoint, right: CGPoint) -> CGPoint {
        let x = left.x / right.x
        let y = left.y / right.y
        return CGPoint(x:x, y:y)
    }
    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        let x = left.x / right
        let y = left.y / right
        return CGPoint(x:x, y:y)
    }
    static func / (left: CGFloat, right: CGPoint) -> CGPoint {
        let x = left / right.x
        let y = left / right.y
        return CGPoint(x:x, y:y)
    }
}



