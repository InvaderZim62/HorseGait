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
    static let closeBodyColor = #colorLiteral(red: 0.9998988509, green: 1, blue: 0.7175351977, alpha: 1)
    static let farBodyColor = #colorLiteral(red: 0.7775719762, green: 0.7785590291, blue: 0.5715256929, alpha: 1)
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
    let bodyView = UIView()
    var simulationTimer = Timer()
    var rotationAngle = -1.5 { didSet { updateViewFromModel() } } // 0 to right, positive clockwise in radians
    var gait = Gate()
    let walk = Gate(phase: [0.0, 0.5, 1.0, 1.5])
    let trot = Gate(phase: [0.0, 1.0, 1.0, 0.0])
    let canter = Gate(phase: [0.0, 0.3, 0.3, 0.9])
    let gallop = Gate(phase: [0.0, 0.6, 0.3, 0.9])

    @IBOutlet weak var horseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyView.backgroundColor = Constants.closeBodyColor
        bodyView.layer.borderColor = UIColor.black.cgColor
        bodyView.layer.borderWidth = 0.5
        bodyView.layer.cornerRadius = 10
        
        leftRearLegView.primaryColor = Constants.farBodyColor
        leftFrontLegView.primaryColor = Constants.farBodyColor
        rightRearLegView.primaryColor = Constants.closeBodyColor
        rightFrontLegView.primaryColor = Constants.closeBodyColor
        
        horseView.addSubview(leftRearLegView)
        horseView.addSubview(leftFrontLegView)
        horseView.addSubview(bodyView)
        horseView.addSubview(rightRearLegView)
        horseView.addSubview(rightFrontLegView)
    }
    
    override func viewDidLayoutSubviews() {
        bodyView.frame = CGRect(x: horseView.bounds.width / 4,
                                y: 0.12 * horseView.bounds.height,
                                width: horseView.bounds.width / 2,
                                height: horseView.bounds.height / 4)
        leftRearLegView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: horseView.bounds.width / 2,
                                       height: horseView.bounds.height)
        leftFrontLegView.frame = CGRect(x: horseView.bounds.width / 2,
                                        y: 0,
                                        width: horseView.bounds.width / 2,
                                        height: horseView.bounds.height)
        leftFrontLegView.layer.transform = CATransform3DMakeScale(-1, 1, 1)  // flip front leg vertically
        rightRearLegView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: horseView.bounds.width / 2,
                                        height: horseView.bounds.height)
        rightFrontLegView.frame = CGRect(x: horseView.bounds.width / 2,
                                         y: 0,
                                         width: horseView.bounds.width / 2,
                                         height: horseView.bounds.height)
        rightFrontLegView.layer.transform = CATransform3DMakeScale(-1, 1, 1)  // flip front leg vertically
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gait = walk
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
    
    @IBAction func gateSelected(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)
        switch buttonTitle {
        case "Walk":
            gait = walk
        case "Trot":
            gait = trot
        case "Canter":
            gait = canter
        default:
            gait = gallop
        }
    }
}

