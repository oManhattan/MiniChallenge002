//
//  GameViewController.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let scene = GameScene(size: view.frame.size)
        let scene = GameScene(size: CGSize(width: 750, height: 1334))

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
//        skView.ignoresSiblingOrder = true
//        skView.showsFPS = true
//        skView.showsNodeCount = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge{
        return [.bottom]
    }
}
