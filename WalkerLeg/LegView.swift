//
//  LegView.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

class LegView: UIView {
    
    var primaryColor = UIColor.yellow
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
//        backgroundColor = .yellow.withAlphaComponent(0.5)
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
        // pick drawing scale to just fit within most-limited dimension
        if bounds.height / bounds.width > 1.17 {  // ratio of full leg motion is 1:1.17 (w:h)
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

        drawThickLinesWithOutlinesFromPoints([pointA, pointC])  // crank
        drawCircleWith(center: pointA, ofColor: Constants.pivotColor)  // crank pivot (draw before rest of parts, so they appear on top)
        drawThickLinesWithOutlinesFromPoints([pointD, pointC, pointF])  // thigh
        drawShapeFromPoints([pointB, pointD, pointE])  // knee
        drawThickLinesWithOutlinesFromPoints([pointE, pointH])  // shin
        drawThickLinesWithOutlinesFromPoints([pointB, pointG])  // hamstring
        drawShapeFromPoints([pointG, pointH, toePoint])  // foot

        drawCircleWith(center: pointB, ofColor: Constants.pivotColor)
        drawCircleWith(center: pointC, ofColor: Constants.pegColor)
        drawCircleWith(center: pointD, ofColor: Constants.pegColor)
        drawCircleWith(center: pointE, ofColor: Constants.pegColor)
        drawCircleWith(center: pointF, ofColor: Constants.pegColor)
        drawCircleWith(center: pointG, ofColor: Constants.pegColor)
        drawCircleWith(center: pointH, ofColor: Constants.pegColor)
    }
    
    private func drawThickLinesWithOutlinesFromPoints(_ points: [CGPoint]) {
        let lines = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                lines.move(to: point)
            } else {
                lines.addLine(to: point)
            }
        }
        lines.lineWidth = 7
        UIColor.black.setStroke()
        lines.stroke()
        lines.lineWidth = 6
        primaryColor.setStroke()
        lines.stroke()
    }
    
    private func drawShapeFromPoints(_ points: [CGPoint]) {
        let shape = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                shape.move(to: point)
            } else {
                shape.addLine(to: point)
            }
        }
        shape.close()
        UIColor.black.setStroke()
        shape.stroke()
        primaryColor.setFill()
        shape.fill()
    }

    private func drawCircleWith(center: CGPoint, ofColor color: UIColor) {
        let circle = UIBezierPath(arcCenter: center, radius: pointRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        UIColor.black.setStroke()
        circle.stroke()
        color.setFill()
        circle.fill()
    }
}
