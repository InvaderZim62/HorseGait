//
//  ViewController.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

struct Constants {
    static let frameTime = 0.05  // seconds
    static let walkPeriod = 2.6  // seconds per step cycle
    static let viewWidth: CGFloat = 200
    static let foregroundColor = #colorLiteral(red: 0.9998988509, green: 1, blue: 0.7175351977, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 0.7775719762, green: 0.7785590291, blue: 0.5715256929, alpha: 1)
    static let pegColor = #colorLiteral(red: 0.7533841729, green: 0.7588498592, blue: 0.549562037, alpha: 1)
    static let pivotColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
}

class ViewController: UIViewController {
    
    let leftRearLegView = LegView()
    let leftFrontLegView = LegView()
    let rightRearLegView = LegView()
    let rightFrontLegView = LegView()
    var simulationTimer = Timer()
    var rotationAngle = -1.5 { didSet { updateViewFromModel() } } // 0 to right, positive clockwise in radians

    override func viewDidLoad() {
        super.viewDidLoad()
        // left legs (background)
        leftRearLegView.frame = CGRect(x: 310 - Constants.viewWidth,
                                       y: 340 - Constants.viewWidth,
                                       width: Constants.viewWidth,
                                       height: 1.17 * Constants.viewWidth)
        leftRearLegView.primaryColor = Constants.backgroundColor
        view.addSubview(leftRearLegView)
        leftFrontLegView.frame = CGRect(x: 350,
                                        y: 340 - Constants.viewWidth,
                                        width: Constants.viewWidth,
                                        height: 1.17 * Constants.viewWidth)
        leftFrontLegView.primaryColor = Constants.backgroundColor
        leftFrontLegView.layer.transform = CATransform3DMakeScale(-1, 1, 1)  // flip vertically
        view.addSubview(leftFrontLegView)
        
        // body (between legs)
        let bodyView = UIView(frame: CGRect(x: 310 - Constants.viewWidth / 2,
                                            y: 370 - Constants.viewWidth,
                                            width: Constants.viewWidth + 40,
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
        rightFrontLegView.frame = CGRect(x: 350,
                                         y: 340 - Constants.viewWidth,
                                         width: Constants.viewWidth,
                                         height: 1.17 * Constants.viewWidth)
        rightFrontLegView.primaryColor = Constants.foregroundColor
        rightFrontLegView.layer.transform = CATransform3DMakeScale(-1, 1, 1)  // flip vertically
        view.addSubview(rightFrontLegView)

        startSimulation()
    }

    private func updateViewFromModel() {
        leftRearLegView.crankAngle = rotationAngle + Double.pi
        leftFrontLegView.crankAngle = -(rotationAngle - 3 * Double.pi / 2)
        rightRearLegView.crankAngle = rotationAngle
        rightFrontLegView.crankAngle = -(rotationAngle - Double.pi / 2)
    }

    private func startSimulation() {
        simulationTimer = Timer.scheduledTimer(timeInterval: Constants.frameTime, target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil, repeats: true)
    }
    
    @objc func updateSimulation() {
        let deltaAngle = 2 * Double.pi / Constants.walkPeriod * Constants.frameTime
        rotationAngle = (rotationAngle + deltaAngle).truncatingRemainder(dividingBy: 2 * Double.pi)
    }
}

