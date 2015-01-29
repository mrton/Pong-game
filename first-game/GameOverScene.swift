//
//  GameOverScene.swift
//  first-game
//
//  Created by ton mangmee on 29/01/15.
//  Copyright (c) 2015 Ton10. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, player1Won: Bool, player2Won: Bool) {
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "space")
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(background)

        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.fontSize = 20
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        if player1Won {
            gameOverLabel.text = "Player 1 Won!!"
        }else {
            gameOverLabel.text = "Player 2 Won!!"
        }
        self.addChild(gameOverLabel)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let PongGameScene = GameScene(size: self.size)
        self.view?.presentScene(PongGameScene)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
