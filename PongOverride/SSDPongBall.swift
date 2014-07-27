//
//  SSDPongBall.swift
//  EgoPong
//
//  Created by Markus Buhl on 13/06/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import Foundation
import SpriteKit

class SSDPongBall: SKNode {
    let ballShape:SKSpriteNode
    var ballColor:UIColor = UIColor(red: 0.94, green: 0.921, blue: 0.8, alpha: 1)
    init(rect:CGRect, image:UIImage?) {
        let ballShapeRect = CGRectMake(0,0, rect.width, rect.height)
        ballShape = SKSpriteNode()
        if let ballImage = image {
            ballShape.texture = SKTexture(image: ballImage)
        }
        
        ballShape.size = ballShapeRect.size
        ballShape.position = ballShapeRect.origin
        ballShape.color = ballColor
        super.init()
        
        self.position = rect.origin
        self.addChild(ballShape)
        
    }
    
    var texture:SKTexture? {
    get {
        return ballShape.texture
        
    }
    set(texture) {
        ballShape.texture = texture
    }
    }
    
    var diameter:CGFloat {
    get {
        return ballShape.size.width
    }
    set(newWidth) {
        ballShape.size = CGSizeMake(newWidth, newWidth)
    }
    }
    
}