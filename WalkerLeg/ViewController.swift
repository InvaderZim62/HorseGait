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

enum Gate {
    case walk
    case trot
    case canter
    case gallop
}

struct Sim {
    var gate = Gate.walk
    var phase = [0.0, 1.5, 1.0, 0.5]  // left rear, left front, right rear, right front
}

class ViewController: UIViewController {
    
    let horseView = UIView()
    let bodyView = UIView()
    let leftRearLegView = LegView()
    let leftFrontLegView = LegView()
    let rightRearLegView = LegView()
    let rightFrontLegView = LegView()
    var simulationTimer = Timer()
    var rotationAngle = 0.0 { didSet { updateViewFromModel() } } // 0 to right, positive clockwise in radians
    var horseHeight = 0.0
    var sim = Sim()
    let walk = Sim(gate: .walk, phase: [0.0, 0.5, 1.0, 1.5])
    let trot = Sim(gate: .trot, phase: [0.0, 1.0, 1.0, 0.0])
    let canter = Sim(gate: .canter, phase: [0.0, 0.3, 0.3, 0.9])
    let gallop = Sim(gate: .gallop, phase: [0.0, 0.6, 0.3, 0.9])

    @IBOutlet var gaitButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sim = walk
        bodyView.backgroundColor = Constants.closeBodyColor
        bodyView.layer.borderColor = UIColor.black.cgColor
        bodyView.layer.borderWidth = 0.5
        bodyView.layer.cornerRadius = 10
        
        leftRearLegView.bodyColor = Constants.farBodyColor
        leftFrontLegView.bodyColor = Constants.farBodyColor
        rightRearLegView.bodyColor = Constants.closeBodyColor
        rightFrontLegView.bodyColor = Constants.closeBodyColor
        
        view.addSubview(horseView)
        horseView.addSubview(leftRearLegView)
        horseView.addSubview(leftFrontLegView)
        horseView.addSubview(bodyView)
        horseView.addSubview(rightRearLegView)
        horseView.addSubview(rightFrontLegView)
    }
    
    override func viewDidLayoutSubviews() {
        horseView.frame = CGRect(x: 0, y: 0, width: 0.6 * view.bounds.width, height: 0.34 * view.bounds.width)
        horseHeight = 0.17 * view.bounds.width
        horseView.center = CGPoint(x: 0.5 * view.bounds.width, y: view.bounds.height - horseHeight)
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
        underlineTextForButton(gaitButtons[0], true)
        startSimulation()
    }
    
    private func updateViewFromModel() {
        leftRearLegView.crankAngle = rotationAngle - sim.phase[0] * Double.pi
        leftFrontLegView.crankAngle = -(rotationAngle - sim.phase[1] * Double.pi)
        rightRearLegView.crankAngle = rotationAngle - sim.phase[2] * Double.pi
        rightFrontLegView.crankAngle = -(rotationAngle - sim.phase[3] * Double.pi)
    }

    private func startSimulation() {
        simulationTimer = Timer.scheduledTimer(timeInterval: Constants.frameTime, target: self,
                                               selector: #selector(updateSimulation),
                                               userInfo: nil, repeats: true)
    }
    
    @objc func updateSimulation() {
        let deltaAngle = 2 * Double.pi / Constants.stridePeriod * Constants.frameTime
        rotationAngle = (rotationAngle + deltaAngle).truncatingRemainder(dividingBy: 2 * Double.pi)
        var deltaHeight = 0.0
        switch sim.gate {
        case .trot:
            deltaHeight = 4 * sin(2 * rotationAngle)
        case .canter, .gallop:
            deltaHeight = 6 * sin(rotationAngle)
        default:
            break
        }
        horseView.center.y = view.bounds.height - horseHeight + deltaHeight
    }
    
    private func underlineTextForButton(_ button: UIButton, _ underline: Bool) {
        let buttonText = button.titleLabel?.text
        let attributedText = NSAttributedString(string: buttonText!,
                                                attributes: [.foregroundColor: view.tintColor!,
                                                             .underlineStyle: underline ? NSUnderlineStyle.single.rawValue : 0])
        button.setAttributedTitle(attributedText, for: .normal)
    }
    
    @IBAction func gateSelected(_ sender: UIButton) {
        let buttonText = sender.titleLabel?.text
        switch buttonText {
        case "Walk":
            sim = walk
        case "Trot":
            sim = trot
        case "Canter":
            sim = canter
        default:
            sim = gallop
        }
        gaitButtons.forEach { underlineTextForButton($0, false) }  // clear all underlines
        underlineTextForButton(sender, true)
    }
}

