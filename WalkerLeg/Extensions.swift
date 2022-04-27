//
//  Extensions.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
    
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
    
    // return bearing from -pi to +pi, where 0 is to the right, positive is clockwise
    func bearing(to point: CGPoint) -> Double {
        return atan2(Double(point.y - self.y), Double(point.x - self.x))
    }
}
