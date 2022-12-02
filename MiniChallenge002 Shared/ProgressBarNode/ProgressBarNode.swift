//
//  ProgressBarNode.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import SpriteKit
import GameKit

class ProgressBarNode: SKSpriteNode {
    
    var progress: SKSpriteNode?
    
    init(size: CGSize) {
        super.init(
            texture: SKTexture(imageNamed: "ProgressBar"),
            color: .clear,
            size: .zero)
        
        self.zPosition = 3
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.aspectFillToSize(fillSize: CGSize(width: size.width * 0.33, height: size.height * 0.13))
        print(self.frame)
        let progressBar = SKSpriteNode(texture: nil, color: .green, size: CGSize(width: self.frame.width * 2.72 , height: self.frame.height))
        progressBar.anchorPoint = CGPoint(x: 0, y: 1)
        progressBar.position.x = self.frame.maxX * 0.3
        progressBar.position.y = self.frame.minY - 5
        progressBar.name = "progress"
        progressBar.zPosition = 0
        self.addChild(progressBar)
        self.progress = progressBar
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
}
