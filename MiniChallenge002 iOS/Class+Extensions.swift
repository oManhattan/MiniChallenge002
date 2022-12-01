//
//  Class+Extensions.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import GameKit

extension CGFloat {
    static func higherLower(_ n1: Self, _ n2: Self) -> (Self, Self) {
        let max = (n1 > n2) ? n1 : n2
        let min = (n1 < n2) ? n1 : n2
        return (max, min)
    }
}

extension CGSize {
    static func toLandscape(_ n1: CGFloat, _ n2: CGFloat) -> Self {
        let (max, lower) = CGFloat.higherLower(n1, n2)
        return .init(width: max, height: lower)
    }
    
    static func toLandscape(_ size: Self) -> Self {
        let (max, lower) = CGFloat.higherLower(size.width, size.height)
        return .init(width: max, height: lower)
    }
}

extension GKState {
    @objc func nextState() {
        // Set next state here
    }
}

extension SKSpriteNode {
    func addChildren(_ children: [SKNode]) {
        children.forEach({addChild($0)})
    }
    
    func aspectFillToSize(fillSize: CGSize) {
        if let texture = self.texture {
            self.size = texture.size()

            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width /  self.texture!.size().width

            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio

            self.setScale(scaleRatio)
        }
    }
}


extension SKScene {
    func addChildren(_ children: [SKNode]) {
        children.forEach({addChild($0)})
    }
}

extension Array where Element == SKTexture {
    init(format: String, frameCount: ClosedRange<Int>) {
        self = frameCount.map({ (index) in
            let imageName = String(format: format, "\(index)")
            return SKTexture(imageNamed: imageName)
        })
    }
}
