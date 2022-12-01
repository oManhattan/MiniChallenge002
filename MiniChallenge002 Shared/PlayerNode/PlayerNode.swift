//
//  PlayerNode.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import SpriteKit
import GameKit

class PlayerNode: SKSpriteNode {
    
    var stateMachine: GKStateMachine?
    
    init(size: CGSize) {
        super.init(
            texture: SKTexture(imageNamed: "MovingChar0"),
            color: .red,
            size: CGSize(width: size.width * 0.05, height: size.height * 0.2))
        
        setUpNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    func setUpNode() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 1
        
        self.stateMachine = GKStateMachine(states: [PlayerPauseState(node: self), PlayerRuningState(node: self), PlayerJumpingState(node: self)])
        
        let physicsBody = SKPhysicsBody(texture: self.texture!,
                                        size: self.size)
        
        physicsBody.restitution = 0
        physicsBody.allowsRotation = false
        physicsBody.affectedByGravity = true
        physicsBody.isDynamic = true
        physicsBody.collisionBitMask = 0b0001
        physicsBody.mass = 10
        
        self.physicsBody = physicsBody
    }
}
