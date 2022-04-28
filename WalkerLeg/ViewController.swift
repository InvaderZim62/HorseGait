//
//  ViewController.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

struct Constants {
    static let frameTime = 0.05  // seconds
    static let walkPeriod = 2.0  // seconds per step cycle
    static let legPhaseAngle = 140.0 * Double.pi / 180
    static let viewWidth: CGFloat = 200
    static let primaryColor = #colorLiteral(red: 0.9998988509, green: 1, blue: 0.7175351977, alpha: 1)
    static let pegColor = #colorLiteral(red: 0.7533841729, green: 0.7588498592, blue: 0.549562037, alpha: 1)
}

class ViewController: UIViewController {
    
    let rearLegView = LegView()
    let frontLegView = LegView()
    var simulationTimer = Timer()
    var rotationAngle = -1.5 { didSet { updateViewFromModel() } } // 0 to right, positive clockwise in radians

    override func viewDidLoad() {
        super.viewDidLoad()
        rearLegView.frame = CGRect(x: 310 - Constants.viewWidth,
                                   y: 340 - Constants.viewWidth,
                                   width: Constants.viewWidth,
                                   height: 1.17 * Constants.viewWidth)
        frontLegView.frame = CGRect(x: 350,
                                    y: 340 - Constants.viewWidth,
                                    width: Constants.viewWidth,
                                    height: 1.17 * Constants.viewWidth)
        frontLegView.layer.transform = CATransform3DMakeScale(-1, 1, 1)  // flip vertically
        view.addSubview(rearLegView)
        view.addSubview(frontLegView)
        startSimulation()
    }

    private func updateViewFromModel() {
        rearLegView.crankAngle = rotationAngle
        frontLegView.crankAngle = -rotationAngle + Constants.legPhaseAngle
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

