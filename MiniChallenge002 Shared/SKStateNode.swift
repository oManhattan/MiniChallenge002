//
//  SKStateNode.swift
//  MiniChallenge002 iOS
//
//  Created by Matheus Cavalcanti de Arruda on 02/12/22.
//

import Foundation
import SpriteKit
import GameKit

protocol SKStateNode: SKSpriteNode {
    
    var stateMachine: GKStateMachine? { get }
}
