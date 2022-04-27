//
//  ViewController.swift
//  WalkerLeg
//
//  Created by Phil Stern on 4/27/22.
//

import UIKit

class ViewController: UIViewController {
    
    let legView = LegView()

    override func viewDidLoad() {
        super.viewDidLoad()
        legView.frame = CGRect(x: 20, y: 100, width: 300, height: 350)
        view.addSubview(legView)
    }
}

