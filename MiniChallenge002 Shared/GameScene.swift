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
    var continueButton: SKButton<SKSpriteNode>?
    var configurationButton: SKButton<SKSpriteNode>?
    var progressLabel: SKLabelNode?
    
    var elementFactory: ElementFactory?
    var saturation = 0.0
    var distance = 0
    var life = 100.0
    
    var backgroundMusic = SKAudioNode(fileNamed: "music.mp3")
    
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
        
        let continueButton = SKButton<SKSpriteNode>(content: {
            let background = SKSpriteNode(texture: nil, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), size: self.size)
            let label = SKLabelNode(text: "Toque para continuar")
            label.fontName = "AvenirNext-Bold"
            background.addChild(label)
            return background
        }()) {
            self.resumeGame()
            self.continueButton?.removeFromParent()
            self.addChild(self.configurationButton!)
        }
        continueButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        continueButton.zPosition = 2
        continueButton.name = "continue-button"
        
        let configButton = SKButton<SKSpriteNode>(
            content: SKSpriteNode(
                texture: SKTexture(imageNamed: "PauseButton"),
                color: .clear,
                size: CGSize(width: self.size.height * 0.15, height: self.size.height * 0.15)),
            action: {
                self.pauseGame()
                self.addChild(continueButton)
                self.configurationButton?.removeFromParent()
//                self.buildConfigurationMenu()
//                self.configurationButton?.isUserInteractionEnabled = false
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
                self.addChild(configButton)
            })
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startButton.zPosition = 2
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
                          startButton,
                          progressLabel, backgroundMusic])
        
        self.background = backgroundNode
        self.player = playerNode
        self.configurationButton = configButton
        self.startButton = startButton
        self.continueButton = continueButton
        self.progressLabel = progressLabel
        
        self.elementFactory = ElementFactory(scene: self, basePosition: backgroundNode.physicGround?.frame.maxY ?? 0)
        
        self.elementTimer = GameTimer(startValue: 1.19, action: {
            self.elementFactory?.randomPattern()
        })
        
        self.distanceCounterTimer = GameTimer(startValue: 0.2, action: {
            self.distance += 1
            self.progressLabel?.text = "\(self.distance)m"
        })
        
        self.progressBarTimer = GameTimer(startValue: 0.1, action: {
            if (self.background?.progressBar?.progress?.size.width)! > 0{
                self.background?.progressBar?.progress?.size.width -= 5
                self.saturation = (self.background?.progressBar?.progress?.size.width ?? 0) / 1000
            }
        })
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: app)
    }

    @objc
    func applicationWillResignActive(notification: NSNotification) {
        
        if let _ = self.childNode(withName: "menu") {
            return
        }
        
        if self.startButton?.parent != nil {
            return
        }
        
        self.pauseGame()
        self.addChild(self.continueButton!)
        self.configurationButton?.removeFromParent()
    }

    func buildConfigurationMenu() {
        let menu = SKSpriteNode(texture: SKTexture(imageNamed: "PopUp"), color: .clear, size: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.8))
        menu.aspectFillToSize(fillSize: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.8))
        menu.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        menu.zPosition = 4
        menu.name = "menu"
        
        let menuTitle = SKLabelNode(text: "Configurações")
        menuTitle.fontName = "AvenirNext-Bold"
        menuTitle.verticalAlignmentMode = .center
        menuTitle.horizontalAlignmentMode = .center
        menuTitle.position.y = menu.frame.midY * 0.7
        menuTitle.fontSize = 40
        menuTitle.zPosition = 6
        
        let tutorialButton = SKButton<SKShapeNode>(content: {
            let title = SKLabelNode(text: "Tutorial")
            title.fontName = "AvenirNext-Bold"
            title.verticalAlignmentMode = .bottom
            
            let button = SKShapeNode(rect: CGRect(origin: title.position, size: CGSize(width: menuTitle.frame.size.width * 1.2, height: menuTitle.frame.size.height * 1.5)), cornerRadius: 10)
            button.fillColor = UIColor(red: 0.141, green: 0.122, blue: 0.149, alpha: 1)
            button.strokeColor = .clear
            button.position.y = menuTitle.frame.minY - (button.frame.height * 1.5)
            button.position.x = 0 - button.frame.midX
            
            title.position.x = button.frame.maxX
            title.position.y = title.frame.height * 0.7
            
            button.addChild(title)
  
            return button
        }()) {
            print("Depois eu faço o tutorial, rlx")
        }
        tutorialButton.zPosition = 6
        
        let aboutButton = SKButton<SKShapeNode>(content: {
            let title = SKLabelNode(text: "Sobre")
            title.fontName = "AvenirNext-Bold"
            title.verticalAlignmentMode = .bottom
            
            let button = SKShapeNode(rect: CGRect(origin: title.position, size: CGSize(width: menuTitle.frame.size.width * 1.2, height: menuTitle.frame.size.height * 1.5)), cornerRadius: 10)
            button.fillColor = UIColor(red: 0.141, green: 0.122, blue: 0.149, alpha: 1)
            button.strokeColor = .clear
            button.position.y = tutorialButton.content.frame.minY - (button.frame.height * 1.3)
            button.position.x = 0 - button.frame.midX
            
            title.position.x = button.frame.maxX
            title.position.y = title.frame.height * 0.7
            
            button.addChild(title)
  
            return button
        }()) {
            print("Aqui vai alguma coisa sobre o app")
        }
        aboutButton.zPosition = 6
        
        let closeButton = SKButton<SKShapeNode>(content: {
            let title = SKLabelNode(text: "Fechar Menu")
            title.fontName = "AvenirNext-Bold"
            title.verticalAlignmentMode = .bottom
            
            let button = SKShapeNode(rect: CGRect(origin: title.position, size: CGSize(width: menuTitle.frame.size.width * 1.2, height: menuTitle.frame.size.height * 1.5)), cornerRadius: 10)
            button.fillColor = UIColor(red: 0.141, green: 0.122, blue: 0.149, alpha: 1)
            button.strokeColor = .clear
            button.position.y = aboutButton.content.frame.minY - (button.frame.height * 1.3)
            button.position.x = -button.frame.midX
            
            title.position.x = button.frame.maxX
            title.position.y = title.frame.height * 0.7
            
            button.addChild(title)
  
            return button
        }()) {
            menu.removeFromParent()
            self.resumeGame()
            self.configurationButton?.isUserInteractionEnabled = true
        }
        closeButton.zPosition = 6
        
        menu.addChildren([closeButton, menuTitle, tutorialButton, aboutButton])
        
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
    
    func gameOver() {
        self.configurationButton?.removeFromParent()
        self.background?.stateMachine?.enter(BackgroundPauseState.self)
        self.player?.stateMachine?.enter(PlayerPauseState.self)
        self.elementTimer?.pause()
        self.progressBarTimer?.pause()
        self.distanceCounterTimer?.pause()
        
        for child in self.children {
            guard let child = child as? Element else { continue }
            child.removeAllActions()
            child.removeFromParent()
        }
        
        let bestPoint = UserDefaults.standard.integer(forKey: "best-point")
        if bestPoint < self.distance {
            UserDefaults.standard.set(self.distance, forKey: "best-point")
        }
        
        let menu = SKSpriteNode(texture: SKTexture(imageNamed: "PopUp"), color: .clear, size: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.8))
        menu.aspectFillToSize(fillSize: CGSize(width: self.size.width * 0.8, height: self.size.height * 0.8))
        menu.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        menu.zPosition = 4
        menu.name = "menu"
        let background = SKSpriteNode(texture: nil, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), size: self.size)
        background.zPosition = 3
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        let newGameButton = SKButton<SKShapeNode>(content: {
            let title = SKLabelNode(text: "Começar novo jogo")
            title.fontName = "AvenirNext-Bold"
            title.verticalAlignmentMode = .center
            title.horizontalAlignmentMode = .center
            
            let button = SKShapeNode(rect: CGRect(origin: title.position, size: CGSize(width: title.frame.size.width * 1.2, height: title.frame.size.height * 1.5)), cornerRadius: 10)
            button.fillColor = UIColor(red: 0.141, green: 0.122, blue: 0.149, alpha: 1)
            button.strokeColor = .clear
            button.position.y = 0 - button.frame.midY
            button.position.x = 0 - button.frame.midX
            
            title.position.x = button.frame.maxX
            title.position.y = button.frame.maxY
            
            button.addChild(title)
  
            return button
        }()) {
            
            menu.removeFromParent()
            background.removeFromParent()
            
            self.distance = 0
            self.progressLabel?.text = "\(self.distance)"
            self.background?.progressBar?.progress?.size.width = self.background?.progressBar?.maxSize ?? 1000
            self.background?.stateMachine?.enter(BackgroundMovingState.self)
            self.player?.stateMachine?.enter(PlayerRuningState.self)
            self.elementTimer?.start()
            self.progressBarTimer?.start()
            self.distanceCounterTimer?.start()
            
            self.addChild(self.configurationButton!)
        }
        newGameButton.zPosition = 6
        newGameButton.position.y = -menu.frame.midY * 0.75
        
        let bestPointLabel = SKLabelNode(text: "\(bestPoint > self.distance ? bestPoint : self.distance)m")
        bestPointLabel.fontName = "AvenirNext-Bold"
        bestPointLabel.verticalAlignmentMode = .bottom
        bestPointLabel.horizontalAlignmentMode = .center
        bestPointLabel.position.y = newGameButton.frame.maxY + (bestPointLabel.frame.height * 2)
        bestPointLabel.zPosition = 6
        
        let bestPointTitle = SKLabelNode(text: "Melhor Pontuação")
        bestPointTitle.fontName = "AvenirNext-Bold"
        bestPointTitle.verticalAlignmentMode = .bottom
        bestPointTitle.horizontalAlignmentMode = .center
        bestPointTitle.position.y = bestPointLabel.frame.maxY
        bestPointTitle.zPosition = 6
        
        let points = SKLabelNode(text: "\(self.distance)m")
        points.fontName = "AvenirNext-Bold"
        points.verticalAlignmentMode = .bottom
        points.horizontalAlignmentMode = .center
        points.position.y = bestPointTitle.frame.maxY + points.frame.height
        points.zPosition = 6
        
        let pointsTitle = SKLabelNode(text: "Pontuação")
        pointsTitle.fontName = "AvenirNext-Bold"
        pointsTitle.verticalAlignmentMode = .bottom
        pointsTitle.horizontalAlignmentMode = .center
        pointsTitle.position.y = points.frame.maxY
        pointsTitle.zPosition = 6
        
        let menuTitle = SKLabelNode(text: "Fim de Jogo")
        menuTitle.fontSize = 40
        menuTitle.fontName = "AvenirNext-Bold"
        menuTitle.verticalAlignmentMode = .bottom
        menuTitle.horizontalAlignmentMode = .center
        menuTitle.position.y = pointsTitle.frame.maxY + menuTitle.frame.height
        menuTitle.zPosition = 6
                
        menu.addChildren([menuTitle, bestPointLabel, bestPointTitle, pointsTitle, newGameButton, points])
        self.addChildren([menu, background])
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if childNode(withName: "menu") != nil {
            return
        }
        
        if (self.background?.progressBar?.progress?.size.width)! <= 0 {
            gameOver()
            return
        }
        
        background?.effectNode?.filter = CIFilter(name: "CIColorControls")
        background?.effectNode?.filter?.setValue(saturation, forKey: kCIInputSaturationKey)
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
            return
        }
        
        if verifyContactObjects(nameA: "player", nameB: "element", contact: contact) {
            guard let element = getObject(name: "element", contact: contact) as? Element else { return }
            guard let damageBase = self.background?.progressBar?.maxSize else { return }
            switch element.type {
            case .nature:
                self.background?.progressBar?.addProgress(value: damageBase * 0.01)
            case .fire:
                self.background?.progressBar?.removeProgress(value: damageBase * 0.01)
            }
            element.removeFromParent()
            element.stateMachine?.enter(ElementPauseState.self)
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

