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
    
    var enemies:[SKSpriteNode] = []
    var eggs:[SKSpriteNode] = []
    
    // GAME STAT SPRITES
    let livesLabel = SKLabelNode(text: "Lives: ")
    let scoreLabel = SKLabelNode(text: "Score: ")
    
    //game sound variables
    var audio = SKAudioNode(fileNamed: "music.wav")
    var walkaudio = SKAudioNode(fileNamed: "walk.wav")
    
    var moving: Bool = false
    
//    // generate a random (x,y) for the cat
//    var randX = Int.random(in: -308...308)
//    var randY = Int.random(in: -599...599)
    
    
    // Enemy movement
    var move1 = SKAction.moveBy(x: -309, y: 0, duration: 10)
    //
    var move2 = SKAction.moveBy(x: 309, y: 0, duration: 10)
    
   // var  sequence = SKAction.sequence([self.move1,self.move2])
    
    // GAME STATISTIC VARIABLES
    var lives = 4
    var score = 0
    
    override func didMove(to view: SKView)
    {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
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
        
        
        for i in 0 ... 5 {
            
//            self.randX = Int.random(in: -308...308)
//            self.randY = Int.random(in: -599...599)
            
            //print (self.randX, self.randY)
            
            spawnEnemy()
            
        }
       
        
        // intialize your sprite variables
        self.player = self.childNode(withName: "player")
        //self.enemy = self.childNode(withName:"enemy")
       
       
        
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
        
        for enemy in enemies {
            
         //   enemy.run(SKAction.repeatForever(self.sequence))
            
            enemy.position.x = enemy.position.x + 10
            
            
            if(enemy.position.x < 200 ) {
                
              
                moving = true
            }
            
            if(enemy.position.x > 0 - 150 )
            {
                
               
                moving = false
            }
            
        
            
            
            if(moving){
                if ( enemy.position.x > 0 )
                {
                
                    enemy.position.x = enemy.position.x + 10
                    
                    
                    let lookRightAction = SKAction.scaleX(to: 1 , duration:0)
                    enemy.run(lookRightAction)
                
                    
                }
                
            }
            else{
                
            if(enemy.position.x < 0)
            {
                     enemy.position.x = enemy.position.x - 10
                    
                    let lookLeftAction = SKAction.scaleX(to: -1, duration:0)
                    enemy.run(lookLeftAction)
                    
                    
                }
            }
        
        }
        
        // win condition
        if (self.enemies.isEmpty) {
            
            youLose()
        }
        // MARK: R2: detect collisions between zombie and cat
        for (arrayIndex, temp) in enemies.enumerated() {
            if (self.player.intersects(temp) == true) {
                print("CAT COLLISION DETECTED!")
                
                spawnEgg()
                
                
                // 1. increase the score
//                self.score = self.score + 1
//                self.scoreLabel.text = "Score: \(self.score)"
//                self.randX = Int.random(in: -308...308)
//                self.randY = Int.random(in: -599...599)
                // 2. remove the cat from the scene
                print("Removing cat at position: \(arrayIndex)")
                // ---- 2a. remove from the array
                if(!self.enemies.isEmpty){
                self.enemies.remove(at: arrayIndex)
                }
                // ---- 2b. remove from scene (undraw the cat)
                temp.removeFromParent()
                
            }
        } // end for loop
        
        if (timeOfLastUpdate == nil) {
            timeOfLastUpdate = currentTime
        }
        
         for (arrayIndex, temp) in eggs.enumerated() {
        // print a message every 3 seconds
        let timePassed = (currentTime - timeOfLastUpdate!)
        if (timePassed >= 6 ) {
            print("HERE IS A MESSAGE!")
            timeOfLastUpdate = currentTime
            // make a cat
            self.eggs.remove(at: arrayIndex)
            temp.removeFromParent()
            self.spawnEnemy()
        }
        }
        
        // MARK: R2: detect collisions between player and egg
        for (arrayIndex, temp) in eggs.enumerated() {
            if (self.player.intersects(temp) == true) {
                // 1. increase the score
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
                
               // spawnEnemy()
                
                
                if (self.eggs.isEmpty) {
                    
                    youWin()
                    
                }
                
                // 2. remove the cat from the scene
                print("Removing cat at position: \(arrayIndex)")
                // ---- 2a. remove from the array
                self.eggs.remove(at: arrayIndex)
                
                // ---- 2b. remove from scene (undraw the cat)
                temp.removeFromParent()
            }
        } // end for lo
        
        
        
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
                
                
                
                
                print("right : x\(self.player.position.x)")
                
            }
            else
            {
                self.player.position.x = 0 - 250
               
            }
            
            
        }
            
        else if(xpos < 0)
        {
            
            if(self.player.position.x > 0 - 300 )
            {
                
                self.player.position.x = self.player.position.x - 100
                
                let lookLeftAction = SKAction.scaleX(to: -2, duration:0)
                self.player.run(lookLeftAction)
                
                print("left : x\(self.player.position.x)")
                
            }
                
            else
            {
                self.player.position.x = 250
                
            }
            
            
        }
        
    }
    
    
    
  
    
    func spawnEnemy() {
        // lets add some cats
        let enemy = SKSpriteNode(imageNamed: "enemy")
        
        let randX = Int.random(in: -308...308)
        let randY = Int.random(in: -599...599)
        
        enemy.position = CGPoint(x:randX, y:randY)
        
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!,
                                               size: enemy.texture!.size())
        
        enemy.physicsBody?.affectedByGravity = true
        
        enemy.physicsBody?.restitution = 0.75
        enemy.physicsBody?.isDynamic = true
        
        // set the bed category to 4
        enemy.physicsBody?.categoryBitMask = 4
        
        // set the collision mask = 0
       // enemy.physicsBody?.collisionBitMask = 8
        
        // add the cat to the scene
        addChild(enemy)
        
        // add the cat to the cats array
        self.enemies.append(enemy)
    }
    
    
    
    
    
    func spawnEgg() {
        // lets add some cats
        let egg = SKSpriteNode(imageNamed: "egg")
        
        let randX = Int.random(in: -308...308)
        let randY = Int.random(in: -599...599)
        
        egg.position = CGPoint(x:randX, y:randY)
        
        egg.physicsBody = SKPhysicsBody(texture: egg.texture!,
                                          size: egg.texture!.size())
        
        egg.physicsBody?.affectedByGravity = true
        
        egg.physicsBody?.restitution = 0.75
        egg.physicsBody?.isDynamic = true
        
        // set the bed category to 4
        egg.physicsBody?.categoryBitMask = 4
        
        // set the collision mask = 0
        // enemy.physicsBody?.collisionBitMask = 8
        
        // add the cat to the scene
        addChild(egg)
        
        // add the cat to the cats array
        self.eggs.append(egg)
    }
    
    
 
    
    func youWin() {
       
        let WinScene = SKScene(fileNamed:"WinScene")
        WinScene!.scaleMode = .aspectFill
        let flipTransition = SKTransition.flipVertical(withDuration: 2)
        self.scene?.view?.presentScene(
            WinScene!,
            transition: flipTransition)
       
    }
    
    func youLose() {
        
        let gameOverScene = SKScene(fileNamed:"GameOverScene")
        gameOverScene!.scaleMode = .aspectFill
        let flipTransition = SKTransition.flipVertical(withDuration: 2)
        self.scene?.view?.presentScene(
            gameOverScene!,
            transition: flipTransition)
        
        
    }
    
}
