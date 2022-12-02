//
//  GameScene.swift
//  MiniChallenge002 Shared
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import SpriteKit

class GameScene: SKScene {
    
    var player: PlayerNode?
    var background: BackgroundNode?
    var configurationButton: SKButton<SKSpriteNode>?
    var progressBar: ProgressBarNode?
    var progressLabel: SKLabelNode?
    var saturation = 0.0
    
    var elementFactory: ElementFactory?
    
    var distance = 0
    var life = 100.0
    
    var backgroundSound = SKAudioNode(fileNamed: "teste.mp3")
    
    var elementTimer: Timer?
    var lifeBarTimer: Timer?
    
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
        
        let configButton = SKButton<SKSpriteNode>(
            content: SKSpriteNode(
                texture: SKTexture(imageNamed: "ConfigButton"),
                color: .clear,
                size: CGSize(width: self.size.height * 0.15, height: self.size.height * 0.15)),
        action: {
            print("Funcionou")
        })
        configButton.position.x = self.frame.minX + (configButton.content.size.width * 0.5) + 10
        configButton.position.y = self.frame.minY + (configButton.content.size.height * 0.5) + 10
        configButton.zPosition = 2
        
        let startButton = SKButton<SKLabelNode>(
            content: SKLabelNode(text: "Toque para começar"),
            action: {
                print("começou")
            })
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startButton.content.fontName = "AvenirNext-Bold"
        startButton.zPosition = 1
        startButton.name = "start-button"
        
        let progressBar = ProgressBarNode(size: self.size)
        progressBar.position = CGPoint(x: self.frame.minX + 20, y: self.frame.maxY - 10)
        progressBar.name = "progress-bar"
        
        let progressLabel = SKLabelNode(text: "\(distance)m")
        progressLabel.fontColor = UIColor(red: 0.173, green: 0.161, blue: 0.204, alpha: 1)
        progressLabel.fontName = "AvenirNext-Bold"
        progressLabel.verticalAlignmentMode = .top
        progressLabel.horizontalAlignmentMode = .right
        progressLabel.fontSize = 20
        progressLabel.position = CGPoint(x: self.frame.maxX - 40, y: self.frame.maxY - 20)
        progressLabel.name = "progress-label"
        
        self.addChildren([backgroundNode, playerNode, configButton, startButton, progressBar, progressLabel, self.backgroundSound])
        
        self.background = backgroundNode
        self.player = playerNode
        self.configurationButton = configButton
        self.progressBar = progressBar
        self.progressLabel = progressLabel
        
        self.elementFactory = ElementFactory(scene: self)
        self.elementTimer = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(generateElements), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(changeDistance), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        background?.effectNode?.filter = CIFilter(name: "CIColorControls")
        background?.effectNode?.filter?.setValue(saturation, forKey: kCIInputSaturationKey)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let player = self.childNode(withName: "player") as? PlayerNode else { return }
        player.stateMachine?.enter(PlayerJumpingState.self)
        
        //Função para parar o audio
        backgroundSound.run(SKAction.stop())
        
        //Função para iniciar o audio
        //backgroundSound.run(SKAction.play())
    }
    
    @objc func generateElements() {
//        guard let pattern = self.elementFactory?.pattern001(elementSize: <#T##CGSize#>, positionY: <#T##CGFloat#>) else {
//            print("deu ruim")
//            return
//        }
        
//        guard let randomPattern = self.elementFactory?.patterns.randomElement() else { return }
        guard let randomPattern = self.elementFactory?.randomPattern() else { return }
        let action = SKAction.customAction(withDuration: 1/60) { node, _ in
            guard let elementName = node.name, elementName == "element" else {
                print("Failed to move element")
                return
            }
            node.position.x -= self.speed
            
            if node.frame.maxX - 2 <= -10 {
                node.removeFromParent()
            }
        }
        self.addChildrenWithAction(randomPattern, action: action)
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
            if (self.progressBar?.progress?.size.width)! <= 0 {
                return
            }
            guard let element = getObject(name: "element", contact: contact) as? Element else { return }
            switch element.type {
            case .nature:
                self.progressBar?.changeProgressSize(value: 20.0)
            case .fire:
                self.progressBar?.changeProgressSize(value: -20.0)
            }
            element.removeFromParent()
            return
        }
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

extension GameScene {
    
    @objc func changeDistance() {
        self.distance += 1
        self.progressLabel?.text = "\(self.distance)m"
    }
    
    @objc func updateProgressBar(){
        if (self.progressBar?.progress?.size.width)! > 0{
            self.progressBar?.progress?.size.width -= 3
            saturation = self.progressBar!.progress!.size.width / 1000
        }
    }
}
