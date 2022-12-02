//
//  GameScene.swift
//  MiniChallenge002 Shared
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import SpriteKit

class GameScene: SKScene {
    
    let effectNode = SKEffectNode()
    private var life = 100.0
    
    override init(size: CGSize) {
        let landscapeSize = CGSize.toLandscape(size)
        super.init(size: landscapeSize)
        self.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    func setUpScene() {
        
        let backgroundImage: SKSpriteNode = .init(texture: SKTexture(image: UIImage(named: "BG")!), color: .clear, size: CGSize(width: size.width + 10, height: size.height))
        backgroundImage.name = "backgroundImage"
        backgroundImage.anchorPoint = .zero
        backgroundImage.position.x = (frame.maxX * CGFloat(0)) - 10
        backgroundImage.position.y = self.frame.minY
        
        effectNode.addChild(backgroundImage)
        effectNode.zPosition = -5
        addChild(effectNode)
        
        let backgroundNode = BackgroundNode(size: self.size)
        backgroundNode.speed = 2
        backgroundNode.name = "background"
        backgroundNode.stateMachine?.enter(BackgroundMovingState.self)
        
        
        
        let playerNode = PlayerNode(size: self.size)
        playerNode.name = "player"
        playerNode.position.x = self.frame.minX + 150
        playerNode.position.y = backgroundNode.childNode(withName: "physic-ground")!.frame.maxY
        playerNode.stateMachine?.enter(PlayerRuningState.self)
        
        let configButton = SKButton(
            texture: SKTexture(imageNamed: "ConfigButton"),
            color: .clear,
            size: CGSize(width: self.size.height * 0.15, height: self.size.height * 0.15))
        configButton.anchorPoint = .zero
        configButton.position = CGPoint(x: 20, y: 10)
        configButton.zPosition = 1
        configButton.name = "configuration-button"
        configButton.action = {
            print("Funcionou")
        }
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(reduceLife), userInfo: nil, repeats: true)
        
        let progressBar = ProgressBarNode(size: self.size)
        progressBar.position = CGPoint(x: self.frame.minX + 20, y: self.frame.maxY - 10)
        
        let progressLabel = SKLabelNode(text: "Progresso vai aqui")
        progressLabel.fontSize = 20
        progressLabel.position = CGPoint(x: self.frame.maxX - (progressLabel.frame.maxX * 1.5), y: self.frame.maxY - progressLabel.frame.maxY - 10)
        
        self.addChildren([backgroundNode, playerNode, configButton, progressBar, progressLabel])
    }
    
    @objc func reduceLife(){
        self.life -= 10
        if life == 0 {
            life = 100
        }
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        effectNode.filter = CIFilter(name: "CIColorControls")
        effectNode.filter?.setValue(life/100, forKey: kCIInputSaturationKey)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let player = self.childNode(withName: "player") as? PlayerNode else { return }
        player.stateMachine?.enter(PlayerJumpingState.self)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if verifyContactObjects(nameA: "player", nameB: "physic-ground", contact: contact) {
            guard let player = self.childNode(withName: "player") as? PlayerNode else { return }
            player.stateMachine?.enter(PlayerRuningState.self)
        }
    }
    
    func verifyContactObjects(nameA: String, nameB: String, contact: SKPhysicsContact) -> Bool {
        guard let bodyA = contact.bodyA.node?.name, let bodyB = contact.bodyB.node?.name else { return false }
        if (bodyA == nameA || bodyA == nameB) && (bodyB == nameA || bodyB == nameB) {
            return true
        }
        return false
    }
}
