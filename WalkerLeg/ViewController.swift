//
//  ViewController.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

struct Constants {
    static let frameTime = 0.05  // seconds
    static let stridePeriod = 1.8  // seconds per four-step sequence
    static let viewWidth: CGFloat = 200
    static let torsoWidth: CGFloat = 10  // separation between front and rear leg views
    static let foregroundColor = #colorLiteral(red: 0.9998988509, green: 1, blue: 0.7175351977, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 0.7775719762, green: 0.7785590291, blue: 0.5715256929, alpha: 1)
    static let pegColor = #colorLiteral(red: 0.7533841729, green: 0.7588498592, blue: 0.549562037, alpha: 1)
    static let pivotColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
}

struct Gate {
    var phase = [0.0, 1.5, 1.0, 0.5]  // left rear, left front, right rear, right front
}

class ViewController: UIViewController {
    
    let leftRearLegView = LegView()
    let leftFrontLegView = LegView()
    let rightRearLegView = LegView()
    let rightFrontLegView = LegView()
    var simulationTimer = Timer()
    var rotationAngle = -1.5 { didSet { updateViewFromModel() } } // 0 to right, positive clockwise in radians
    var gait = Gate()
    let walk = Gate(phase: [0.0, 0.5, 1.0, 1.5])
    let trot = Gate(phase: [0.0, 1.0, 1.0, 0.0])
    let canter = Gate(phase: [0.0, 0.3, 0.3, 0.9])
    let gallop = Gate(phase: [0.0, 0.6, 0.3, 0.9])

    override func viewDidLoad() {
        super.viewDidLoad()
        // left legs (background)
        leftRearLegView.frame = CGRect(x: 310 - Constants.viewWidth,
                                       y: 340 - Constants.viewWidth,
                                       width: Constants.viewWidth,
                                       height: 1.17 * Constants.viewWidth)
        leftRearLegView.primaryColor = Constants.backgroundColor
        view.addSubview(leftRearLegView)
        leftFrontLegView.frame = CGRect(x: 310 + Constants.torsoWidth,
                                        y: 340 - Constants.viewWidth,
                                        width: Constants.viewWidth,
                                        height: 1.17 * Constants.viewWidth)
        leftFrontLegView.primaryColor = Constants.backgroundColor
        leftFrontLegView.layer.transform = CATransform3DMakeScale(-1, 1, 1)  // flip vertically
        view.addSubview(leftFrontLegView)
        
        // body (between legs)
        let bodyView = UIView(frame: CGRect(x: 310 - Constants.viewWidth / 2,
                                            y: 370 - Constants.viewWidth,
                                            width: Constants.viewWidth + Constants.torsoWidth,
                                            height: 0.3 * Constants.viewWidth))
        bodyView.backgroundColor = Constants.foregroundColor
        view.addSubview(bodyView)
        
        // right legs (foreground)
        rightRearLegView.frame = CGRect(x: 310 - Constants.viewWidth,
                                        y: 340 - Constants.viewWidth,
                                        width: Constants.viewWidth,
                                        height: 1.17 * Constants.viewWidth)
        rightRearLegView.primaryColor = Constants.foregroundColor
        view.addSubview(rightRearLegView)
        rightFrontLegView.frame = CGRect(x: 310 + Constants.torsoWidth,
                                         y: 340 - Constants.viewWidth,
                                         width: Constants.viewWidth,
                                         height: 1.17 * Constants.viewWidth)
        rightFrontLegView.primaryColor = Constants.foregroundColor
        rightFrontLegView.layer.transform = CATransform3DMakeScale(-1, 1, 1)  // flip vertically
        view.addSubview(rightFrontLegView)

        gait = canter
        startSimulation()
    }
    
    private func updateViewFromModel() {
        leftRearLegView.crankAngle = rotationAngle - gait.phase[0] * Double.pi
        leftFrontLegView.crankAngle = -(rotationAngle - gait.phase[1] * Double.pi)
        rightRearLegView.crankAngle = rotationAngle - gait.phase[2] * Double.pi
        rightFrontLegView.crankAngle = -(rotationAngle - gait.phase[3] * Double.pi)
    }

    private func startSimulation() {
        simulationTimer = Timer.scheduledTimer(timeInterval: Constants.frameTime, target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil, repeats: true)
    }
    
    @objc func updateSimulation() {
        let deltaAngle = 2 * Double.pi / Constants.stridePeriod * Constants.frameTime
        rotationAngle = (rotationAngle + deltaAngle).truncatingRemainder(dividingBy: 2 * Double.pi)
    }
}

