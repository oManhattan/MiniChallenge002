//
//  GroundNode.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import SpriteKit

class GroundNode: SKSpriteNode {
    
    init(size: CGSize) {
        super.init(
            texture: nil,
            color: .clear,
            size: CGSize(width: size.width, height: size.height * 0.35))
        setUpNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    func setUpNode() {
        // Criando o piso baixo
        guard let lowGroundImage = UIImage(named: "LowGround") else { return }
        let lowGround = SKSpriteNode(
            texture: SKTexture(image: lowGroundImage),
            color: .clear,
            size: CGSize(width: self.size.width, height: self.size.height * 0.6))
        lowGround.anchorPoint = .zero
        lowGround.position = .zero
        lowGround.zPosition = -1
        lowGround.name = "low-ground"
        
        // Criando o piso alto
        guard let highGroundImage = UIImage(named: "HighGround") else { return }
        let highGround = SKSpriteNode(
            texture: SKTexture(image: highGroundImage),
            color: .clear,
            size: CGSize(width: self.size.width, height: self.size.height * 0.4))
        highGround.anchorPoint = .zero
        highGround.position = CGPoint(x: 0, y: lowGround.frame.maxY - 10)
        highGround.zPosition = -2
        highGround.name = "high-ground"
        
        // Adicionando os pisos ao node
        self.addChildren([lowGround, highGround])
    }
}
