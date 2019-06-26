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
    // var enemy:SKNode!
    var player:SKNode!
    var enemy = SKSpriteNode(imageNamed: "enemy")
    
    // GAME STAT SPRITES
    let livesLabel = SKLabelNode(text: "Lives: ")
    let scoreLabel = SKLabelNode(text: "Score: ")
    
    //game sound variables
    var audio = SKAudioNode(fileNamed: "music.wav")
    var walkaudio = SKAudioNode(fileNamed: "walk.wav")
    
    // generate a random (x,y) for the cat
    var previous = 600
    var randX = Int(CGFloat(arc4random_uniform(UInt32(300))))
    var randY = Int(CGFloat(arc4random_uniform(UInt32(600))))
    

    
    // GAME STATISTIC VARIABLES
    var lives = 4
    var score = 0
    
    override func didMove(to view: SKView)
    {
        
        
        //initialize swipe
        let swipeUp = UISwipeGestureRecognizer(target: self,
        action: #selector(GameScene.swipeUp(sender:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self,
        action: #selector(GameScene.swipeDown(sender:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        
        // Required for SKPhysicsContactDelegate
        self.physicsWorld.contactDelegate = self
        
        
        // MARK: Add a lives label
        // ------------------------
        self.livesLabel.text = "Lives: \(self.lives)"
        self.livesLabel.fontName = "Avenir-Bold"
        self.livesLabel.fontColor = UIColor.white
        self.livesLabel.fontSize = 45;
        self.livesLabel.position = CGPoint(x:-250,
                                           y:550)
        // MARK: Add a score label
        // ------------------------
        self.scoreLabel.text = "Score: \(self.score)"
        self.scoreLabel.fontName = "Avenir-Bold"
        self.scoreLabel.fontColor = UIColor.white
        self.scoreLabel.fontSize = 45;
        self.scoreLabel.position = CGPoint(x:250,
                                           y:550)
        
        
        addChild(self.livesLabel)
        addChild(self.scoreLabel)
        
        
        for i in 0 ... 10 {
            
            print (i)
            spawnEnemy()
            self.randY = Int(CGFloat(arc4random_uniform(UInt32(self.previous + 300))))
            
        }
       
        
        
        //self.enemy = self.childNode(withName:"enemy")
       
        // make the enemy move back and forth forever
        // ----------------------------------------
        // 1. make your sk actions
        // --- 1a. move left
//        let m1 = SKAction.moveBy(x: -500, y: 0, duration: 5)
//        // --- 1b. move right
//        let m2 = SKAction.moveBy(x: 500, y: 0, duration: 5)
//
//        // 2. put actions into a sequence
//        let sequence = SKAction.sequence([m1,m2])
//
//        // 3. apply sequence to sprite
        // self.enemy!.run(SKAction.repeatForever(sequence))
        
        // Show animation for player
        // ----------------------------
        // 1. make an array of images for the animation
        // -- SKTexture = Object to hold images
        var dinoTextures:[SKTexture] = []
        for i in 1...4
        {
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
    
    
    var timeOfLastUpdate:TimeInterval?
    
    override func update(_ currentTime: TimeInterval) {
        
      
        
        
        // MARK: R2: detect collisions between zombie and cat
        for (arrayIndex, temp) in enemies.enumerated() {
            if (self.player.intersects(temp) == true) {
               // print("CAT COLLISION DETECTED!")
                // 1. increase the score
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
                
                spawnEnemy()
                if (self.score == 10) {
//                    // YOU WIN!!!!
//                    let winScene = WinScene(size: self.size)
//
//                    // CONFIGURE THE LOSE SCENE
//                    winScene.scaleMode = self.scaleMode
//
//                    // MAKE AN ANIMATION SWAPPING TO THE LOSE SCENE
//                    let transitionEffect = SKTransition.flipHorizontal(withDuration: 2)
//                    self.view?.presentScene(winScene, transition: transitionEffect)
//
//
//                    break;
                }
                
                // 2. remove the cat from the scene
               // print("Removing cat at position: \(arrayIndex)")
                // ---- 2a. remove from the array
                self.enemies.remove(at: arrayIndex)
                // ---- 2b. remove from scene (undraw the cat)
                temp.removeFromParent()
            }
        } // end for loop
    }
    
    
    
    
    @objc func swipeUp(sender: UISwipeGestureRecognizer) {
        // Handle the swipe
        self.player.position.y = self.player.position.y + 300
        
    }
    
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        // Handle the swipe
        self.player.position.y = self.player.position.y - 300
        
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
            
            if(self.player.position.x < 350 ) {
                
                self.player.position.x = self.player.position.x + 100

                
                let lookRightAction = SKAction.scaleX(to: 2, duration:0)
                self.player.run(lookRightAction)
                
                
                
                
               // print("right : x\(self.player.position.x)")
                
            }
            else
            {
                self.player.position.x = 0 - 250
               
            }
            
            
        }
            
        else if(xpos < 0)
        {
            
            if(self.player.position.x > 0 - 450 )
            {
                
                self.player.position.x = self.player.position.x - 100
                
                let lookLeftAction = SKAction.scaleX(to: -2, duration:0)
                self.player.run(lookLeftAction)
                
               // print("left : x\(self.player.position.x)")
                
            }
                
            else
            {
                self.player.position.x = 250
                
            }
            
            
        }
        
    }
    
    
    
    var enemies:[SKSpriteNode] = []
    
    func spawnEnemy() {
        // lets add some cats
        self.enemy.position = CGPoint(x:randX, y:randY)
        
        self.enemy.physicsBody = SKPhysicsBody(texture: self.enemy.texture!,
                                               size: self.enemy.texture!.size())
        
        self.enemy.physicsBody?.affectedByGravity = true
        
        self.enemy.physicsBody?.restitution = 0.75
        self.enemy.physicsBody?.isDynamic = true
        
        // set the bed category to 4
        self.enemy.physicsBody?.categoryBitMask = 4
        
        // set the collision mask = 0
       // enemy.physicsBody?.collisionBitMask = 8
        
        // add the cat to the scene
        addChild(self.enemy)
        
        // add the cat to the cats array
        self.enemies.append(self.enemy)
        
       // print("Where is cat? \(randX), \(randY)")
    }
    
    
    var lose:Bool = false
    
    func youLose() {
        self.lose = true
        
        //print("YOU LOSE!")
        let messageLabel = SKLabelNode(text: "YOU LOSE!")
        messageLabel.fontColor = UIColor.yellow
        messageLabel.fontSize = 60
        messageLabel.position.x = self.size.width/2
        messageLabel.position.y = self.size.height/2
        addChild(messageLabel)
    }
}
