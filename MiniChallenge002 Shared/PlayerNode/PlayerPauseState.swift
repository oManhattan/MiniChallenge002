//
//  PlayerPauseState.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import GameKit

class PlayerPauseState: GKState {
    
    var node: SKNode
    
    init(node: SKNode) {
        self.node = node
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is PlayerRuningState.Type:
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
        player.physicsBody?.isResting = true
        player.physicsBody?.affectedByGravity = false
    }
}
