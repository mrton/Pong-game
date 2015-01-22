//
//  Helicopter.swift
//  first-game
//
//  Created by ton mangmee on 20/01/15.
//  Copyright (c) 2015 Ton10. All rights reserved.
//

import Foundation
import SpriteKit

class Helicopter: SKSpriteNode {
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init (imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init (texture: imageTexture, color: nil, size: imageTexture.size())
       
        //self.physicsBody = SKPhysicsBody(rectangleOfSize: imageTexture.size())
        //self.physicsBody?.dynamic = true
        //self.physicsBody?.mass = 1
    }
    
    func makeBodyDynamic(){
        //self.physicsBody?.dynamic = true
    }


}