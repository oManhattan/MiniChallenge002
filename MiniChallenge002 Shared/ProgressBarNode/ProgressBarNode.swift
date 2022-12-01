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
    
    init(size: CGSize) {
        super.init(
            texture: SKTexture(imageNamed: "ProgressBar"),
            color: .clear,
            size: .zero)
        
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.aspectFillToSize(fillSize: CGSize(width: size.width * 0.33, height: size.height * 0.13))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
}
