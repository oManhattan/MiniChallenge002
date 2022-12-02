//
//  GameScene.swift
//  MiniChallenge002 Shared
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import SpriteKit

class GameScene: SKScene {
    
    var elementGenerator: ElementNode?
    var timer: Timer?
    var distance = 0
    
    override init(size: CGSize) {
        let landscapeSize = CGSize.toLandscape(size)
        super.init(size: landscapeSize)
        self.scaleMode = .resizeFill
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.speed = 1.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    func setUpScene() {
        let backgroundNode = BackgroundNode(size: self.size)
        backgroundNode.speed = self.speed
        backgroundNode.name = "background"
        backgroundNode.stateMachine?.enter(BackgroundMovingState.self)
        
        let playerNode = PlayerNode(size: self.size)
        playerNode.name = "player"
        playerNode.position.x = self.frame.minX + 150
        playerNode.position.y = backgroundNode.childNode(withName: "physic-ground")!.frame.maxY + 100
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
        
        let progressBar = ProgressBarNode(size: self.size)
        progressBar.position = CGPoint(x: self.frame.minX + 20, y: self.frame.maxY - 10)
        progressBar.name = "progress-bar"
        
        let progressLabel = SKLabelNode(text: "\(distance)m")
        progressLabel.verticalAlignmentMode = .top
        progressLabel.horizontalAlignmentMode = .right
        progressLabel.fontSize = 20
        progressLabel.position = CGPoint(x: self.frame.maxX - 40, y: self.frame.maxY - 20)
        progressLabel.name = "progress-label"
        
        _ = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(changeDistance), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
        
        self.addChildren([backgroundNode, playerNode, configButton, progressBar, progressLabel])
        
        self.elementGenerator = ElementNode(scene: self)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(generateElements), userInfo: nil, repeats: true)
        
    }
    
    override func didMove(to view: SKView) {
//        view.showsPhysics = true
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let player = self.childNode(withName: "player") as? PlayerNode else { return }
        player.stateMachine?.enter(PlayerJumpingState.self)
    }
    
    @objc func generateElements() {
//        DispatchQueue.main.async {
            let patterns: [Int] = .init(1...3)
            switch patterns.randomElement()! {
            case 1:
                self.elementGenerator?.generatePattern01()
            case 2:
                self.elementGenerator?.generatePattern02()
            case 3:
                self.elementGenerator?.generatePattern03()
            default:
                return
            }
//        }
    }
    
    @objc func changeDistance() {
        guard let progressLabel = self.childNode(withName: "progress-label") as? SKLabelNode else { return }
        self.distance += 1
        progressLabel.text = "\(self.distance)m"
    }
    
    @objc func updateProgressBar(){
        guard let progressBar = self.childNode(withName: "progress-bar") as? ProgressBarNode, let progress = progressBar.childNode(withName: "progress") as? SKSpriteNode else { return }
        if progress.size.width > 0{
            progress.size.width -= 3
        }
    }

}

extension GameScene: SKPhysicsContactDelegate {
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if verifyContactObjects(nameA: "player", nameB: "physic-ground", contact: contact) {
            guard let player = self.childNode(withName: "player") as? PlayerNode else { return }
            player.stateMachine?.enter(PlayerRuningState.self)
            return
        }
        
        if verifyContactObjects(nameA: "player", nameB: "element", contact: contact) {
            guard let element = getObject(name: "element", contact: contact) else { return }
            element.removeFromParent()
            return
        }
//        print("Object A: \(contact.bodyA.node?.name) | Object B: \(contact.bodyB.node?.name)")
    }
    
    func verifyContactObjects(nameA: String, nameB: String, contact: SKPhysicsContact) -> Bool {
        guard let bodyA = contact.bodyA.node?.name, let bodyB = contact.bodyB.node?.name else { return false }
        if (bodyA == nameA || bodyA == nameB) && (bodyB == nameA || bodyB == nameB) {
            return true
        }
        return false
    }
    
    func getObject(name: String, contact: SKPhysicsContact) -> SKSpriteNode? {
        if contact.bodyA.node?.name == name {
            return contact.bodyA.node as? SKSpriteNode
        }
        
        if contact.bodyB.node?.name == name {
            return contact.bodyB.node as? SKSpriteNode
        }
        
        return nil
    }
}
