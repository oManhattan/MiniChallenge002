//
//  PlayerRuningState.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import GameKit

class PlayerRuningState: GKState {
    
    var node: SKNode
    
    init(node: SKNode) {
        self.node = node
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is PlayerPauseState.Type, is PlayerJumpingState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        node.removeAllActions()
        
        guard let player = self.node as? PlayerNode else {
            print("failed to convert player node")
            return
        }
        player.physicsBody?.affectedByGravity = true
        player.run(.repeatForever(.animate(with: .init(format: "MovingChar%@", frameCount: 0...1), timePerFrame: 0.1)))
    }
}
