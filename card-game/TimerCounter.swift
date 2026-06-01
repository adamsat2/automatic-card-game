//
//  TimerCounter.swift
//  card-game
//

import Foundation

protocol CallBackTimer: AnyObject {
    func roundStarted() // Make cards flip
    func cardsFlipped() // What to do after seeing cards
}

class TimeCounter {
    private var roundTimer: Timer?
    private var flipTimer: Timer?
    private let roundInterval: TimeInterval
    private let flipInterval: TimeInterval
    
    weak var delegate: CallBackTimer?
    
    init(roundInterval: TimeInterval = 3.0, flipInterval: TimeInterval = 2.0) {
        self.roundInterval = roundInterval
        self.flipInterval = flipInterval
    }
    
    func start() {
        stop() // Stop other timers
        
        triggerRound()
        
        roundTimer = Timer.scheduledTimer(withTimeInterval: roundInterval + flipInterval, repeats: true) { [weak self] _ in self?.triggerRound()
        }
    }
    
    private func triggerRound() {
        delegate?.roundStarted()
        flipTimer = Timer.scheduledTimer(withTimeInterval: flipInterval, repeats: false) { [weak self] _ in self?.delegate?.cardsFlipped()}
    }
    
    func stop() {
        roundTimer?.invalidate()
        roundTimer = nil
        
        flipTimer?.invalidate()
        flipTimer = nil
    }
    
}
