//
//  LegView.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

struct LegConst {
    static let crankLength: CGFloat = 30
    static let thighLength: CGFloat = 100
    static let kneeLength: CGFloat = 84
    static let kneeDepth: CGFloat = 69
    static let shinLength: CGFloat = 120
    static let hamstringLength: CGFloat = 71.5
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
        let pivotA =  CGPoint(x: centerX, y: centerY)
        let pivotB = pivotA.offsetBy(dx: -LegConst.hamstringLength, dy: 0)
        let pivotC = pivotA + CGPoint(x: LegConst.crankLength * cos(crankAngle), y: LegConst.crankLength * sin(crankAngle))
        let lengthBC = pivotB.distance(to: pivotC)
        let angleABC = pivotB.bearing(to: pivotC)
        let angleCBD = -acos((pow(lengthBC, 2) + pow(LegConst.kneeDepth, 2) - pow(LegConst.thighLength, 2)) / (2 * lengthBC * LegConst.kneeDepth))
        let angleABD = angleABC + angleCBD
        let pivotD = pivotB + CGPoint(x: LegConst.kneeDepth * cos(angleABD), y: LegConst.kneeDepth * sin(angleABD))
        let angleDBE = -2 * asin(0.5 * LegConst.kneeLength / LegConst.kneeDepth)
        let angleABE = angleABD + angleDBE
        let pivotE = pivotB + CGPoint(x: LegConst.kneeDepth * cos(angleABE), y: LegConst.kneeDepth * sin(angleABE))
        let angleCBF = acos((pow(lengthBC, 2) + pow(LegConst.hamstringAttach, 2) - pow(LegConst.thighLength, 2)) / (2 * lengthBC * LegConst.hamstringAttach))
        let angleABF = angleABC + angleCBF
        let pivotF = pivotB + CGPoint(x: LegConst.hamstringAttach * cos(angleABF), y: LegConst.hamstringAttach * sin(angleABF))
        let pivotG = pivotB + CGPoint(x: LegConst.shinLength * cos(angleABF), y: LegConst.shinLength * sin(angleABF))
        let pivotH = pivotE + CGPoint(x: LegConst.shinLength * cos(angleABF), y: LegConst.shinLength * sin(angleABF))
        let angleHGT = -acos((pow(LegConst.kneeDepth, 2) + pow(LegConst.footTopLength, 2) - pow(LegConst.footBottomLength, 2)) / (2 * LegConst.kneeDepth * LegConst.footTopLength))
        let angleGHT = angleABE + angleHGT
        let toePoint = pivotG + CGPoint(x: LegConst.footTopLength * cos(angleGHT), y: LegConst.footTopLength * sin(angleGHT))

        UIColor.black.setFill()
        UIColor.lightGray.setFill()

        let crank = UIBezierPath()
        crank.move(to: pivotA)
        crank.addLine(to: pivotC)
        crank.stroke()
        
        let thigh = UIBezierPath()
        thigh.move(to: pivotD)
        thigh.addLine(to: pivotC)
        thigh.addLine(to: pivotF)
        thigh.stroke()
        
        let knee = UIBezierPath()
        knee.move(to: pivotB)
        knee.addLine(to: pivotD)
        knee.addLine(to: pivotE)
        knee.close()
        knee.stroke()
        knee.fill()
        
        let shin = UIBezierPath()
        shin.move(to: pivotE)
        shin.addLine(to: pivotH)
        shin.stroke()
        
        let hamstring = UIBezierPath()
        hamstring.move(to: pivotB)
        hamstring.addLine(to: pivotG)
        hamstring.stroke()
        
        let foot = UIBezierPath()
        foot.move(to: pivotG)
        foot.addLine(to: pivotH)
        foot.addLine(to: toePoint)
        foot.close()
        foot.stroke()
        foot.fill()
        
        drawCircleWith(center: pivotA)
        drawCircleWith(center: pivotB)
        drawCircleWith(center: pivotC)
        drawCircleWith(center: pivotD)
        drawCircleWith(center: pivotE)
        drawCircleWith(center: pivotF)
        drawCircleWith(center: pivotG)
        drawCircleWith(center: pivotH)
    }
    
    private func drawCircleWith(center: CGPoint) {
        let circle = UIBezierPath(arcCenter: center, radius: 4, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        circle.stroke()
    }
}
