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
    
    //Array of sprites
    var enemies:[SKSpriteNode] = []
    var eggs:[SKSpriteNode] = []
    
    // GAME STAT SPRITES
    let livesLabel = SKLabelNode(text: "Lives: ")
    let scoreLabel = SKLabelNode(text: "Score: ")
    
    //game sound variables
    var audio = SKAudioNode(fileNamed: "music.wav")
    var walkaudio = SKAudioNode(fileNamed: "walk.wav")
    
    //flag
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
    
    //---------------------------------
    // MARK: Did Move
    //-------------------------------
    
    override func didMove(to view: SKView)
    {
        // Required for SKPhysicsContactDelegate
        self.physicsWorld.contactDelegate = self
        
       // physical body to the frame
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    
        
        // MARK: initialize swipes
        
        //Swipe Up
        let swipeUp = UISwipeGestureRecognizer(target: self,
        action: #selector(GameScene.swipeUp(sender:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        //Swipe Down
        let swipeDown = UISwipeGestureRecognizer(target: self,
        action: #selector(GameScene.swipeDown(sender:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        
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
        
        //MARK: Adding Childs to the screen
        addChild(self.livesLabel)
        addChild(self.scoreLabel)
        addChild(self.audio)
        
        for i in 0 ... 5 {

            spawnEnemy()
            
        }
       
        
        // intialize your sprite variables
        self.player = self.childNode(withName: "player")
       
        
        // MARK:Show animation for player
        // ----------------------------
        // 1. make an array of images for the animation
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
    
    
    //---------------------------------
    // MARK:Update Function
    //-------------------------------
    
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
            
            
            if(moving)
            {
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
        
        // lose condition
        if (self.enemies.isEmpty) {
            youLose()
        }
        
        // MARK:  detect collisions between zombie and cat
        for (arrayIndex, temp) in enemies.enumerated()
        {
            if (self.player.intersects(temp) == true)
            {
                
                spawnEgg()
                
                // 1. Reduce the lives
               // self.lives = self.lives - 1

                // 2. remove the enemy from the scene
                print("Removing cat at position: \(arrayIndex)")
                // ---- 2a. remove from the array
                if(self.enemies.count > 0){
                self.enemies.remove(at: arrayIndex)
                }
                // ---- 2b. remove from scene (undraw the enemy)
                temp.removeFromParent()
                
            }
        } // end for loop
        
        //MARK: egg converts into enemy
        if (timeOfLastUpdate == nil)
        {
            timeOfLastUpdate = currentTime
        }
        
         for (arrayIndex, temp) in eggs.enumerated()
         {
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
        
        // MARK: detect collisions between player and egg
        for (arrayIndex, temp) in eggs.enumerated() {
            if (self.player.intersects(temp) == true) {
                
                // 1. increase the score
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
                
                if (self.eggs.isEmpty) {
                    youWin()
                }
                
                // 2. remove the egg from the scene
                print("Removing cat at position: \(arrayIndex)")
                // ---- 2a. Remove from the array
                if(self.eggs.count > 0){
                    self.eggs.remove(at: arrayIndex)
                }
                
                // ---- 2b. remove from scene (undraw the cat)
                temp.removeFromParent()
            }
        } // end for lo
        
        
        
    }
    
    
    //---------------------------------
    // MARK:Swipe up
    //-------------------------------
    
    @objc func swipeUp(sender: UISwipeGestureRecognizer)
    {
        // Handle the swipe

        if(self.player.position.x < 350 ) {
            
           self.player.position.y = self.player.position.y + 300
         
            let lookRightAction = SKAction.scaleX(to: 2, duration:0)
            self.player.run(lookRightAction)
         
        }
        else
        {
            self.player.position.x = 0 - 250
            
        }
        
    }
    
    //---------------------------------
    // MARK:Swipe Down
    //-------------------------------
    
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        // Handle the swipe
      
        if(self.player.position.x > 0 - 300 )
        {
             self.player.position.y = self.player.position.y - 300
            
            let lookLeftAction = SKAction.scaleX(to: -2, duration:0)
            self.player.run(lookLeftAction)
            
        }
            
        else
        {
            self.player.position.x = 250
        }
        
    }
    
    
    //---------------------------------
    // MARK:Touch began
    //-------------------------------
    
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
        
        //ddChild(self.walkaudio)
        
        let xpos = mouseLocation.x
        //print(half)
        if ( xpos > 0 )
        {
            
            if(self.player.position.x < 200 ) {
                
                // Move to right
                self.player.position.x = self.player.position.x + 100

                let lookRightAction = SKAction.scaleX(to: 2, duration:0)
                self.player.run(lookRightAction)
                
            }
            else
            {
                self.player.position.x = 0 - 250
               
            }
            
            
        }
            
        else if(xpos < 0)
        {
            
            if(self.player.position.x > 0 - 200 )
            {
                //move to left
                self.player.position.x = self.player.position.x - 100
                
                let lookLeftAction = SKAction.scaleX(to: -2, duration:0)
                self.player.run(lookLeftAction)
                
                
            }
                
            else
            {
                self.player.position.x = 250
                
            }
            
        }
        
    }
    
    
    
  //--------------------------------
    // MARK: Make a Spwan of Enemies
//-----------------------------------
    func spawnEnemy() {
        // Add an emeny
        let enemy = SKSpriteNode(imageNamed: "enemy")
        
        //put it at a random position
        let randX = Int.random(in: -308...308)
        let randY = Int.random(in: -599...599)
        
        enemy.position = CGPoint(x:randX, y:randY)
        
        // Add physics body
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!,
                                               size: enemy.texture!.size())
        
        enemy.physicsBody?.affectedByGravity = true
        enemy.physicsBody?.restitution = 0.75
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = 3
        
        // add the enemy to the scene
        addChild(enemy)
        
        // add the enemy to the enemies array
        self.enemies.append(enemy)
    }
    
    //---------------------------------
    // MARK:Make a Spwan of Eggs
    //-------------------------------
    
    func spawnEgg() {
       
        let egg = SKSpriteNode(imageNamed: "egg")
        
        let randX = Int.random(in: -308...308)
        let randY = Int.random(in: -599...599)
        
        egg.position = CGPoint(x:randX, y:randY)
        
        egg.physicsBody = SKPhysicsBody(texture: egg.texture!,
                                          size: egg.texture!.size())
        
        egg.physicsBody?.affectedByGravity = true
        egg.physicsBody?.restitution = 0.75
        egg.physicsBody?.isDynamic = true
        egg.physicsBody?.categoryBitMask = 4
        
        // add the egg to the scene
        addChild(egg)
        
        // add the egg to the eggs array
        self.eggs.append(egg)
    }
    
    
    //---------------------------------
    // MARK:Win Condition
    //-------------------------------
    
    func youWin() {
       
//        let WinScene = SKScene(fileNamed:"WinScene")
//        WinScene!.scaleMode = .aspectFill
//        let flipTransition = SKTransition.flipVertical(withDuration: 2)
//        self.scene?.view?.presentScene(
//            WinScene!,
//            transition: flipTransition)
       
    }
    
    
    //---------------------------------
    // MARK:Loose Condition
    //-------------------------------
    
    func youLose() {
        
//        let gameOverScene = SKScene(fileNamed:"GameOverScene")
//        gameOverScene!.scaleMode = .aspectFill
//        let flipTransition = SKTransition.flipVertical(withDuration: 2)
//        self.scene?.view?.presentScene(
//            gameOverScene!,
//            transition: flipTransition)
        
        
    }
    
}
