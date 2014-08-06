//
//  GameScene.swift
//  EgoPong
//
//  Created by Markus Buhl on 07/06/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import SpriteKit
import AudioToolbox
import UIKit
import CoreMotion
import Foundation

//iOS 7 doesn't have it, iOS 8 does: the Contact normal
//to avoid varying user experiences and harder maintenance, we're not overriding the contactNormal,
//but instead implementing our own
extension SKPhysicsContact {
var ssdContactNormal:CGVector {
get {
    func calculateAbsoluteRotation(node:SKNode) ->CGFloat {
        var accumulatedRotation:CGFloat = 0.0
        var tempNode:SKNode = node
        while true {
            accumulatedRotation += tempNode.zRotation
            if tempNode.parent == nil {
                break
            } else {
                tempNode = tempNode.parent
            }
        }
        return accumulatedRotation
    }
    let angleInDeg = MBMath_radiansToDegrees(Float(self.bodyA.node.zRotation))
    let b = 1.0 / cosf(angleInDeg)
    println("Vector dy: \(b)")
    println("Impulse \(self.collisionImpulse)")
    
return CGVectorMake(1, 1)
}
}//var contactNormal
    
}

class SSDGameScene: SKScene, SKPhysicsContactDelegate {
    
    //Collision masks
    let paddleCategory:UInt32 = 0x1 << 0
    let ballCategory:UInt32 = 0x1 << 1
    let powerUpCategory:UInt32 = 0x1 << 2
    let sceneBoundariesCategory:UInt32 = 0x1 << 3
    
    //The base turning Disc, used to position the paddle
    let baseDisc = SKSpriteNode(texture: SKTexture(image:getImageInMainBundle("Circle", "png")))
    var baseDiscCenter:CGPoint?
    var baseDiscRotationOffset:Float = 0.0    //store the rotation offset in a global var
    var initialTouchToDiscAngle:Float = 0.0
    let baseDiscRotationAcceleration:Float = 1.0 // 1 equals no acceleration, values > 1 = acceleration, values < 1 = deceleration
    
    //the paddle
    let paddle = SKSpriteNode(imageNamed: "paddle")
    
    //the ball
    let ballImage = UIImage(named: "ball")
    let ball = SSDPongBall(rect: CGRectMake(0, 0, 20, 20), image:nil)
    var ballPrePauseImpulseVector = CGVectorMake(0, 0)
    
    /* Ball Impact sound */
    var impactSound = SKAction.playSoundFileNamed("impact.wav", waitForCompletion: false)
    
    /* Score */
    var highScore = 0 // High Score
    let highScoreLabel = SKLabelNode(fontNamed:"HelveticaNeue-Light") // High Score Label
    var score = 0 //the score
    let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light") //the score label
    
    /* Menus */
    let pauseMenu = SSDPauseMenu(rect: CGRectMake(0, 0, 150, 50))
    let pauseButton = SKSpriteNode(imageNamed: "pause_button")
    let pauseButtonBackupShape:SKShapeNode = SKShapeNode()
    
    let mainMenu:SSDMainMenu = SSDMainMenu(size: nil)
    
    let postGameMenu:SSDPostGameMenu = SSDPostGameMenu(size: nil)
    
    /* start info tag */
    let startHintNode = SKNode()
    let startHintLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
    let startHintArrow = SKSpriteNode(imageNamed: "scroll_arrow")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.userInteractionEnabled = true
        
        /* Because of the way the scene is calculated to fit the screen, part of it is cropped, so we need to fill in our own values */
        self.size.width = view.frame.width
        self.size.height = view.frame.height
        
        /* temporary constants */
        let xMid = self.size.width * 0.5
        let yMid = self.size.height * 0.5
        
        /* the score label */
        println("phone width: \(self.frame.width) and phone: \(self.frame.height)")
        scoreLabel.position = CGPoint(x: xMid, y: self.frame.height * 0.9)
        scoreLabel.text = String(score)
        scoreLabel.fontSize = CGFloat(GLOBAL_PONG_FONTSIZE.Medium)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreLabel.fontColor = GLOBAL_PONGCOLOR_BEIGE
        
        /* high score label */
        highScoreLabel.position = CGPoint(x: xMid, y: self.size.height * 0.859)
        highScoreLabel.text = ""
        highScoreLabel.fontSize = CGFloat(GLOBAL_PONG_FONTSIZE.Small)
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        highScoreLabel.fontColor = GLOBAL_PONGCOLOR_BEIGE
        
        /* Scene physics */
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody.dynamic = false
        self.physicsBody.categoryBitMask = sceneBoundariesCategory
        
        /* Base Disc the player will interact with */
        baseDiscCenter = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        baseDisc.position = baseDiscCenter!
        baseDisc.size.width = self.size.width * 0.9
        println("Disc: \(baseDisc.size.width)")
        baseDisc.size.height = baseDisc.size.width
        
        /* The paddle */
        paddle.position = CGPoint(x: 0, y: baseDisc.size.height * 0.495)
        paddle.size.width = baseDisc.size.width * 0.16
        paddle.size.height = paddle.size.width / 5.5
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.size)
        paddle.physicsBody.mass = 100
        paddle.physicsBody.dynamic = false
        paddle.physicsBody.categoryBitMask = paddleCategory
        paddle.physicsBody.collisionBitMask = ballCategory
        paddle.physicsBody.contactTestBitMask = ballCategory
        
        /* The Ball */
        ball.texture = SKTexture(imageNamed: "ball")
        ball.position = baseDiscCenter!
        ball.diameter = baseDisc.size.width * 0.04
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.diameter/2)
        
        //Ball physics properties
        ball.physicsBody.dynamic = true
        ball.physicsBody.categoryBitMask = ballCategory
        ball.physicsBody.collisionBitMask = paddleCategory | ballCategory | powerUpCategory
        ball.physicsBody.contactTestBitMask = paddleCategory | ballCategory | powerUpCategory | sceneBoundariesCategory
        ball.physicsBody.mass = 1
        ball.physicsBody.restitution = 0
        ball.physicsBody.linearDamping = 0.0
        ball.physicsBody.usesPreciseCollisionDetection = true
        
        /* Main Menu */
        mainMenu.size.width = self.frame.size.width
        mainMenu.size.height = self.frame.size.height
        
        println("Main Menu has width \(mainMenu.calculateAccumulatedFrame().width) and height: \(mainMenu.calculateAccumulatedFrame().height)")
        
        /* Pause Button */
        pauseButton.color = GLOBAL_PONGCOLOR_BEIGE
        pauseButton.position = CGPoint(x: self.frame.width * 0.1, y: self.frame.height * 0.07)
        pauseButton.size.width = 25
        pauseButton.size.height = pauseButton.size.width
        pauseButtonBackupShape.lineWidth = 0
        let pauseButtonBackupShapePathRect = CGRectMake(-pauseButton.size.width/1.7, -pauseButton.size.height/1.7, pauseButton.size.width*1.2, pauseButton.size.height*1.2)
        pauseButtonBackupShape.path = CGPathCreateWithRect(pauseButtonBackupShapePathRect, nil)
        pauseButton.addChild(pauseButtonBackupShape)
        /* Pause Menu */
        pauseMenu.size = self.frame.size
        
        pauseMenu.menuButton.action = { () in self.setupInitialGameState()
            println("Hidden? \(self.pauseMenu.menuButton.hidden)")
            SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStateInMenu) }
        
        pauseMenu.continueButton.action = { () in SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStatePregame) }
        
        /* Post Game Menu */
        postGameMenu.size = self.frame.size
        
        /* Start Hint Tag */
        startHintLabel.text = "Touch to start"
        startHintLabel.fontColor = GLOBAL_PONGCOLOR_BEIGE
        startHintLabel.fontSize = 10
        
        startHintLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        startHintLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        startHintNode.position.x = baseDiscCenter!.x
        startHintNode.position.y = baseDiscCenter!.y - baseDisc.size.width/2 - 35
        
        startHintArrow.xScale = 0.12
        startHintArrow.yScale = 0.12
        
        startHintArrow.position.y = 18
        
        startHintNode.addChild(startHintArrow)
        
        startHintNode.addChild(startHintLabel)
        
        /* Creating the node tree */
        self.addChild(baseDisc)
        baseDisc.addChild(paddle)
        self.addChild(ball)
        self.addChild(scoreLabel)
        self.addChild(highScoreLabel)
        self.addChild(pauseMenu)
        self.addChild(pauseButton)
        self.addChild(mainMenu)
        self.addChild(startHintNode)
        self.addChild(postGameMenu)
        
        
        //Set up options
        let settingControls:Int = NSUserDefaults.standardUserDefaults().integerForKey("OptionControls")
        let settingSound:Int = NSUserDefaults.standardUserDefaults().integerForKey("OptionSound")
        let settingVibrate:Int = NSUserDefaults.standardUserDefaults().integerForKey("OptionVibration")
        
        SSDGameSimulation.sharedSimulation().gameOptions = UInt32(settingControls | settingSound | settingVibrate)
        
        highScore = NSUserDefaults.standardUserDefaults().integerForKey("Highscore")
        
        //We're ready
        self.mainMenu.optionSubMenu.updateAllOptions()
        setupInitialGameState()
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)
        
        //This app only supports single touches, so we only ever need the first object in the set
        let touch : AnyObject! = touches.anyObject()
        
        let location = touch.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(location)
        
        if SSDGameSimulation.sharedSimulation().gameState == GameState.GameStatePregame {
            startGame()
        }
        
        /* only execute this code if the options controller-options are set to touch */
        if SSDGameSimulation.sharedSimulation().gameOptions & GLOBAL_OPTION_CONTROLS == 0 {
            //the angle with which the touch occurs is always calculated from the center of the disc (= center of the screen)
            let center = baseDiscCenter!
            
            //Elementary trigonometry: get the two sides of the triangle
            let xDist = Float(location.x - center.x) //Adjacent
            let yDist = Float(location.y - center.y) //Opposite
            
            //Calculate the angle using the atan2 function, for it occurs in all four quadrants
            initialTouchToDiscAngle = -1 * atan2f(xDist, yDist)
        }
        
        
        
    }
    
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch starts moving */
        super.touchesMoved(touches, withEvent: event)
        
        //This app only supports single touches, so we only ever need the first object in the set
        let touch: AnyObject! = touches.anyObject()
        
        let location = touch.locationInNode(self)
        
        /* only execute this code if the options controller-options are set to touch */
        if SSDGameSimulation.sharedSimulation().gameOptions & GLOBAL_OPTION_CONTROLS == 0 {
            //again, we're using the center of the screen for our calculations
            let center = baseDiscCenter!
            
            let xDist = Float(location.x - center.x)
            let yDist = Float(location.y - center.y)
            
            let touchToDiscAngle = -1 * atan2f(xDist, yDist)
            
            //Calculation of the baseDisc rotation: because the baseDisc is used in a similar fashion
            
            //as a knob, we need to implement the offset of the rotation at the moment the user began touching
            baseDisc.zRotation = CGFloat(touchToDiscAngle) - CGFloat(initialTouchToDiscAngle) + CGFloat(baseDiscRotationOffset)
        }
        
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch ends */
        super.touchesEnded(touches, withEvent: event)
        
        let touch: AnyObject! = touches.anyObject()
        let location = touch.locationInNode(self)
        
        let touchedNode = self.nodeAtPoint(location)
        
        
        switch(SSDGameSimulation.sharedSimulation().gameState) {
        case .GameStatePregame:
            if touchedNode == self.pauseButton {
                SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStatePaused)
            }
        case .GameStateInGame:
            if touchedNode == self.pauseButton || touchedNode.inParentHierarchy(self.pauseButton) {
                SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStatePaused)
            }
        default:
            println("Touched: \(touchedNode.name)")
            println("Button was touched. Event forwarded.")
        }
        
        /* only do this if options are set to touch */
        if SSDGameSimulation.sharedSimulation().gameOptions & GLOBAL_OPTION_CONTROLS == 0 {
            baseDiscRotationOffset = Float(baseDisc.zRotation)
        }
        
        
        
    }
    
    /* Accelerometer Controls */
    
    
    func activateMotionDataIntake() {
        println("vg called")
        SSDGameSimulation.sharedSimulation().gameMotionManager.deviceMotionUpdateInterval = 0.02
        SSDGameSimulation.sharedSimulation().gameMotionManager.startDeviceMotionUpdatesUsingReferenceFrame(
            CMAttitudeReferenceFrameXArbitraryZVertical,
            toQueue: NSOperationQueue(), withHandler: { (data:CMDeviceMotion!, error:NSError!) in
                dispatch_async(dispatch_queue_create("motionDataIntakeQueue", DISPATCH_QUEUE_CONCURRENT), { () in
                    let center = self.baseDiscCenter!
                    
                    let xDist = -Float(data.attitude.pitch)
                    let yDist = -Float(data.attitude.roll)
                    self.baseDisc.zRotation = CGFloat(atan2f(Float(yDist), Float(xDist)))
                    })
            })
    }
    
    func deactivateMotionDataIntake() {
        println("gyro deactivated")
        SSDGameSimulation.sharedSimulation().gameMotionManager.stopDeviceMotionUpdates()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //what happens while the game is running
        if SSDGameSimulation.sharedSimulation().gameState == GameState.GameStateInGame {
        }
        
    }
    
    func didBeginContact(contact:SKPhysicsContact!) {
        var firstBody:SKPhysicsBody?
        var secondBody:SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if secondBody!.categoryBitMask & sceneBoundariesCategory != 0 {
            postGameMenu.score = score
            if score > highScore {
                NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "Highscore")
            }
            SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStatePostGame)
            return
        }
        if secondBody!.categoryBitMask & ballCategory != 0 {
            
            let impulse = CGVectorMake(0, 0)//CGVectorMake(contact.contactNormal.dx * paddleImpulse, contact.contactNormal.dy * paddleImpulse)
            contact.ssdContactNormal
            //secondBody!.applyImpulse(impulse)
            ballPrePauseImpulseVector = impulse
            //add one to score
            scoreLabel.text = String(++score)
            //did we break the record?
            if score > highScore {
                highScoreLabel.text = "New Highscore!!!"
            }
            //intensify impulse
            GLOBAL_PADDLEIMPULSE++
            
            //vibrate?
            if SSDGameSimulation.sharedSimulation().gameOptions & GLOBAL_OPTION_VIBRATION > 0 {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
            if SSDGameSimulation.sharedSimulation().gameOptions & GLOBAL_OPTION_SOUNDFX > 0 {
                self.runAction(impactSound)
            }
            
        }
    }
    
    func setGameState(state:GameState) {
        switch(state) {
        case .GameStateInGame:
            ball.physicsBody.dynamic = true
            ball.physicsBody.applyImpulse(ballPrePauseImpulseVector)
            self.hidePauseMenu(true)
            self.hideGameUI(false)
            self.hidePostGameMenu(true)
        case .GameStatePostGame:
            self.hidePostGameMenu(false)
            self.hideGameUI(true)
            self.setupInitialGameState()
        case .GameStatePaused:
            ballPrePauseImpulseVector = ball.physicsBody.velocity
            ball.physicsBody.dynamic = false
            self.hideGameUI(true)
            self.hidePauseMenu(false)
            self.hidePostGameMenu(true)
        case .GameStatePregame:
            self.hideGameUI(false)
            self.hideMainMenu(true)
            self.hidePauseMenu(true)
            self.hidePostGameMenu(true)
        case .GameStateInMenu:
            self.hideMainMenu(false)
            self.hideGameUI(true)
            self.hidePauseMenu(true)
            self.hidePostGameMenu(true)
        }
        
        
    }
    
    func setupInitialGameState() {
        
        //Do we have a high score yet? Or a new one?
        if highScore == 0 {
            let h = "Highscore"
            println("Post Highscore: \(NSUserDefaults.standardUserDefaults().integerForKey(h))")
            highScore = score
        }
        if score > highScore {
            highScore = score
            self.mainMenu.updateHighscore()
        }
        //Print the high score on screen
        highScoreLabel.text = "Highscore: \(highScore)"
        
        //Reset the base Disc
        baseDiscRotationOffset = 0
        let resetBaseDiscRotationAction = SKAction.rotateToAngle(0, duration: 0)
        resetBaseDiscRotationAction.timingMode = SKActionTimingMode.EaseInEaseOut
        baseDisc.runAction(resetBaseDiscRotationAction)
        
        //Reset the ball
        ball.physicsBody.resting = true
        let resetBallAction = SKAction.moveTo(baseDiscCenter!, duration: 0)
        ball.runAction(resetBallAction)
        
        /* Reset Impulse */
        GLOBAL_PADDLEIMPULSE = 100
        
        /* Reset Score */
        score = 0
        scoreLabel.text = String(score)
        
    }
    
    func startGame() {
        let impulseVector = CGVectorMake(0, CGFloat(GLOBAL_INITIALIMPULSE))
        ball.physicsBody.applyImpulse(impulseVector)
        ballPrePauseImpulseVector = impulseVector
        SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStateInGame)
        startHintNode.hidden = true
    }
    
    func hideGameUI(hide:Bool) {
        self.baseDisc.hidden = hide
        self.ball.hidden = hide
        self.scoreLabel.hidden = hide
        self.highScoreLabel.hidden = hide
        self.pauseButton.hidden = hide
        self.startHintNode.hidden = hide
    }
    
    func hideMainMenu(hide:Bool) {
        mainMenu.hidden = hide
        if hide {
            mainMenu.position.x = 1000
        } else {
            mainMenu.position.x = 0
        }
    }
    
    func hidePauseMenu(hide:Bool) {
        println("Pause menu was hidden")
        pauseMenu.hidden = hide
        
        
    }
    
    func hidePostGameMenu(hide:Bool) {
        postGameMenu.hidden = hide
        if hide {
            postGameMenu.position.x = 1000
        } else {
            postGameMenu.position.x = 0
            postGameMenu.fadeInUI(delay: 0.2,andDuration: 0.3)
        }
    }
    
}
