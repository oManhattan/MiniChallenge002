//
//  ElementMovingState.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 02/12/22.
//

import Foundation
import SpriteKit
import GameKit

class ElementMovingState: GKState {
    var element: Element
    
    init(_ element: Element) {
        self.element = element
    }
    
    override func nextState() {
        self.element.stateMachine?.enter(ElementPauseState.self)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is ElementPauseState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        self.element.removeAllActions()
        
        let action = SKAction.customAction(withDuration: 1/60) { node, _ in
            guard let elementName = node.name, elementName == "element" else {
                print("Failed to move element")
                return
            }
            node.position.x -= node.speed
            
            if node.position.x - node.speed <= -(node.frame.width) && node.parent != nil {
                node.removeFromParent()
                self.nextState()
            }
        }
        
        self.element.run(SKAction.repeatForever(action))
    }
}
