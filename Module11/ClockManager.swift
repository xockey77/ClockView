//
//  ClockManager.swift
//  Module11
//
//  Created by username on 19.11.2021.
//

import Foundation

class ClockManager {

    var timer = Timer()
    var timerDelegate: ClockManagerDelegate?
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timerDelegate?.updateClock()
        }
    }
    
    func stop() {
            timer.invalidate()
        }
}
