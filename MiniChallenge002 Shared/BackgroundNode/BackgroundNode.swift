//
//  BackgroundNode.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import SpriteKit
import GameKit

class BackgroundNode: SKSpriteNode, SKStateNode {
    
    var stateMachine: GKStateMachine?
    var physicGround: SKSpriteNode?
    var backgroundSky: SKSpriteNode?
    var effectNode: SKEffectNode?
    var progressBar: ProgressBar?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        setUpNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    func setUpNode() {
        // Configurando os pontos do node
        self.anchorPoint = .zero
        self.position = .zero
        
        // Criando os states do node
        self.stateMachine = GKStateMachine(states: [BackgroundPauseState(node: self), BackgroundMovingState(node: self)])
        
        // Criando as texturas
        for i in 0...2 {
            // Criando o chão
            let textureGround = GroundNode(size: self.size)
            textureGround.anchorPoint = .zero
            textureGround.position.x = (self.frame.maxX * CGFloat(i))
            textureGround.position.y = 0
            textureGround.name = "texture-ground-\(i)"
            
            // Criando o background
            let textureBackground = SKSpriteNode(
                texture: SKTexture(imageNamed: "Background0"),
                color: .clear,
                size: CGSize(width: self.size.width, height: self.size.height * 0.6))
            textureBackground.anchorPoint = .zero
            textureBackground.position.x = (frame.maxX * CGFloat(i))
            textureBackground.position.y = textureGround.frame.maxY - 15
            textureBackground.zPosition = -2
            textureBackground.name = "background-\(i)"
            
            // Adicionando os nodes criados
            self.addChildren([textureGround, textureBackground])
        }
        
        // Criando um node para aplicar física
        let physicsGround = SKSpriteNode(
            texture: nil,
            color: .clear,
            size: CGSize(width: size.width - 2, height: self.size.height * 0.6 * 0.4))
        physicsGround.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsGround.position.x = frame.maxX / 2
        physicsGround.position.y = -physicsGround.frame.minY
        physicsGround.zPosition = 0
        physicsGround.physicsBody = SKPhysicsBody(rectangleOf: physicsGround.size)
        physicsGround.physicsBody?.categoryBitMask = PhysicsCategory.chao
        physicsGround.physicsBody?.isDynamic = false
        physicsGround.physicsBody?.restitution = 0
        physicsGround.physicsBody?.contactTestBitMask = PhysicsCategory.personagem
        physicsGround.physicsBody?.collisionBitMask = PhysicsCategory.personagem
        physicsGround.name = "physic-ground"
        
        let backgroundImage: SKSpriteNode = .init(texture: SKTexture(image: UIImage(named: "BG")!), color: .clear, size: CGSize(width: size.width + 10, height: size.height))
        backgroundImage.name = "backgroundImage"
        backgroundImage.anchorPoint = .zero
        backgroundImage.position.x = (frame.maxX * CGFloat(0)) - 10
        backgroundImage.position.y = self.frame.minY
        backgroundImage.zPosition = -5
        
        let effectNode = SKEffectNode()
        effectNode.zPosition = -5
        effectNode.addChild(backgroundImage)
        
        let progressBar = ProgressBar(size: self.size)
        progressBar.position = CGPoint(x: self.frame.minX + (progressBar.frame.size.height * 0.5) + 10, y: (self.frame.maxY - progressBar.size.height * 0.5) - 10)
        progressBar.name = "progress-bar"
        
        self.addChildren([physicsGround, effectNode, progressBar])
        
        self.effectNode = effectNode
        self.backgroundSky = backgroundImage
        self.physicGround = physicsGround
        self.progressBar = progressBar
    }
}
