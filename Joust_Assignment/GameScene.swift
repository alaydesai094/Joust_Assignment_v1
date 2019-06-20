//
//  GameScene.swift
//  Joust_Assignment
//
//  Created by Dhyanee Bhatt on 2019-06-19.
//  Copyright © 2019 Dhyanee Bhatt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //sprites
     var enemy:SKNode?
     var player:SKNode?
    
    override func didMove(to view: SKView)
    {
        
        // Required for SKPhysicsContactDelegate
        self.physicsWorld.contactDelegate = self
        
        
        // intialize your sprite variables
        self.player = self.childNode(withName: "player")
        self.enemy = self.childNode(withName:"enemy")
        
        // make the enemy move back and forth forever
        // ----------------------------------------
        // 1. make your sk actions
        // --- 1a. move left
        let m1 = SKAction.moveBy(x: -500, y: 0, duration: 2)
        // --- 1b. move right
        let m2 = SKAction.moveBy(x: 500, y: 0, duration: 2)
        
        // 2. put actions into a sequence
        let sequence = SKAction.sequence([m1,m2])
        
        // 3. apply sequence to sprite
        self.enemy!.run(SKAction.repeatForever(sequence))
       
    }
    
    
    func touchDown(atPoint pos : CGPoint)
    {
       }
    
    func touchMoved(toPoint pos : CGPoint)
    {
       }
    
    func touchUp(atPoint pos : CGPoint)
    {
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let touch = touches.first
        if (touch == nil) {
            return
        }
        self.player?.position.y = self.player!.position.y + 10
        //  let mouseLocation = touch!.location(in:self)
    }
        
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        
    }
        
}
