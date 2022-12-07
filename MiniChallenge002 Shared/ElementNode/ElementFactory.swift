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
    
    let scene: SKScene
    let basePosition: CGFloat
    let elementSize: CGSize
    var patterns: [[Element]] = []
    var cooldownPatterns: [[Element]] = []
    
    init(scene: SKScene, basePosition: CGFloat) {
        self.scene = scene
        self.basePosition = basePosition
        self.elementSize = CGSize(width: scene.size.height * 0.07, height: scene.size.height * 0.07)
        natureTexture.preload {}
        fireTexture.preload {}
        setUpPatterns()
    }
    
    func setUpPatterns() {
        patterns = [
            floorPattern(sequence: [.nature, .nature, .nature]),
            floorPattern(sequence: [.fire, .fire, .fire]),
            floorPattern(sequence: [.nature, .nature, .fire]),
            floorPattern(sequence: [.nature, .fire, .fire]),
            floorPattern(sequence: [.fire, .fire, .nature]),
            floorPattern(sequence: [.fire, .nature, .nature]),
            
            skyPattern(sequence: [.nature, .nature, .nature]),
            skyPattern(sequence: [.fire, .fire, .fire]),
            skyPattern(sequence: [.nature, .nature, .fire]),
            skyPattern(sequence: [.nature, .fire, .fire]),
            skyPattern(sequence: [.fire, .fire, .nature]),
            skyPattern(sequence: [.fire, .nature, .nature]),
            
            wallPattern(sequence: [.nature, .nature]),
            wallPattern(sequence: [.fire, .fire]),
            wallPattern(sequence: [.fire, .nature])
        ]
    }
    
    func randomPattern() {
        guard let sortedNum = Array(0..<self.patterns.count).randomElement() else {
            return
        }
        
        let pattern: [Element] = self.patterns.remove(at: sortedNum).map({$0.resetToInitialPosition(); return $0 })
        
        self.cooldownPatterns.append(pattern)
        
        if self.cooldownPatterns.count > 3 {
            let aux = self.cooldownPatterns.removeFirst()
            self.patterns.append(aux)
        }
        
        self.scene.addChildrenWithAction(pattern, state: ElementMovingState.self)
    }
    
    func createElement(type: ElementType) -> Element {
        switch type {
        case .fire:
            return Element(type: type, texture: self.fireTexture, size: self.elementSize)
        case .nature:
            return Element(type: type, texture: self.natureTexture, size: self.elementSize)
        }
    }
    
    func floorPattern(sequence: [ElementType]) -> [Element] {
        var pattern: [Element] = []
        
        for i in 0..<sequence.count {
            let element = createElement(type: sequence[i])
            let positionX = (self.scene.frame.maxX + 10) + (CGFloat(i)  * element.frame.width * 1.8)
            let positionY = self.basePosition + element.frame.height
            element.setPosition(position: CGPoint(x: positionX, y: positionY))
            pattern.append(element)
        }
        
        return pattern
    }
    
    func skyPattern(sequence: [ElementType]) -> [Element] {
        var pattern: [Element] = []
        
        for i in 0..<sequence.count {
            let element = createElement(type: sequence[i])
            let positionX = (self.scene.frame.maxX + 10) + (CGFloat(i)  * element.frame.width * 1.8)
            let positionY = self.basePosition + (element.frame.height * 5)
            element.setPosition(position: CGPoint(x: positionX, y: positionY))
            pattern.append(element)
        }
        
        return pattern
    }
    
    func wallPattern(sequence: [ElementType]) -> [Element] {
        var pattern: [Element] = []
        
        for i in 0..<sequence.count {
            let element = createElement(type: sequence[i])
            let positionX = self.scene.frame.maxX + 10
            let positionY = self.basePosition + element.frame.height + (element.frame.height * CGFloat(i) * 1.3)
            element.setPosition(position: CGPoint(x: positionX, y: positionY))
            pattern.append(element)
        }
        
        return pattern
    }
}
