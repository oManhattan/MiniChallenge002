//
//  ElementNode.swift
//  MiniChallenge002 iOS
//
//  Created by Bruno Lafayette on 01/12/22.
//

import Foundation
import SpriteKit

class ElementFactory {
    
    let natureTexture: SKTexture = SKTexture(imageNamed: "NaturePoint")
    let fireTexture: SKTexture = SKTexture(imageNamed: "FirePoint")
    
    var scene: SKScene
    var patterns: [[Element]] = []
    
    init(scene: SKScene) {
        self.scene = scene
        setUpPatterns()
    }
    
    func setUpPatterns() {
        guard let scene = self.scene as? GameScene else {
            print("Failed to convert SKScene to GameScene")
            return
        }
        
        guard let positionY = scene.background?.physicGround?.frame.maxY else {
            print("Failed to get ground position")
            return
        }
        let size = CGSize(width: scene.size.height * 0.07, height: scene.size.height * 0.07)
        self.patterns.append(pattern001(elementSize: size, positionY: positionY))
        self.patterns.append(pattern002(elementSize: size, positionY: positionY))
        self.patterns.append(pattern003(elementSize: size, positionY: positionY))
    }
    
    func randomPattern() -> [Element] {
        guard let scene = self.scene as? GameScene else {
            print("Failed to convert SKScene to GameScene")
            return []
        }
        guard let positionY = scene.background?.physicGround?.frame.maxY else {
            print("Failed to get ground position")
            return []
        }
        let size = CGSize(width: scene.size.height * 0.07, height: scene.size.height * 0.07)
        switch Array(1...3).randomElement()! {
        case 1:
            return pattern001(elementSize: size, positionY: positionY)
        case 2:
            return pattern002(elementSize: size, positionY: positionY)
        case 3:
            return pattern003(elementSize: size, positionY: positionY)
        default:
            return []
        }
    }
    
    private func randomElement(size: CGSize) -> Element {
        switch ElementType.allCases.randomElement()! {
        case .nature:
            return Element(type: .nature, texture: natureTexture, size: size)
        case .fire:
            return Element(type: .fire, texture: fireTexture, size: size)
        }
    }
    
    func pattern001(elementSize: CGSize, positionY: CGFloat) -> [Element] {
        var pattern: [Element] = []
        for i in 0...2 {
            let element = randomElement(size: elementSize)
            element.position.x = (scene.frame.maxX + 10) + (CGFloat(i) * (element.size.width + 20))
            element.position.y = positionY + 5 + (element.frame.height / 2)
            pattern.append(element)
        }
        return pattern
    }
    
    func pattern002(elementSize: CGSize, positionY: CGFloat) -> [Element] {
        var pattern: [Element] = []
        for i in 0...2 {
            let element = randomElement(size: elementSize)
            element.position.x = (scene.frame.maxX + 10) + (CGFloat(i) * (element.size.width + 20))
            element.position.y = positionY + 5 + (element.frame.height * 5)
            pattern.append(element)
        }
        return pattern
    }
    
    func pattern003(elementSize: CGSize, positionY: CGFloat) -> [Element] {
        var pattern: [Element] = []
        for i in 0...1 {
            let element = randomElement(size: elementSize)
            element.position.x = (scene.frame.maxX + 10)
            element.position.y = positionY + 20 + (element.frame.height * CGFloat(i))
            pattern.append(element)
        }
        return pattern
    }
}
