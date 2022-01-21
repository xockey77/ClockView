//
//  ViewController.swift
//  Module11
//
//  Created by username on 14.11.2021.
//

import UIKit

protocol ClockManagerDelegate {
    func updateClock()
}

protocol SimpleSegmentedControlDelegate {
    var selectedIndex: Int {get set}
}

protocol ShadowedButtonDelegate {
    func buttonPressed(_ sender: ShadowedButton)
}

class ViewController: UIViewController, ShadowedButtonDelegate {
    
    var clockManager = ClockManager()
    var clockIsRunning: Bool = false
    
    @IBOutlet weak var clock: ClockView!
    
    @IBOutlet weak var simpleSegmentedControl: SimpleSegmentedControl!
    
    @IBOutlet weak var shadowedButton: ShadowedButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        clockManager.timerDelegate = self
        simpleSegmentedControl.delegate = self
        shadowedButton.delegate = self
        shadowedButton.setTitle("START")
        shadowedButton.setTextColor(to: .systemGray)
    }

/* альтернатива делегату для включения/выключения тени с помощью SimpleSegmentedControl
     
    @IBAction func simpleSegmentValueChanged(_ sender: SimpleSegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            clock.hasShadow = true
        case 1:
            clock.hasShadow = false
        default:
            break
        }
    }
*/

    func buttonPressed(_ sender: ShadowedButton) {
        if (clockIsRunning) {
            clockManager.stop()
            clockIsRunning = false
            shadowedButton.setTitle("START")
        }
        else {
            clockManager.start()
            clockIsRunning = true
            shadowedButton.setTitle("STOP")
        }
    }
}

extension ViewController: ClockManagerDelegate {
    func updateClock() {
        clock.setClock(to: Date())
    }
}

extension ViewController: SimpleSegmentedControlDelegate {
    var selectedIndex: Int {
        get {
            return clock.hasShadow == true ? 0 : 1
        }
        set {
            clock.hasShadow = newValue == 0 ? true : false
        }
    }
}

