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
    var enemy:SKNode!
    var player:SKNode!
    
    
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
        
        
        
        // Show animation for dinosaur
        // ----------------------------
        // 1. make an array of images for the animation
        // -- SKTexture = Object to hold images
        var dinoTextures:[SKTexture] = []
        for i in 1...4 {
            let fileName = "penguin_walk0\(i)"
            print("Adding: \(fileName) to array")
            dinoTextures.append(SKTexture(imageNamed: fileName))
        }
        
        // 2. Tell Spritekit to use that array to create your animation
        let walkingAnimation = SKAction.animate(
            with: dinoTextures,
            timePerFrame: 0.1)
        
        // 3. Repeat the animation forever
        self.player.run(SKAction.repeatForever(walkingAnimation))
        
        
        
    }
    
    
    var lookingDir = "right"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let touch = touches.first
        if (touch == nil) {
            return
        }
        
        //Where user has touched?
        let mouseLocation = touch!.location(in:self)
        //let spriteTouched = self.atPoint(mouseLocation)
        //print("px\(self.player.position.x),py\(self.player.position.y),")
        // ------------
        // Detect collision with right wall
        // ------------
        
        let xpos = mouseLocation.x
        //print(half)
        if ( xpos > 0 )
        {
            
            if(self.player.position.x < 400 ) {
                
                self.player.position.x = self.player.position.x + 100
                
                let lookRightAction = SKAction.scaleX(to: 2, duration:0)
                self.player.run(lookRightAction)
                
                
                
                
                print("right : x\(self.player.position.x)")
                
            }
            else{
                self.player.position.x = 0 - 300
            }
            
            
        }
            
        else if(xpos < 0)
        {
            
            if(self.player.position.x > 0 - 450 )
            {
                
                self.player.position.x = self.player.position.x - 100
                
                let lookLeftAction = SKAction.scaleX(to: -2, duration:0)
                self.player.run(lookLeftAction)
                
                print("left : x\(self.player.position.x)")
                
            }
                
            else
            {
                self.player.position.x = 300
            }
            
            
        }
        
    }
    
    var lose:Bool = false
    
    func youLose() {
        self.lose = true
        
        print("YOU LOSE!")
        let messageLabel = SKLabelNode(text: "YOU LOSE!")
        messageLabel.fontColor = UIColor.yellow
        messageLabel.fontSize = 60
        messageLabel.position.x = self.size.width/2
        messageLabel.position.y = self.size.height/2
        addChild(messageLabel)
    }
}
