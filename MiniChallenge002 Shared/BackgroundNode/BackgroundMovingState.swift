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
            guard let node = node as? BackgroundNode else {
                print("Failed to convert SKNode to BackgroundNode")
                return
            }
            
            for child in node.children {
                // Verificar se o subnode possui nome e se é diferente de "phyisic-ground"
                guard let child = child as? SKSpriteNode,
                      let childName = child.name,
                      childName != "physic-ground",
                      childName != "progress-bar"
                else {
                    continue
                }
                
                if childName.contains("background") && child.position.x > node.frame.maxX {
                    let progress = node.progressBar?.progressPercent ?? 0
                    if progress > 0.75 {
                        child.texture = SKTexture(imageNamed: "Background3")
                    } else if progress <= 0.75 && progress > 0.50 {
                        child.texture = SKTexture(imageNamed: "Background2")
                    } else if progress <= 0.50 && progress > 0.25 {
                        child.texture = SKTexture(imageNamed: "Background1")
                    } else if progress <= 0.25 {
                        child.texture = SKTexture(imageNamed: "Background0")
                    }
                }
                
                
                // Subtrair a posição do subnode de acordo com a velocidade do node pai
                child.position.x -= node.speed
                
                // Verificar se o node vai sair da tela e reposicionar
                let delta = child.frame.maxX - node.speed
                if delta <= -10 {
                    child.position.x = ((self.node.frame.maxX - 10) * 2) - node.speed
                }
            }
        }
        
        node.run(SKAction.repeatForever(action))
    }
}
