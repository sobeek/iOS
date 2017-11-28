//
//  Line.swift
//  TouchTracker
//
//  Created by Павел Собянин on 03.11.17.
//  Copyright © 2017 pavel.sobyanin. All rights reserved.
//

import Foundation
import CoreGraphics

struct Line {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    //var drawingVelocity: Double = 0
    
    func length() -> CGFloat {
        return sqrt(pow(self.end.x - self.begin.x, 2) + pow(self.end.y - self.begin.y, 2))
    }
    
    func angle() -> CGFloat {
        //new virtual vector: (line.begin.x + 1, line.begin.y); its length is 1
        let scalarProduct = self.end.x - self.begin.x
        let len = self.length()
        let pi = CGFloat.pi
        //print(pi)
        return (acos(scalarProduct/len) * (180/pi))
    }
}
