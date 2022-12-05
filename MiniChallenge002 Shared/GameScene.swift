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
    var startButton: SKButton<SKSpriteNode>?
    var configurationButton: SKButton<SKSpriteNode>?
    var progressLabel: SKLabelNode?
    
    var elementFactory: ElementFactory?
    var saturation = 0.0
    var distance = 0
    var life = 100.0
    
    var backgroundSound = SKAudioNode(fileNamed: "teste.mp3")
    
    var elementTimer: GameTimer?
    var progressBarTimer: GameTimer?
    var distanceCounterTimer: GameTimer?
    
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
        backgroundNode.stateMachine?.enter(BackgroundPauseState.self)
        
        let playerNode = PlayerNode(size: self.size)
        playerNode.position.x = self.frame.minX + 150
        playerNode.position.y = backgroundNode.childNode(withName: "physic-ground")!.frame.maxY + 100
        playerNode.name = "player"
        playerNode.stateMachine?.enter(PlayerPauseState.self)
        
        let configButton = SKButton<SKSpriteNode>(
            content: SKSpriteNode(
                texture: SKTexture(imageNamed: "ConfigButton"),
                color: .clear,
                size: CGSize(width: self.size.height * 0.15, height: self.size.height * 0.15)),
            action: {
                self.pauseGame()
                self.buildConfigurationMenu()
            })
        configButton.position.x = self.frame.minX + (configButton.content.size.width * 0.5) + 10
        configButton.position.y = self.frame.minY + (configButton.content.size.height * 0.5) + 10
        configButton.zPosition = 2
        configButton.name = "configuration-button"
        
        let startButton = SKButton<SKSpriteNode>(
            content: {
                let background = SKSpriteNode(texture: nil, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), size: self.size)
                let label = SKLabelNode(text: "Toque para começar")
                label.fontName = "AvenirNext-Bold"
                background.addChild(label)
                return background
            }(),
            action: {
                self.resumeGame()
                self.startButton?.removeFromParent()
            })
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startButton.zPosition = 1
        startButton.name = "start-button"
        
        let progressLabel = SKLabelNode(text: "\(distance)m")
        progressLabel.fontColor = UIColor(red: 0.173, green: 0.161, blue: 0.204, alpha: 1)
        progressLabel.fontName = "AvenirNext-Bold"
        progressLabel.verticalAlignmentMode = .top
        progressLabel.horizontalAlignmentMode = .right
        progressLabel.fontSize = 20
        progressLabel.position = CGPoint(x: self.frame.maxX - 40, y: self.frame.maxY - 20)
        progressLabel.name = "progress-label"
        
        self.addChildren([backgroundNode,
                          playerNode,
                          configButton,
                          startButton,
                          progressLabel,
                          self.backgroundSound])
        
        self.background = backgroundNode
        self.player = playerNode
        self.configurationButton = configButton
        self.startButton = startButton
        self.progressLabel = progressLabel
        
        self.elementFactory = ElementFactory(scene: self)
        
        self.elementTimer = GameTimer(startValue: 1.3, action: {
            guard let randomPattern = self.elementFactory?.randomPattern() else { return }
            self.addChildrenWithAction(randomPattern, state: ElementMovingState.self)
        })
        
        self.distanceCounterTimer = GameTimer(startValue: 0.2, action: {
            self.distance += 1
            self.progressLabel?.text = "\(self.distance)m"
        })
        
        self.progressBarTimer = GameTimer(startValue: 0.1, action: {
            if (self.background?.progressBar?.progress?.size.width)! > 0{
                self.background?.progressBar?.progress?.size.width -= 3
                self.saturation = (self.background?.progressBar?.progress?.size.width ?? 0) / 1000
            }
        })
    }
    
    func buildConfigurationMenu() {
        let menu = SKSpriteNode(texture: SKTexture(imageNamed: "PopUp"), color: .clear, size: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.8))
        menu.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        menu.zPosition = 4
        
        let closeButton = SKButton<SKSpriteNode>(content: {
            let button = SKSpriteNode(texture: SKTexture(imageNamed: "LeaveButton"), color: .clear, size: CGSize(width: self.size.height * 0.15, height: self.size.height * 0.15))
            button.zPosition = 5
            return button
        }()) {
            self.resumeGame()
            menu.removeFromParent()
        }
        menu.addChild(closeButton)
        self.addChild(menu)
    }
    
    func pauseGame() {
        self.background?.stateMachine?.enter(BackgroundPauseState.self)
        self.player?.stateMachine?.enter(PlayerPauseState.self)
        self.elementTimer?.pause()
        self.progressBarTimer?.pause()
        self.distanceCounterTimer?.pause()
        
        for child in self.children {
            guard let child = child as? Element else { continue }
            child.stateMachine?.enter(ElementPauseState.self)
        }
    }
    
    func resumeGame() {
        self.background?.stateMachine?.enter(BackgroundMovingState.self)
        self.player?.stateMachine?.enter(PlayerRuningState.self)
        self.elementTimer?.start()
        self.progressBarTimer?.start()
        self.distanceCounterTimer?.start()
        
        for child in self.children {
            guard let child = child as? Element else { continue }
            child.stateMachine?.enter(ElementMovingState.self)
        }
    }
    
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
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
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if verifyContactObjects(nameA: "player", nameB: "physic-ground", contact: contact) {
            guard let player = self.childNode(withName: "player") as? PlayerNode else { return }
            player.stateMachine?.enter(PlayerRuningState.self)
            return
        }
        
        if verifyContactObjects(nameA: "player", nameB: "element", contact: contact) {
            if (self.background?.progressBar?.progress?.size.width)! <= 0 { return }
            guard let element = getObject(name: "element", contact: contact) as? Element else { return }
            guard let damageBase = self.background?.progressBar?.maxSize else { return }
            switch element.type {
            case .nature:
                self.background?.progressBar?.addProgress(value: damageBase * 0.05)
            case .fire:
                self.background?.progressBar?.removeProgress(value: damageBase * 0.05)
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

