//
//  PlayerJumpingState.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import GameKit

class PlayerJumpingState: GKState {
    
    var node: SKNode
    
    init(node: SKNode) {
        self.node = node
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is PlayerPauseState.Type, is PlayerRuningState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        node.removeAllActions()
        
        let action = SKAction.customAction(withDuration: 0.1) { node, _ in
            guard let player = node as? PlayerNode else {
                print("failed to convert player node")
                return
            }
            player.texture = SKTexture(imageNamed: "JumpingChar")
            player.physicsBody?.velocity = .zero
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10 * (player.size.height * 0.08)))
        }
        
        node.run(action)
    }
}
