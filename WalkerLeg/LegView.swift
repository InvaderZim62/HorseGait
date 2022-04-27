//
//  LegView.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

struct LegConst {
    static let pointRadius: CGFloat = 3
    static let crankLength: CGFloat = 30
    static let thighLength: CGFloat = 100
    static let kneeLength: CGFloat = 84
    static let kneeDepth: CGFloat = 69
    static let shinLength: CGFloat = 120
    static let abDistance: CGFloat = 71.5
    static let hamstringAttach: CGFloat = kneeDepth
    static let footBottomLength: CGFloat = 167
    static let footTopLength: CGFloat = 135
}

class LegView: UIView {
    
    var crankAngle = -1.5 { didSet { setNeedsDisplay() } }  // 0 to right, positive clockwise in radians
    var firstTouchAngle = 0.0

    lazy var centerX = Double(self.center.x)
    lazy var centerY = Double(self.center.y)
    
    // called if bounds change
    override func layoutSubviews() {
        centerX = Double(self.center.x)
        centerY = Double(self.center.y)
        setNeedsDisplay()
    }

    // use these next two methods to allow user to rotate bar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let firstTouch = touch.location(in: self)
            firstTouchAngle = atan2(Double(firstTouch.y - self.center.y),
                                    Double(firstTouch.x - self.center.x))
            firstTouchAngle -= crankAngle
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentTouch = touch.location(in: self)
            let currentTouchAngle = atan2(Double(currentTouch.y - self.center.y),
                                          Double(currentTouch.x - self.center.x))
            crankAngle = currentTouchAngle - firstTouchAngle
        }
    }

    override func draw(_ rect: CGRect) {
        let pointA = CGPoint(x: centerX, y: centerY)
        let pointB = pointA.offsetBy(dx: -LegConst.abDistance, dy: 0)
        let pointC = pointA + CGPoint(x: LegConst.crankLength * cos(crankAngle), y: LegConst.crankLength * sin(crankAngle))
        let lengthBC = pointB.distance(to: pointC)
        let angleABC = pointB.bearing(to: pointC)
        let angleCBD = -acos((pow(lengthBC, 2) + pow(LegConst.kneeDepth, 2) - pow(LegConst.thighLength, 2)) / (2 * lengthBC * LegConst.kneeDepth))
        let angleABD = angleABC + angleCBD
        let pointD = pointB + CGPoint(x: LegConst.kneeDepth * cos(angleABD), y: LegConst.kneeDepth * sin(angleABD))
        let angleDBE = -2 * asin(0.5 * LegConst.kneeLength / LegConst.kneeDepth)
        let angleABE = angleABD + angleDBE
        let pointE = pointB + CGPoint(x: LegConst.kneeDepth * cos(angleABE), y: LegConst.kneeDepth * sin(angleABE))
        let angleCBF = acos((pow(lengthBC, 2) + pow(LegConst.hamstringAttach, 2) - pow(LegConst.thighLength, 2)) / (2 * lengthBC * LegConst.hamstringAttach))
        let angleABF = angleABC + angleCBF
        let pointF = pointB + CGPoint(x: LegConst.hamstringAttach * cos(angleABF), y: LegConst.hamstringAttach * sin(angleABF))
        let pointG = pointB + CGPoint(x: LegConst.shinLength * cos(angleABF), y: LegConst.shinLength * sin(angleABF))
        let pointH = pointE + CGPoint(x: LegConst.shinLength * cos(angleABF), y: LegConst.shinLength * sin(angleABF))
        let angleHGT = -acos((pow(LegConst.kneeDepth, 2) + pow(LegConst.footTopLength, 2) - pow(LegConst.footBottomLength, 2)) / (2 * LegConst.kneeDepth * LegConst.footTopLength))
        let angleGHT = angleABE + angleHGT
        let toePoint = pointG + CGPoint(x: LegConst.footTopLength * cos(angleGHT), y: LegConst.footTopLength * sin(angleGHT))

        UIColor.black.setFill()
        UIColor.lightGray.setFill()

        let crank = UIBezierPath()
        crank.move(to: pointA)
        crank.addLine(to: pointC)
        crank.stroke()
        
        let thigh = UIBezierPath()
        thigh.move(to: pointD)
        thigh.addLine(to: pointC)
        thigh.addLine(to: pointF)
        thigh.stroke()
        
        let knee = UIBezierPath()
        knee.move(to: pointB)
        knee.addLine(to: pointD)
        knee.addLine(to: pointE)
        knee.close()
        knee.stroke()
        knee.fill()
        
        let shin = UIBezierPath()
        shin.move(to: pointE)
        shin.addLine(to: pointH)
        shin.stroke()
        
        let hamstring = UIBezierPath()
        hamstring.move(to: pointB)
        hamstring.addLine(to: pointG)
        hamstring.stroke()
        
        let foot = UIBezierPath()
        foot.move(to: pointG)
        foot.addLine(to: pointH)
        foot.addLine(to: toePoint)
        foot.close()
        foot.stroke()
        foot.fill()
        
        drawCircleWith(center: pointA)
        drawCircleWith(center: pointB)
        drawCircleWith(center: pointC)
        drawCircleWith(center: pointD)
        drawCircleWith(center: pointE)
        drawCircleWith(center: pointF)
        drawCircleWith(center: pointG)
        drawCircleWith(center: pointH)
    }
    
    private func drawCircleWith(center: CGPoint) {
        let circle = UIBezierPath(arcCenter: center, radius: LegConst.pointRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        circle.stroke()
    }
}
