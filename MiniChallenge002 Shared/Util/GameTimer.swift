//
//  GameTimer.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 04/12/22.
//

import Foundation

class GameTimer {
    
    private var timer: Timer
    private let timeInterval: Double
    private var action: () -> Void
    
    public init(startValue: Double, action: @escaping () -> Void) {
        self.timer = Timer()
        self.timeInterval = startValue
        self.action = action
    }
    
    public func start() {
        self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
    }
    
    public func pause() {
        self.timer.invalidate()
    }
    
    @objc
    private func timerAction(_ sender: Timer) {
        self.action()
    }
}
