//
//  TimerCounter.swift
//  card-game
//

import Foundation

// The contract needed to be fulfilled to use TimerCounter
protocol CallBackTimer: AnyObject {
    func roundStarted() // Make cards flip
    func cardsFlipped() // What to do after seeing cards
}

class TimeCounter {
    private var activeTimer: Timer? // The timer used
    private var targetDate: Date? // Expected timestamp when the timer is supposed to end
    private var timeRemaining: TimeInterval = 0 // Holds how much time is left when leaving the app
    
    private let roundInterval: TimeInterval
    private let flipInterval: TimeInterval
    
    private var isWaitingToFlip = false // true = need to flip card, false = need to start next round
    private var hasStarted = false // Prevent having more than one timer at the same time
    
    weak var delegate: CallBackTimer?
    
    init(roundInterval: TimeInterval = 3.0, flipInterval: TimeInterval = 2.0) {
        self.roundInterval = roundInterval
        self.flipInterval = flipInterval
    }
    
    func start() {
        stop() // Stop other timers
        hasStarted = true
        triggerRound()
        
    }
    
    private func triggerRound() {
        delegate?.roundStarted()
        
        // Prevents the game from continuing if stop() was used during the delegate
        guard hasStarted else { return }
        
        isWaitingToFlip = true // Next thing to do is flip card
        scheduleTimer(interval: flipInterval)
    }
    
    private func triggerFlip() {
        delegate?.cardsFlipped()
        
        // Prevents the game from continuing if stop() was used during the delegate
        guard hasStarted else { return }
        
        isWaitingToFlip = false // Next thing to do is start next round
        scheduleTimer(interval: roundInterval)
    }
    
    private func scheduleTimer(interval: TimeInterval) {
        activeTimer?.invalidate() // Remove existing timers
        targetDate = Date().addingTimeInterval(interval) // Calculate the expected timestamp for end of timer
        
        activeTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            // Toggle logic between triggerRound and triggerFlip using isWaitingToFlip
            guard let self = self else { return }
            if self.isWaitingToFlip {
                self.triggerFlip()
            } else {
                self.triggerRound()
            }
        }
    }
    
    func pause() {
        guard let target = targetDate else { return }
        
        // calculate the remaining time to target
        timeRemaining = target.timeIntervalSince(Date())
        // Remove the timer
        activeTimer?.invalidate()
        activeTimer = nil
        targetDate = nil
    }
    
    func resume() {
        if activeTimer != nil { return }
        
        guard hasStarted else {
            start()
            return
        }
        
        // resume the timer with timeRemaining
        if timeRemaining > 0 {
            scheduleTimer(interval: timeRemaining)
        } else {
            // Failsafe for race condition
            if isWaitingToFlip { triggerFlip() } else { triggerRound() }
        }
        
    }
    
    // Remove the timer and related properties to the timer
    func stop() {
        activeTimer?.invalidate()
        activeTimer = nil
        targetDate = nil
        timeRemaining = 0
        hasStarted = false
    }
    
}
