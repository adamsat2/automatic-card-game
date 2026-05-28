//
//  TimerCounter.swift
//  card-game
//

import Foundation

protocol CallBackTimer: AnyObject {
    func tickDetected()
}

class TimeCounter {
    private var timer: Timer?
    private let interval: TimeInterval
    
    weak var delegate: CallBackTimer?
    
    init(interval: TimeInterval = 2.0) {
        self.interval = interval
    }
    
    func start() {
        stop() // Stop other timers
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in self?.tickDetected()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tickDetected() {
        delegate?.tickDetected()
    }
}
