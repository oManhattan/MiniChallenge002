//
//  Element.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 01/12/22.
//

import Foundation
import SpriteKit
import GameKit

class Element: SKSpriteNode, SKStateNode {
    
    var stateMachine: GKStateMachine?
    var type: ElementType
    var initialPosition: CGPoint = .zero
    
    init(type: ElementType, texture: SKTexture, size: CGSize) {
        self.type = type
        super.init(texture: texture, color: .clear, size: size)
        
        self.stateMachine = GKStateMachine(states: [ElementMovingState(self), ElementPauseState(self)])
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.speed = 2
        self.name = "element"
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.moeda
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.contactTestBitMask = PhysicsCategory.personagem
    }
    
    func setPosition(position: CGPoint) {
        self.initialPosition = position
        self.position = position
    }
    
    func resetToInitialPosition() {
        self.position = self.initialPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        return Element(type: self.type, texture: self.texture!, size: self.size)
    }
}
