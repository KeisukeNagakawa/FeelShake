//
//  tool.swift
//  shindo
//
//  Created by Nagakawa Keisuke on 2018/01/20.
//  Copyright © 2018年 Kei. All rights reserved.
//

import Foundation
import UIKit


func calcDistance(I:CGPoint, J:CGPoint) -> CGFloat {
    let dis = I - J
    return CGFloat(sqrt(Double(dis.x * dis.x + dis.y * dis.y)))
}

func cgRand() -> CGFloat {
    // return 0-1 CGFloat at random
    let rand = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    return rand
}
