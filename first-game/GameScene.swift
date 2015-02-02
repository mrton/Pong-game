//
//  GameScene.swift
//  first-game
//
//  Created by ton mangmee on 20/01/15.
//  Copyright (c) 2015 Ton10. All rights reserved.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var fingerIsOnPaddle1 = false
    var fingerIsOnPaddle2 = false
    var scores: [Int] = [0,0]
    var updates = 0
    var counts = 0
    
    let ballCategoryName = "ball"
    let paddleCategoryName1 = "paddle1"
    let paddleCategoryName2 = "paddle2"
    
    let backgroundMusicPlayer = AVAudioPlayer()
    let scoreText = SKLabelNode(fontNamed: "Chalkduster" )
    let hitsText = SKLabelNode(fontNamed: "Chalkduster")
    
    // bitmasks for collision detection
    
    let ballCategory:UInt32 = 0x1 << 0
    let bottomCategory:UInt32 = 0x1 << 1
    let topCategory:UInt32 = 0x1 << 2
    let paddleCategory1:UInt32 = 0x1 << 3
    let paddleCategory2:UInt32 = 0x1 << 4
    
    override init(size:CGSize) {
        super.init(size: size)
        
        self.physicsWorld.contactDelegate = self
        
        
        
        //sound
        let bgMusicURL = NSBundle.mainBundle().URLForResource("Super Bell Hill (SM 3D World) - Super Smash Bros. Wii U", withExtension: "mp3")
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        //background image
        let backgroundImage = SKSpriteNode(imageNamed: "space")
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        self.addChild(backgroundImage)
        
        //frame
        self.physicsWorld.gravity = CGVectorMake(0,0)
        let worldBorder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody?.friction = 0
        
        //---------------scoretext-----------------
        
        self.scoreText.text = "0 - 0"
        self.scoreText.fontSize = 30
        self.scoreText.position = CGPointMake(self.frame.size.width - self.frame.size.width/8, self.frame.size.height - self.frame.size.height/8)
        self.addChild(scoreText)
        
        //-----------------hit-text-----------------
        
        self.hitsText.text = "hits: 0"
        self.hitsText.fontSize = 30
        self.hitsText.position = CGPointMake(self.frame.size.width/6 , self.frame.size.height - self.frame.size.height/8)
        self.addChild(hitsText)

        
        //-----------------BALL--------------------
    
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballCategoryName
        ball.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/4)
        self.addChild(ball)
        
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/4)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.applyImpulse(CGVectorMake(0.5, -0.5))
        
        //----------------PADDLES-------------------
        
        let paddle1 = SKSpriteNode(imageNamed: "paddle")
        let paddle2 = SKSpriteNode(imageNamed: "paddle")
        paddle1.name = paddleCategoryName1
        paddle2.name = paddleCategoryName2
        paddle1.position = CGPointMake(CGRectGetMidX(self.frame), paddle1.frame.size.height * 2)
        paddle2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)*2 - paddle2.frame.size.height*2)
        
        self.addChild(paddle1)
        self.addChild(paddle2)
        
        paddle1.physicsBody = SKPhysicsBody(rectangleOfSize: paddle1.frame.size)
        paddle2.physicsBody = SKPhysicsBody(rectangleOfSize: paddle2.frame.size)
        paddle1.physicsBody?.friction = 0.4
        paddle2.physicsBody?.friction = 0.4
        paddle1.physicsBody?.restitution = 0.1
        paddle2.physicsBody?.restitution = 0.1
        paddle1.physicsBody?.dynamic = false
        paddle2.physicsBody?.dynamic = false
        
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)
        let topRect = CGRectMake(self.frame.origin.x, self.frame.maxY, self.frame.size.width, 1)
        let bottom = SKNode()
        let top = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        top.physicsBody = SKPhysicsBody(edgeLoopFromRect: topRect)
        
        self.addChild(bottom)
        self.addChild(top)
        
        bottom.physicsBody?.categoryBitMask = bottomCategory
        top.physicsBody?.categoryBitMask = topCategory
        ball.physicsBody?.categoryBitMask = ballCategory
        paddle1.physicsBody?.categoryBitMask = paddleCategory1
        paddle2.physicsBody?.categoryBitMask = paddleCategory2
        
        top.physicsBody?.contactTestBitMask = ballCategory
        bottom.physicsBody?.contactTestBitMask = ballCategory
        paddle1.physicsBody?.contactTestBitMask = ballCategory
        paddle2.physicsBody?.contactTestBitMask = ballCategory
        
    }
        //--------MOVING PADDLE AROUND-------------
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        
        let body:SKPhysicsBody? = self.physicsWorld.bodyAtPoint(touchLocation)
        if body?.node?.name == paddleCategoryName1{
            println("Paddle1 touched")
            fingerIsOnPaddle1 = true
        
        }/* else if body?.node?.name == paddleCategoryName2{
            println("Paddle2 touched")
            fingerIsOnPaddle2 = true
        }
        */
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if fingerIsOnPaddle1 {
            let touch = touches.anyObject() as UITouch
            let touchLoc = touch.locationInNode(self)
            let prevTouchLoc = touch.previousLocationInNode(self)
            
            let paddle = self.childNodeWithName(paddleCategoryName1) as SKSpriteNode
            
            var newXPos = paddle.position.x + (touchLoc.x - prevTouchLoc.x)
            
            newXPos = max(newXPos, paddle.size.width / 2)
            newXPos = min(newXPos, self.size.width - paddle.size.width / 2)
            
            paddle.position = CGPointMake(newXPos, paddle.position.y)
        
        } else if fingerIsOnPaddle2 {
            let touch = touches.anyObject() as UITouch
            let touchLoc = touch.locationInNode(self)
            let prevTouchLoc = touch.previousLocationInNode(self)
            
            let paddle = self.childNodeWithName(paddleCategoryName2) as SKSpriteNode
            
            var newXPos = paddle.position.x + (touchLoc.x - prevTouchLoc.x)
            
            newXPos = max(newXPos, paddle.size.width / 2)
            newXPos = min(newXPos, self.size.width - paddle.size.width / 2)
            
            paddle.position = CGPointMake(newXPos, paddle.position.y)
        }

    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        fingerIsOnPaddle1 = false
        fingerIsOnPaddle2 = false
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        let paddle = self.childNodeWithName(paddleCategoryName2) as SKSpriteNode
        runPaddleAgent(paddle)
    }
    
    //----------CONTACT---------------
    
    func didBeginContact(contact: SKPhysicsContact) {
        let respawnPos = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        let update = 1
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()

        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            updates += 1
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            updates += 1
        }
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory{
            self.counts = 0
            hitsText.text = createHits(self.counts)
            if update == updates{
                scores[1] += 1
                scoreText.text = createScore(scores)
                if checkIfWon(scores[1]) {
                    let WinScene = GameOverScene(size: self.frame.size, player1Won: false, player2Won: true)
                    self.view?.presentScene(WinScene)
                } else {
                    firstBody.velocity = CGVectorMake(0.0, 0.0)
                    firstBody.node?.runAction(SKAction.moveTo(respawnPos, duration: 0.0))
                    delay(2.0) {
                        firstBody.velocity = CGVectorMake(0.0, 0.0)
                        firstBody.applyImpulse(CGVectorMake(-0.5, 0.5))
                    }
                }
                
            } else {
                updates-=2
                scoreText.text = createScore(scores)
                if checkIfWon(scores[1]) {
                    let WinScene = GameOverScene(size: self.frame.size, player1Won: false, player2Won: true)
                    self.view?.presentScene(WinScene)
                } else {
                    firstBody.velocity = CGVectorMake(0.0, 0.0)
                    firstBody.node?.runAction(SKAction.moveTo(respawnPos, duration: 0.0))
                    
                    
                    delay(2.0) {
                        firstBody.velocity = CGVectorMake(0.0, 0.0)
                        firstBody.applyImpulse(CGVectorMake(-0.5, 0.5))
                    }
                }
            }

        } else if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == topCategory {
            self.counts = 0
            hitsText.text = createHits(self.counts)
            if update == updates{
                scores[0] += 1
                scoreText.text = createScore(scores)
                if checkIfWon(scores[0]) {
                    let WinScene = GameOverScene(size: self.frame.size, player1Won: true, player2Won: false)
                    self.view?.presentScene(WinScene)
                } else {
                    firstBody.velocity = CGVectorMake(0.0, 0.0)
                    firstBody.node?.runAction(SKAction.moveTo(respawnPos, duration: 0.0))
                    delay(2.0) {
                        firstBody.velocity = CGVectorMake(0.0, 0.0)
                        firstBody.applyImpulse(CGVectorMake(-0.5, 0.5))
                    }
                    
                }
                
                    
            } else {
                scores[0] += 1
                scoreText.text = createScore(scores)
                if checkIfWon(scores[0]) {
                    let WinScene = GameOverScene(size: self.frame.size, player1Won: true, player2Won: false)
                    self.view?.presentScene(WinScene)
                } else {
                    updates-=2
                    firstBody.velocity = CGVectorMake(0.0, 0.0)
                    firstBody.node?.runAction(SKAction.moveTo(respawnPos, duration: 0.0))
                    
                    delay(2.0) {
                        firstBody.velocity = CGVectorMake(0.0, 0.0)
                        firstBody.applyImpulse(CGVectorMake(-0.5, 0.5))
                    }
                    
                }
            }
            
        } else if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == paddleCategory1 {
            self.counts += 1
            hitsText.text = createHits(self.counts)
            println(self.counts)
            if self.counts == 9{
                firstBody.velocity = CGVectorMake(0.0, 0.0)
                firstBody.node?.runAction(SKAction.moveTo(respawnPos, duration: 2.0))
                delay(3.0) {
                    firstBody.velocity = CGVectorMake(0.0, 0.0)
                    firstBody.applyImpulse(CGVectorMake(-0.8, 0.8))
                }
            }
            
            if self.counts > 19 {
                firstBody.velocity = CGVectorMake(0.0, 0.0)
                firstBody.node?.runAction(SKAction.moveTo(respawnPos, duration: 2.0))
                delay(3.0) {
                    firstBody.velocity = CGVectorMake(0.0, 0.0)
                    firstBody.applyImpulse(CGVectorMake(-1.1, 1.1))
                }
            }
            
        } else if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == paddleCategory2 {
            self.counts += 1
            hitsText.text = createHits(self.counts)
            println(self.counts)
            if self.counts > 9{
                firstBody.velocity = CGVectorMake(0.0, 0.0)
                firstBody.node?.runAction(SKAction.moveTo(respawnPos, duration: 2.0))
                delay(3.0) {
                    firstBody.velocity = CGVectorMake(0.0, 0.0)
                    firstBody.applyImpulse(CGVectorMake(-0.8, 0.8))
                }
            }
            if self.counts > 19 {
                firstBody.velocity = CGVectorMake(0.0, 0.0)
                firstBody.node?.runAction(SKAction.moveTo(respawnPos, duration: 2.0))
                delay(3.0) {
                    firstBody.velocity = CGVectorMake(0.0, 0.0)
                    firstBody.applyImpulse(CGVectorMake(-1.1, 1.1))
                }
            }
        }
    }
    
    
    //-----------HELPER FUNCTIONS---------
    
    func runPaddleAgent(paddle: SKSpriteNode){
        if paddle.position.x == CGRectGetMidX(self.frame) {
            paddle.runAction(SKAction.moveToX(self.frame.size.width - paddle.size.width/2, duration: 0.4))
        } else if paddle.position.x == self.frame.size.width - paddle.size.width/2 {
            paddle.runAction(SKAction.moveToX(paddle.size.width/2, duration: 0.8))
        } else if paddle.position.x == paddle.size.width/2 {
            paddle.runAction(SKAction.moveToX(self.frame.size.width - paddle.size.width/2, duration: 0.8))
        }
        
    }
    
    
    func createScore(score: [Int])-> String{
        var player1 = score[0]
        var player2 = score[1]
        return "\(player1)-\(player2)"
    }
    
    func createHits(hits: Int)-> String{
        return "hits: \(hits)"
    }
    
    func checkIfWon(score: Int)->Bool{
        if score == 21{
            return true
        }
        return false
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
