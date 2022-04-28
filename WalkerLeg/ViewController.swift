//
//  ViewController.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

struct Constants {
    static let legPhaseAngle = 140.0 * Double.pi / 180
    static let viewWidth: CGFloat = 200
}

class ViewController: UIViewController {
    
    let rearLegView = LegView()
    let frontLegView = LegView()
    var firstTouchAngle = 0.0
    var touchAngle = -1.5 { didSet { updateViewFromModel() } } // 0 to right, positive clockwise in radians

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
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        rearLegView.crankAngle = touchAngle
        frontLegView.crankAngle = -touchAngle + Constants.legPhaseAngle
    }

    // use these next two methods to allow user to turn cranks
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let firstTouch = touch.location(in: view)
            firstTouchAngle = atan2(Double(firstTouch.y - view.center.y),
                                    Double(firstTouch.x - view.center.x))
            firstTouchAngle -= touchAngle
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentTouch = touch.location(in: view)
            let currentTouchAngle = atan2(Double(currentTouch.y - view.center.y),
                                          Double(currentTouch.x - view.center.x))
            touchAngle = currentTouchAngle - firstTouchAngle
        }
    }
}

