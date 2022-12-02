//
//  ElementNode.swift
//  MiniChallenge002 iOS
//
//  Created by Bruno Lafayette on 01/12/22.
//

import Foundation
import SpriteKit

class ElementNode {
    
    enum TypeElement: CaseIterable {
    case fire, nature
    }
    
    var scene: SKScene
    var patterns: [[SKSpriteNode]] = []
    static var natureTexture: SKTexture = SKTexture(imageNamed: "NaturePoint")
    static var fireTexture: SKTexture = SKTexture(imageNamed: "FirePoint")
    
    init(scene: SKScene) {
        self.scene = scene
        
    }
    
    static func generateRandomElement() -> SKSpriteNode {
        switch TypeElement.allCases.randomElement()! {
        case .nature:
            return generateElement(type: .nature)
        case .fire:
            return generateElement(type: .fire)
        }
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
        let elementNature = SKSpriteNode.init(texture: self.natureTexture, color: .clear, size: CGSize(width: 20, height: 20))
        return elementNature
    }
    
    static func generateElementFire() -> SKSpriteNode{
        let elementFire = SKSpriteNode.init(texture: self.fireTexture, color: .clear, size: .zero)
        return elementFire
    }
    
    func generatePattern01() -> [SKSpriteNode] {
        guard let scene = self.scene as? GameScene else { return }
        
        for i in 0...2 {
            let element = ElementNode.generateRandomElement()
            let size = scene.size.height * 0.07
            element.size = CGSize(width: size, height: size)
            element.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            element.position.x = (scene.frame.maxX + 10) + (CGFloat(i) * (element.size.width + 20))
            
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
                node.position.x -= scene.speed
                
                if node.frame.maxX - 2 <= -10 {
                    node.removeFromParent()
                }
            }
            
            element.run(.repeatForever(action))
        }
    }
    
    func generatePattern02() -> [SKSpriteNode] {
        guard let scene = self.scene as? GameScene else { return }
        
        for i in 0...2 {
            let element = ElementNode.generateRandomElement()
            let size = scene.size.height * 0.07
            element.size = CGSize(width: size, height: size)
            element.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            element.position.x = (scene.frame.maxX + 10) + (CGFloat(i) * (element.size.width + 20))
            
            guard let backgroundNode = scene.childNode(withName: "background") as? BackgroundNode,
                    let physicGround = backgroundNode.childNode(withName: "physic-ground") else { return }
            
            element.position.y = physicGround.frame.maxY + 5 + (element.frame.height * 5)
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
                node.position.x -= scene.speed
                
                if node.frame.maxX - 2 <= -10 {
                    node.removeFromParent()
                }
            }
            
            element.run(.repeatForever(action))
        }
    }
    
    func generatePattern03() -> [SKSpriteNode] {
        guard let scene = self.scene as? GameScene else { return [] }
        
        for i in 0...1 {
            let element = ElementNode.generateElement(type: .fire)
            let size = scene.size.height * 0.07
            element.size = CGSize(width: size, height: size)
            element.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            element.position.x = (scene.frame.maxX + 10)
            
            guard let backgroundNode = scene.childNode(withName: "background") as? BackgroundNode,
                    let physicGround = backgroundNode.childNode(withName: "physic-ground") else { return }
            
            element.position.y = physicGround.frame.maxY + 20 + (element.frame.height * CGFloat(i))
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
                node.position.x -= scene.speed
                
                if node.frame.maxX - 2 <= -10 {
                    node.removeFromParent()
                }
            }
            
            element.run(.repeatForever(action))
        }
    }
}
