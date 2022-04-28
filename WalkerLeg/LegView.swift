//
//  LegView.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

class LegView: UIView {
    
    var crankCenter = CGPoint.zero
    var crankAngle = -1.5 { didSet { setNeedsDisplay() } }  // 0 to right, positive clockwise in radians
    
    private var pointRadius: CGFloat = 3
    private var reference = 0.0
    private var crankLength = 30.0
    private var thighLength = 100.0
    private var kneeLength = 84.0
    private var kneeDepth = 69.0
    private var shinLength = 120.0
    private var abDistance = 71.5
    private var hamstringAttach = 69.0
    private var footBottomLength = 167.0
    private var footTopLength = 135.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false  // makes background clear, instead of black
    }

    required init?(coder: NSCoder) {  // called for views created in storyboard
        super.init(coder: coder)
    }

    // called if bounds change
    override func layoutSubviews() {
        computeDimensions()
        setNeedsDisplay()
    }
    
    private func computeDimensions() {
        var scale = 0.0
        if bounds.height / bounds.width > 1.17 {  // extremes of leg motion are 1:1.17 (w:h)
            scale = bounds.width / 282
        } else {
            scale = bounds.height / 332
        }
        crankCenter = CGPoint(x: bounds.width - 46 * scale, y: 82 * scale)
        pointRadius = 5 * scale
        crankLength = 30 * scale
        thighLength = 100 * scale
        kneeLength = 84 * scale
        kneeDepth = 69 * scale
        shinLength = 120 * scale
        abDistance = 71.5 * scale
        hamstringAttach = 69 * scale
        footBottomLength = 167 * scale
        footTopLength = 135 * scale
    }

    override func draw(_ rect: CGRect) {
        let pointA = crankCenter
        let pointB = pointA.offsetBy(dx: -abDistance, dy: 0)
        let pointC = pointA + CGPoint(x: crankLength * cos(crankAngle), y: crankLength * sin(crankAngle))
        let lengthBC = pointB.distance(to: pointC)
        let angleABC = pointB.bearing(to: pointC)
        let angleCBD = -acos((pow(lengthBC, 2) + pow(kneeDepth, 2) - pow(thighLength, 2)) / (2 * lengthBC * kneeDepth))
        let angleABD = angleABC + angleCBD
        let pointD = pointB + CGPoint(x: kneeDepth * cos(angleABD), y: kneeDepth * sin(angleABD))
        let angleDBE = -2 * asin(0.5 * kneeLength / kneeDepth)
        let angleABE = angleABD + angleDBE
        let pointE = pointB + CGPoint(x: kneeDepth * cos(angleABE), y: kneeDepth * sin(angleABE))
        let angleCBF = acos((pow(lengthBC, 2) + pow(hamstringAttach, 2) - pow(thighLength, 2)) / (2 * lengthBC * hamstringAttach))
        let angleABF = angleABC + angleCBF
        let pointF = pointB + CGPoint(x: hamstringAttach * cos(angleABF), y: hamstringAttach * sin(angleABF))
        let pointG = pointB + CGPoint(x: shinLength * cos(angleABF), y: shinLength * sin(angleABF))
        let pointH = pointE + CGPoint(x: shinLength * cos(angleABF), y: shinLength * sin(angleABF))
        let angleHGT = -acos((pow(kneeDepth, 2) + pow(footTopLength, 2) - pow(footBottomLength, 2)) / (2 * kneeDepth * footTopLength))
        let angleGHT = angleABE + angleHGT
        let toePoint = pointG + CGPoint(x: footTopLength * cos(angleGHT), y: footTopLength * sin(angleGHT))
        
        let outlineWidth = 7.0
        let lineWidth = 6.0

        let crank = UIBezierPath()
        crank.move(to: pointA)
        crank.addLine(to: pointC)
        crank.lineWidth = outlineWidth
        UIColor.black.setStroke()
        crank.stroke()
        crank.lineWidth = lineWidth
        Constants.primaryColor.setStroke()
        crank.stroke()

        drawCircleWith(center: pointA)

        let thigh = UIBezierPath()
        thigh.move(to: pointD)
        thigh.addLine(to: pointC)
        thigh.addLine(to: pointF)
        thigh.lineWidth = outlineWidth
        UIColor.black.setStroke()
        thigh.stroke()
        thigh.lineWidth = lineWidth
        Constants.primaryColor.setStroke()
        thigh.stroke()

        let knee = UIBezierPath()
        knee.move(to: pointB)
        knee.addLine(to: pointD)
        knee.addLine(to: pointE)
        knee.close()
        UIColor.black.setStroke()
        knee.stroke()
        Constants.primaryColor.setFill()
        knee.fill()

        let shin = UIBezierPath()
        shin.move(to: pointE)
        shin.addLine(to: pointH)
        shin.lineWidth = outlineWidth
        UIColor.black.setStroke()
        shin.stroke()
        shin.lineWidth = lineWidth
        Constants.primaryColor.setStroke()
        shin.stroke()

        let hamstring = UIBezierPath()
        hamstring.move(to: pointB)
        hamstring.addLine(to: pointG)
        hamstring.lineWidth = outlineWidth
        UIColor.black.setStroke()
        hamstring.stroke()
        hamstring.lineWidth = lineWidth
        Constants.primaryColor.setStroke()
        hamstring.stroke()

        let foot = UIBezierPath()
        foot.move(to: pointG)
        foot.addLine(to: pointH)
        foot.addLine(to: toePoint)
        foot.close()
        UIColor.black.setStroke()
        foot.stroke()
        Constants.primaryColor.setFill()
        foot.fill()

        drawCircleWith(center: pointB)
        drawCircleWith(center: pointC)
        drawCircleWith(center: pointD)
        drawCircleWith(center: pointE)
        drawCircleWith(center: pointF)
        drawCircleWith(center: pointG)
        drawCircleWith(center: pointH)
    }
    
    private func drawCircleWith(center: CGPoint) {
        let circle = UIBezierPath(arcCenter: center, radius: pointRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        UIColor.black.setStroke()
        circle.stroke()
        Constants.pegColor.setFill()
        circle.fill()
    }
}
