//
//  ElementNode.swift
//  MiniChallenge002 iOS
//
//  Created by Bruno Lafayette on 01/12/22.
//

import Foundation
import SpriteKit

class ElementNode {
    
    enum TypeElement {
    case fire, nature
    }
    
    var scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    static func generateElement(type: TypeElement) -> SKSpriteNode{
        switch type{
        case .fire:
            return generateElementFire()
        case .nature:
            return genetareElementNature()
        }
    }
    
    static func genetareElementNature() -> SKSpriteNode{
        let elementNature = SKSpriteNode.init(texture: SKTexture(imageNamed: "NaturePoint"), color: .clear, size: CGSize(width: 20, height: 20))
//        let elementNature = SKSpriteNode.init(texture: nil, color: .red, size: CGSize(width: 20, height: 20))
        return elementNature
    }
    
    static func generateElementFire() -> SKSpriteNode{
        let elementFire = SKSpriteNode.init(texture: SKTexture(imageNamed: "FirePoint"), color: .clear, size: .zero)
//        let elementFire = SKSpriteNode.init(texture: nil, color: .red, size: CGSize(width: 20, height: 20))
        return elementFire
    }
    
    func generatePattern01() {
        guard let scene = self.scene as? GameScene else { return }
        
        for i in 0...2 {
            let element = ElementNode.generateElement(type: .nature)
            let size = scene.size.height * 0.07
            element.size = CGSize(width: size, height: size)
            element.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            element.position.x = (scene.frame.maxX + 10) + (CGFloat(i) * (element.size.width + 10))
            
            guard let backgroundNode = scene.childNode(withName: "background") as? BackgroundNode,
                    let physicGround = backgroundNode.childNode(withName: "physic-ground") else { return }
            
            element.position.y = physicGround.frame.maxY + 5 + (element.frame.height / 2)
            element.name = "element"
            element.physicsBody = SKPhysicsBody(texture: element.texture!,
                                                size: element.size)
            element.physicsBody?.categoryBitMask = PhysicsCategory.moeda
            element.physicsBody?.affectedByGravity = false
            element.physicsBody?.isDynamic = false
            element.physicsBody?.contactTestBitMask = PhysicsCategory.personagem

            
            scene.addChild(element)
            
            let action = SKAction.customAction(withDuration: 1/60) { node, _ in
                guard let elementName = node.name, elementName == "element" else { return }
                node.position.x -= 2
                
                if node.frame.maxX - 2 <= -10 {
                    node.removeFromParent()
                }
            }
            
            element.run(.repeatForever(action))
        }
    }
}
