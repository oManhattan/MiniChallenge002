//
//  BackgroundPauseState.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import GameKit

class BackgroundPauseState: GKState {
    
    var node: SKNode
    
    public init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is BackgroundMovingState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        node.removeAllActions()
    }
}
