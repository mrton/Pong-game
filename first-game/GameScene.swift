//
//  GameScene.swift
//  first-game
//
//  Created by ton mangmee on 20/01/15.
//  Copyright (c) 2015 Ton10. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    //sound
    let helicopterName = "helicopter"
    let ballCategoryName = "ball"
    let paddleCategoryName = "paddle"
    let backgroundMusicPlayer = AVAudioPlayer()
    
    override init(size:CGSize) {
        super.init(size: size)
        
        //sound
        let bgMusicURL = NSBundle.mainBundle().URLForResource("bgMusic", withExtension: "mp3")
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        //background
        let backgroundImage = SKSpriteNode(imageNamed: "bamboo")
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        self.addChild(backgroundImage)
        
        self.physicsWorld.gravity = CGVectorMake(0,0)
        
        let worldBorder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody?.friction = 0
        
        let helicopter = SKSpriteNode(imageNamed: "helicopter")
        helicopter.name = helicopterName
        helicopter.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/4)
        self.addChild(helicopter)
        
        helicopter.physicsBody = SKPhysicsBody(circleOfRadius: helicopter.frame.size.width/4)
        helicopter.physicsBody?.friction = 0
        helicopter.physicsBody?.restitution = 1
        helicopter.physicsBody?.linearDamping = 0
        helicopter.physicsBody?.allowsRotation = false
        helicopter.xScale = -helicopter.xScale
        
        helicopter.physicsBody?.applyImpulse(CGVectorMake(20, -20))
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballCategoryName
        ball.position = CGPointMake(self.frame.size.width/4, self.frame.size.height/4)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/4)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        ball.xScale = -ball.xScale
        
        ball.physicsBody?.applyImpulse(CGVectorMake(2, -2))
        
        //----------------PADDLE-------------------
        
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleCategoryName
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 2)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
