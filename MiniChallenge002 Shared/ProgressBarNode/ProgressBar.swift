//
//  ProgressBar.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 07/12/22.
//

import Foundation
import SpriteKit

class ProgressBar: SKSpriteNode {
    
    var progress: SKSpriteNode!
    var progressMaxSize: CGFloat
    
    var currentProgress: CGFloat {
        return progress.size.width
    }
    
    var progressPercent: CGFloat {
        return currentProgress / progressMaxSize
    }
    
    init(size: CGSize) {
        self.progressMaxSize = size.width * 0.4
        super.init(texture: nil, color: .clear, size: CGSize(width: (size.width * 0.4) + size.height * 0.13, height: size.height * 0.13))
        
        self.anchorPoint.x = 0
        
        let progressBase = SKSpriteNode(texture: SKTexture(imageNamed: "NaturePoint"), color: .clear, size: CGSize(width: size.height * 0.13, height: size.height * 0.13))
        progressBase.position = CGPoint(x: 0, y: 0)
        progressBase.zPosition = 5
        
        let progressBarBorder = SKShapeNode(rectOf: CGSize(width: size.width * 0.4, height: progressBase.frame.height * 0.6), cornerRadius: 15)
        progressBarBorder.position = CGPoint(x: progressBarBorder.frame.maxX, y: -progressBarBorder.frame.midY)
        progressBarBorder.strokeColor = UIColor(red: 0.173, green: 0.161, blue: 0.204, alpha: 1)
        progressBarBorder.lineWidth = 4
        progressBarBorder.zPosition = 4
        
        let crop = SKCropNode()
        let cropShape = SKShapeNode(rectOf: CGSize(width: size.width * 0.4, height: progressBase.frame.height * 0.6), cornerRadius: 15)
        cropShape.position = progressBarBorder.position
        cropShape.fillColor = .red
        cropShape.lineWidth = 0
        crop.maskNode = cropShape
        
        let progress = SKSpriteNode(color: UIColor(red: 0.812, green: 0.91, blue: 0.773, alpha: 1), size: CGSize(width: cropShape.frame.width, height: cropShape.frame.height))
        progress.zPosition = 3
        progress.anchorPoint.x = 0
        
        crop.addChild(progress)
        self.addChildren([progressBase, progressBarBorder, crop])
        
        self.progress = progress
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    func removeProgress(value: CGFloat) {
        if self.currentProgress - value <= 0 {
            self.progress?.size.width = 0
            return
        }
        
        self.progress?.size.width -= value
    }
    
    func addProgress(value: CGFloat) {
        if self.currentProgress + value >= self.progressMaxSize {
            self.progress?.size.width = self.progressMaxSize
            return
        }
        
        self.progress?.size.width += value
    }
    
}
