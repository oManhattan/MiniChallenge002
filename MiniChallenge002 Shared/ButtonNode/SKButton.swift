//
//  SKButton.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 30/11/22.
//

import Foundation
import SpriteKit

class SKButton<T:SKNode>: SKNode{
    
    var action: (() -> Void)?
    var content: T
    
    init(content: T, action: @escaping () -> Void) {
        self.content = content
        self.action = action
        super.init()
        self.isUserInteractionEnabled = true
        self.addChild(content)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action?()
    }
}
