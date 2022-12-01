//
//  BackgroundMovingState.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import GameKit

class BackgroundMovingState: GKState {
    
    var node: SKNode
    
    public init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is BackgroundPauseState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        node.removeAllActions()
        
        let action = SKAction.customAction(withDuration: 1 / 60) { node, _ in
            guard let node = node as? BackgroundNode, let children = node.children as? [SKSpriteNode] else {
                print("failed to convert")
                return
            }
            
            for child in children {
                // Verificar se o subnode possui nome e se é diferente de "phyisic-ground"
                guard let childName = child.name, childName != "physic-ground" else { continue }
                
                // Subtrair a posição do subnode de acordo com a velocidade do node pai
                child.position.x -= node.speed
                
                // Verificar se o node vai sair da tela e reposicionar
                let delta = child.frame.maxX - node.speed
                if delta <= -10 {
                    child.position.x = (node.size.width - (node.speed * 2)) * 2
                }
            }
        }
        
        node.run(SKAction.repeatForever(action))
    }
}
