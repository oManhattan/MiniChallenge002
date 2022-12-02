//
//  ElementPauseState.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 02/12/22.
//

import Foundation
import SpriteKit
import GameKit

class ElementPauseState: GKState {
    var element: Element
    
    init(_ element: Element) {
        self.element = element
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is ElementMovingState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        self.element.removeAllActions()
    }
}
