//
//  PauseMenu.swift
//  EgoPong
//
//  Created by Markus Buhl on 12/06/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import Foundation
import SpriteKit

/* PAUSE MENU */
//MARK: PAUSE MENU CLASS
class SSDPauseMenu: SKNode {
    let continueButton:SSDPongButton
    let menuButton:SSDPongButton
    let label:SKLabelNode
    var _size:CGSize
    
    init(rect:CGRect?) {
        
        continueButton = SSDPongButton(width: nil, andText: "Continue")
        menuButton = SSDPongButton(width: nil, andText: "Back to Menu")
        label = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        
        if let r = rect {
            
            _size = CGSizeMake(r.width, r.height)
        } else {
            _size = CGSizeZero
        }
        
        super.init()
        
        self.size = _size
        
        label.text = "Game paused!"
        label.fontSize = 20
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.fontColor = UIColor(red: 0.94, green: 0.921, blue: 0.8, alpha: 1)
        
        self.addChild(continueButton)
        self.addChild(menuButton)
        self.addChild(label)
    }
    
    var _hidden:Bool = false
    override var hidden:Bool {
    get {
        return _hidden
    }
    set(state) {
        super.hidden = state
        self.continueButton.hidden = state
        self.menuButton.hidden = state
        self.label.hidden = state
    }
    }
    
    
    var size:CGSize {
    get {
        return _size
    }
    set(newSize) {
        _size = newSize
        
        let midX = newSize.width / 2
        
        continueButton.position.y = newSize.height * 0.5
        continueButton.position.x = midX
        
        menuButton.position.y = newSize.height * 0.38
        menuButton.position.x = midX
        
        label.position.x = midX
        label.position.y = newSize.height * 0.7
        
    }
    }
    
    
}

/* MAIN MENU */
//MARK: MAIN MENU CLASS
enum MainMenuType {
    case Main
    case Highscore
    case Option
    case GameReset
}

class SSDMainMenu: SKNode {
    
    let mainMenuControlNode:SKNode
    
    let pongLogo = SKSpriteNode()
    
    let highscoreLabel = SKLabelNode()
    let highScoreScoreLabel = SKLabelNode()
    
    let newGameButton:SSDPongButton
    let optionButton:SSDPongButton
    
    let menuMovementDuration:NSTimeInterval = 0.5
    
    var _size:CGSize = CGSizeMake(0,0)
    
    let optionSubMenu:SSDOptionMenu
    let resetGameSubMenu:SSDPongGameResetMenu
    
    var _activeMenuType:MainMenuType = MainMenuType.Main
    
    init(size:CGSize?) {
        let logoImage = getImageInMainBundle("logo", "png")
        pongLogo.texture = SKTexture(image: logoImage)
        pongLogo.size = CGSizeMake(pongLogo.texture.size().width * 0.2, pongLogo.texture.size().height * 0.2)
        
        newGameButton = SSDPongButton(width: nil, andText: "New Game")
        
        optionButton = SSDPongButton(width: nil, andText: "Options")
        
        optionSubMenu = SSDOptionMenu()
        
        mainMenuControlNode = SKNode()
        
        resetGameSubMenu = SSDPongGameResetMenu()
        
        super.init()
        
        if let s = size {
            self.size = s
        }
        
        highscoreLabel.fontColor = GLOBAL_PONGCOLOR_BEIGE
        highscoreLabel.fontSize = 15
        highscoreLabel.fontName = "HelveticaNeue-Light"
        highscoreLabel.text = "Personal Best"
        
        highScoreScoreLabel.fontColor = highscoreLabel.fontColor
        highScoreScoreLabel.fontSize = 70
        highScoreScoreLabel.fontName = highscoreLabel.fontName
        highScoreScoreLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("Highscore")
        
        newGameButton.action = { () in SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStatePregame) }
        newGameButton.name = "MainMenuButton_NewGame"
        
        optionButton.action = { () in
            println("Clicked option")
            self.activeMenu = .Option
        }
        optionButton.name = "MainMenuButton_Options"
        self.addChild(mainMenuControlNode)
        
        mainMenuControlNode.addChild(pongLogo)
        mainMenuControlNode.addChild(highscoreLabel)
        mainMenuControlNode.addChild(highScoreScoreLabel)
        mainMenuControlNode.addChild(newGameButton)
        mainMenuControlNode.addChild(optionButton)
        mainMenuControlNode.addChild(optionSubMenu)
        mainMenuControlNode.addChild(resetGameSubMenu)
        
        optionSubMenu.position.x = 500
        resetGameSubMenu.position.x = 1000
        
        
    }
    
    var size:CGSize {
    get {
        return _size
    }
    
    set(size) {
        _size = size
        println("Menu size is: \(_size.width) and height: \(_size.height)")
        let midX = size.width/2
        pongLogo.position.x = midX
        pongLogo.position.y = size.height * 0.8
        
        newGameButton.position.x = midX
        newGameButton.position.y = size.height * 0.38
        
        optionButton.position.x = midX
        optionButton.position.y = size.height * 0.26
        
        highscoreLabel.position.x = midX
        highscoreLabel.position.y = size.height * 0.67
        
        highScoreScoreLabel.position.x = midX
        highScoreScoreLabel.position.y = size.height * 0.52
        
        //Set the sub menu's sizes to the same value
        optionSubMenu.size = size
        resetGameSubMenu.size = size
    }
    }
    
    func updateHighscore() {
        self.highScoreScoreLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("Highscore")
    }
    
    var activeMenu:MainMenuType {
    get {
        return _activeMenuType
    }
    set(type) {
        if type == _activeMenuType {
            return
        }
        
        switch(type) {
        case .Main:
            let moveToMainAction = SKAction.moveTo(CGPointMake(0,0), duration: menuMovementDuration)
            moveToMainAction.timingMode = SKActionTimingMode.EaseInEaseOut
            mainMenuControlNode.runAction(moveToMainAction)
            
        case .Option:
            let moveToOptionAction = SKAction.moveTo(CGPointMake(-500,0), duration: menuMovementDuration)
            moveToOptionAction.timingMode = SKActionTimingMode.EaseInEaseOut
            mainMenuControlNode.runAction(moveToOptionAction)
        case .GameReset:
            let moveToGameResetAction = SKAction.moveTo(CGPointMake(-1000,0), duration: menuMovementDuration)
            moveToGameResetAction.timingMode = SKActionTimingMode.EaseInEaseOut
            mainMenuControlNode.runAction(moveToGameResetAction)
        case .Highscore:
            println("What happens when highscore")
        }
        
        _activeMenuType = type
    }
    }
    
    
    
} // Class Main Menu

/* OPTION MENU */
//MARK: OPTION MENU CLASS
class SSDOptionMenu:SKNode {
    let headerLabel:SKLabelNode
    
    // The Control Options
    //let controlsLabel:SKLabelNode
    
    // Audio/Vibration options
    let soundFXOption:SSDPongOptionMenuDividedItem
    let vibrateOption:SSDPongOptionMenuDividedItem
    let controlsOption:SSDPongOptionMenuDividedItem
    
    //Game Reset Button
    let gameResetButton:SSDPongButton
    
    let backButton:SSDActionLabel
    
    var _size:CGSize
    
    var marginLeft:CGFloat = 10.0
    
    init() {
        self.headerLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        
        //self.controlsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        //self.controlsOption = SSDActionLabel(fontNamed: "HelveticaNeue-Light")
        let controlOptionSwitch = SSDOptionSwitchNode(labelON: "Tilt", labelOFF: "Touch")
        controlsOption = SSDPongOptionMenuDividedItem(option: controlOptionSwitch, optionTitle: "Control", optionDescription: "You can control the circle by either\nswiping or tilting your device")
        
        let soundFXOptionSwitch = SSDOptionSwitchNode(labelON: "ON", labelOFF: "OFF")
        self.soundFXOption = SSDPongOptionMenuDividedItem(option: soundFXOptionSwitch, optionTitle: "Sound", optionDescription: nil)
        
        let vibrateOptionSwitch = SSDOptionSwitchNode(labelON: "ON", labelOFF: "OFF")
        self.vibrateOption = SSDPongOptionMenuDividedItem(option: vibrateOptionSwitch, optionTitle: "Vibration", optionDescription: nil)
        
        self._size = CGSizeZero
        self.backButton = SSDActionLabel(fontNamed: "HelveticaNeue-Regular")
        
        self.gameResetButton = SSDPongButton(width: 100, andText: "Reset Game")
        
        super.init()
        
        headerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        let fontSize:CGFloat = 21.0
        let smallFontSize:CGFloat = 18.0
        
        headerLabel.fontSize = 20
        headerLabel.fontColor = GLOBAL_PONGCOLOR_BEIGE
        headerLabel.text = "Settings"
        
        controlsOption.optionNode.onClick = { () in
            let toggle = toggleMask(SSDGameSimulation.sharedSimulation().gameOptions, GLOBAL_OPTION_CONTROLS)
            SSDGameSimulation.sharedSimulation().gameOptions = toggle
            self.updateOptionControl()
        }
        
        soundFXOption.topDivider.hidden = true
        soundFXOption.bottomDivider.hidden = true
        soundFXOption.optionNode.onClick = { () in
            let toggle = toggleMask(SSDGameSimulation.sharedSimulation().gameOptions, GLOBAL_OPTION_SOUNDFX)
            SSDGameSimulation.sharedSimulation().gameOptions = toggle
            self.updateOptionSound()
            
        }
        
        vibrateOption.optionNode.onClick = { () in
            let toggle = toggleMask(SSDGameSimulation.sharedSimulation().gameOptions, GLOBAL_OPTION_VIBRATION)
            SSDGameSimulation.sharedSimulation().gameOptions = toggle
            println("Toggle: \(SSDGameSimulation.sharedSimulation().gameOptions & GLOBAL_OPTION_VIBRATION)")
            self.updateOptionVibration()
            
        }
        
        backButton.position.x = 0
        backButton.text = "< Back"
        backButton.fontColor = GLOBAL_PONGCOLOR_BEIGE
        backButton.fontSize = 20
        backButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        backButton.action = { () in SSDGameSimulation.sharedSimulation().setMenu(.Main) }
        
        gameResetButton.textColor = GLOBAL_PONGCOLOR_BEIGE
        gameResetButton.textColor = GLOBAL_PONGCOLOR_BEIGE
        gameResetButton.backgroundColor = UIColor(red: 0.94, green: 0.37, blue: 0.42, alpha: 1)
        gameResetButton.backgroundColorHover = UIColor(red: 0.94, green: 0.1, blue: 0.1, alpha: 1)
        gameResetButton.label.fontName = "HelveticaNeue-Regular"
        gameResetButton.action = { () in SSDGameSimulation.sharedSimulation().setMenu(.GameReset) }
        
        self.addChild(headerLabel)
        
        self.addChild(controlsOption)
        
        self.addChild(soundFXOption)
        self.addChild(vibrateOption)
        
        self.addChild(backButton)
        
        self.addChild(gameResetButton)
        
        
    }
    
    
    var size:CGSize {
    get {
        return _size
    }
    set(newSize) {
        let midX = newSize.width / 2
        
        self.marginLeft = newSize.width / 4
        
        self.backButton.position.x = newSize.width * 0.05
        self.backButton.position.y = newSize.height * 0.9
        
        self.headerLabel.position.x = midX
        self.headerLabel.position.y = newSize.height * 0.9
        
        self.controlsOption.position.x = 0
        self.controlsOption.position.y = newSize.height * 0.6
        
        self.soundFXOption.position.x = 0
        self.soundFXOption.position.y = newSize.height * 0.49
        
        self.vibrateOption.position.x = 0
        self.vibrateOption.position.y = newSize.height * 0.38
        
        self.gameResetButton.position.x = newSize.width * 0.2
        self.gameResetButton.position.y = newSize.height * 0.17
        self.gameResetButton.width = newSize.width * 0.6
        
        _size = newSize
    }
    }
    
    func updateOptionControl() {
        let options = SSDGameSimulation.sharedSimulation().gameOptions
        println("OPTION CONTROLS: \(options & GLOBAL_OPTION_CONTROLS)")
        let controlNode = self.controlsOption.optionNode as SSDOptionSwitchNode
        if options & GLOBAL_OPTION_CONTROLS == 0  {
            SSDGameSimulation.sharedSimulation().gameScene!.deactivateMotionDataIntake()
            controlNode.isON = false
        } else {
            SSDGameSimulation.sharedSimulation().gameScene!.activateMotionDataIntake()
            controlNode.isON = true
        }
    }
    
    func updateOptionSound() {
        let options = SSDGameSimulation.sharedSimulation().gameOptions
        let soundFXNode = self.soundFXOption.optionNode as SSDOptionSwitchNode
        if options & GLOBAL_OPTION_SOUNDFX == 0  {
            soundFXNode.isON = false
        } else {
            soundFXNode.isON = true
        }
    }
    
    func updateOptionVibration() {
        let options = SSDGameSimulation.sharedSimulation().gameOptions
        let vibrateOptionNode = self.vibrateOption.optionNode as SSDOptionSwitchNode
        if options & GLOBAL_OPTION_VIBRATION == 0  {
            vibrateOptionNode.isON = false
        } else {
            vibrateOptionNode.isON = true
        }
    }
    
    func updateAllOptions() {
        updateOptionControl()
    }
    
    
    
} // Class Option Menu

/* POST GAME MENU */
//MARK: POST GAME MENU CLASS
class SSDPostGameMenu:SKNode {
    
    let scoreHeading:SKLabelNode
    var scoreSum:SKLabelNode
    var highScoreLabel:SKLabelNode
    let tryAgainButton:SSDPongButton
    let backToMenuButton:SSDPongButton
    
    var _size:CGSize
    
    var _score = 0
    var _highScore = NSUserDefaults.standardUserDefaults().integerForKey("Highscore")
    
    
    init(size:CGSize?) {
        scoreHeading = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        scoreSum = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        highScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        tryAgainButton = SSDPongButton(width: nil, andText: "Try Again")
        backToMenuButton = SSDPongButton(width: nil, andText: "Back to Menu")
        
        if let s = size {
            _size = s
        } else {
            _size = CGSizeZero
        }
        
        super.init()
        
        scoreHeading.text = "Your Score"
        scoreHeading.fontColor = GLOBAL_PONGCOLOR_BEIGE
        scoreHeading.fontSize = 19
        
        scoreSum.text = "0"
        scoreSum.fontColor = GLOBAL_PONGCOLOR_BEIGE
        scoreSum.fontSize = 48
        
        highScoreLabel.text = "Highscore:"
        highScoreLabel.fontColor = GLOBAL_PONGCOLOR_BEIGE
        highScoreLabel.fontSize = 13
        
        tryAgainButton.action = { () in SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStatePregame) }
        
        backToMenuButton.action = { () in SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStateInMenu) }
        
        self.size = _size
        
        self.addChild(scoreHeading)
        self.addChild(scoreSum)
        self.addChild(highScoreLabel)
        self.addChild(tryAgainButton)
        self.addChild(backToMenuButton)
        
    }
    
    var size:CGSize {
    get {
        return _size
    }
    set(newSize) {
        _size = newSize
        
        let midX = newSize.width / 2
        
        scoreHeading.position.x = midX
        scoreHeading.position.y = _size.height * 0.73
        
        scoreSum.position.x = midX
        scoreSum.position.y = _size.height * 0.6
        
        highScoreLabel.position.x = midX
        highScoreLabel.position.y = _size.height * 0.53
        
        tryAgainButton.position.x = midX
        tryAgainButton.position.y = _size.height * 0.38
        
        backToMenuButton.position.x = midX
        backToMenuButton.position.y = _size.height * 0.26
        
    }
    }
    
    var score:Int {
    get {
        return _score
    }
    set(newScore) {
        
        if newScore > _highScore {
            highScoreLabel.text = "New Highscore!!!"
            _highScore = newScore
        } else {
            highScoreLabel.text = "Highscore: \(_highScore)"
        }
        
        _score = newScore
        
        scoreSum.text = String(newScore)
        
    }
    }
    
    func fadeInUI(delay fadeDelay:NSTimeInterval, andDuration duration:NSTimeInterval) {
        self.tryAgainButton.alpha = 0
        self.backToMenuButton.alpha = 0
        self.tryAgainButton.userInteractionEnabled = false
        self.backToMenuButton.userInteractionEnabled = false
        let fadeTimer = NSTimer.scheduledTimerWithTimeInterval(fadeDelay, target: self, selector: Selector("doFadeIn:"), userInfo: ["duration":NSNumber.numberWithDouble(duration)], repeats: false)
        
        
        
    }
    
    func doFadeIn(timer:NSTimer) {
        let userInfo:NSDictionary = timer.userInfo() as NSDictionary
        let duration = NSTimeInterval(userInfo.valueForKey("duration") as NSNumber)
        
        self.tryAgainButton.simpleFadeIn(timeInterval: duration)
        self.backToMenuButton.simpleFadeIn(timeInterval: duration)
    }
    
    
}
//MARK: PONG GAME RESET MENU
class SSDPongGameResetMenu:SKNode {
    let headerLabel:SKLabelNode
    
    let backButton:SSDActionLabel
    
    let gameResetButton:SSDPongButton
    
    let warningText:SSDMulitlineLabelNode
    
    var _size:CGSize = CGSizeZero
    init()  {
        self.headerLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold") // THE LABEL
        headerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        headerLabel.fontSize = 20
        headerLabel.fontColor = GLOBAL_PONGCOLOR_BEIGE
        headerLabel.text = "Reset Game"
        
        backButton = SSDActionLabel(fontNamed: "HelveticaNeue-Regular")
        backButton.position.x = 0
        backButton.text = "< Back"
        backButton.fontColor = GLOBAL_PONGCOLOR_BEIGE
        backButton.fontSize = 20
        backButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        backButton.action = { () in SSDGameSimulation.sharedSimulation().setMenu(.Option) }
        
        self.gameResetButton = SSDPongButton(width: 100, andText: "Yes! Reset Game")
        gameResetButton.textColor = GLOBAL_PONGCOLOR_BEIGE
        gameResetButton.textColor = GLOBAL_PONGCOLOR_BEIGE
        gameResetButton.backgroundColor = UIColor(red: 0.94, green: 0.37, blue: 0.42, alpha: 1)
        gameResetButton.backgroundColorHover = UIColor(red: 0.94, green: 0.1, blue: 0.1, alpha: 1)
        gameResetButton.label.fontName = "HelveticaNeue-Regular"
        gameResetButton.action = { () in
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "Highscore")
            SSDGameSimulation.sharedSimulation().setMenu(.Main)
        }
        
        self.warningText = SSDMulitlineLabelNode()
        warningText.fontName = "HelveticaNeue-Light"
        warningText.fontSize = 18
        warningText.lineHeight = 4
        warningText.fontColor = GLOBAL_PONGCOLOR_BEIGE
        warningText.horizontalAlignmentMode = .Center
        warningText.text = "Warning!!!\nAre you really sure you\nwant to reset the game\nand delete your highscore?"
        
        super.init()
        
        self.addChild(headerLabel)
        self.addChild(backButton)
        self.addChild(gameResetButton)
        self.addChild(warningText)
        
    }
    
    var size:CGSize {
    get {
        return _size
    }
    set(newSize) {
        let midX = newSize.width / 2
        
        let marginLeft = newSize.width / 4
        
        self.headerLabel.position.x = midX
        self.headerLabel.position.y = newSize.height * 0.9
        
        self.backButton.position.x = newSize.width * 0.05
        self.backButton.position.y = newSize.height * 0.9
        
        self.gameResetButton.position.x = newSize.width * 0.2
        self.gameResetButton.position.y = newSize.height * 0.35
        self.gameResetButton.width = newSize.width * 0.6
        
        self.warningText.position.x = midX
        self.warningText.position.y = newSize.height * 0.5
        
        _size = newSize
        
    }
    }
}

//MARK: OPTION MENU DIVIDED ITEM
class SSDPongOptionMenuDividedItem:SKNode {
    let topDivider:SKShapeNode
    let bottomDivider:SKShapeNode
    let itemTitle:SKLabelNode
    let optionNode:SSDOptionNode
    var itemDescription:Array<SKLabelNode>
    
    var _width:CGFloat = 320
    var _height:CGFloat = 80
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    init(option node:SSDOptionNode, optionTitle:NSString, optionDescription:NSString?) {
        //Dividing Lines
        let pathRef = CGPathCreateWithRect(CGRectMake(0, 0, _width, 1), nil)
        topDivider = SKShapeNode()
        topDivider.path = pathRef
        bottomDivider = SKShapeNode()
        bottomDivider.path = pathRef
        //Title
        itemTitle = SKLabelNode()
        
        //Description
        itemDescription = [SKLabelNode]()
        if let description = optionDescription {
            let stringDescriptionArray = description.componentsSeparatedByString("\n") as Array<String>
            for text in stringDescriptionArray {
                let line = SKLabelNode()
                line.text = text
                line.fontColor = GLOBAL_PONGCOLOR_BEIGE
                line.fontSize = 11
                line.horizontalAlignmentMode = .Center
                line.fontName = "HelveticaNeue-Regular"
                itemDescription.append(line)
            }
        }
        
        //Option Type
        self.optionNode = node
        
        super.init()
        
        //Dividing Line colors
        topDivider.fillColor = GLOBAL_PONGCOLOR_BEIGE
        bottomDivider.fillColor = GLOBAL_PONGCOLOR_BEIGE
        topDivider.lineWidth = 0
        bottomDivider.lineWidth = 0
        
        
        itemTitle.fontName = "HelveticaNeue-Bold"
        itemTitle.fontColor = GLOBAL_PONGCOLOR_BEIGE
        itemTitle.fontSize = 20
        itemTitle.horizontalAlignmentMode = .Left
        itemTitle.text = optionTitle
        
        self.addChild(itemTitle)
        self.addChild(optionNode)
        self.addChild(topDivider)
        self.addChild(bottomDivider)
        for i in itemDescription {
            self.addChild(i)
        }
        self.width = 320
        if !optionDescription {
            self.height = screenHeight / 9.4
        } else {
            self.height = screenHeight / 9.4 + itemDescription[0].frame.height * CGFloat(itemDescription.count)
        }
        
        
        
    }
    
    var width:CGFloat {
    get {
        return _width
    }
    set(newWidth) {
        let marginLeft = _width / 6
        let midX = width / 2
        
        itemTitle.position.x = marginLeft
        optionNode.position.x = midX
        
        for line in itemDescription {
            line.position.x = midX
        }
        
        _width = newWidth
    }
    }
    
    var height:CGFloat {
    get {
        return _height
    }
    set(newHeight) {
        let marginTop = screenHeight / 100 * 2.7
        topDivider.position.y = newHeight
        bottomDivider.position.y = 0
        
        itemTitle.position.y = newHeight - itemTitle.calculateAccumulatedFrame().height - marginTop
        optionNode.position.y = newHeight - optionNode.calculateAccumulatedFrame().height - marginTop
        
        var i:CGFloat = 0
        for line in itemDescription {
            line.position.y = newHeight - marginTop * 2 - (line.calculateAccumulatedFrame().height * i) - optionNode.calculateAccumulatedFrame().height
            i++
        }
        
        println("itemTitle: \(itemTitle.position.y)")
        
        _height = newHeight
    }
    }
    
    
}
//MARK: OPTION NODE CLASS
class SSDOptionNode:SKNode {
    var onClick = { () in println("Define a function") }
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)  {
        onClick()
    }
    
    init() {
        super.init()
        self.userInteractionEnabled = true
    }
    
}

//MARK: OPTION SWITCH NODE CLASS

class SSDOptionSwitchNode:SSDOptionNode {
    let stateONTitle:SKLabelNode
    let stateOFFTitle:SKLabelNode
    let stateONBackgroundShape:SKShapeNode
    let stateOFFBackgroundShape:SKShapeNode
    
    var _width:CGFloat = 320
    var _height:CGFloat = 480
    
    private var _isON = false
    
    init(labelON:NSString, labelOFF:NSString) {
        //initialize contents
        self.stateONTitle = SKLabelNode()
        self.stateOFFTitle = SKLabelNode()
        self.stateONTitle.text = labelON
        self.stateOFFTitle.text = labelOFF
        self.stateONBackgroundShape = SKShapeNode()
        self.stateOFFBackgroundShape = SKShapeNode()
        
        //call super init
        super.init()
        
        //label font name
        self.stateONTitle.fontName = "HelveticaNeue-Light"
        self.stateOFFTitle.fontName = self.stateONTitle.fontName
        
        //label font size
        self.stateONTitle.fontSize = 20
        self.stateOFFTitle.fontSize = self.stateONTitle.fontSize
        
        //label alignment
        self.stateONTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.stateONTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline
        
        self.stateOFFTitle.horizontalAlignmentMode = self.stateONTitle.horizontalAlignmentMode
        self.stateOFFTitle.verticalAlignmentMode = self.stateONTitle.verticalAlignmentMode
        
        //label color
        self.stateONTitle.fontColor = GLOBAL_PONGCOLOR_BEIGE
        self.stateOFFTitle.fontColor = GLOBAL_PONGCOLOR_BLUE
        
        //position Background shapes
        let ONWidth = self.stateONTitle.calculateAccumulatedFrame().width * 1.3
        let ONHeight = self.stateONTitle.calculateAccumulatedFrame().height * 1.5
        self.stateONBackgroundShape = SKShapeNode()
        self.stateONBackgroundShape.path = CGPathCreateWithRoundedRect(CGRectMake(-ONWidth / 2, -ONHeight / 5, ONWidth, ONHeight), 5, 5, nil)
        
        let OFFWidth = self.stateOFFTitle.calculateAccumulatedFrame().width * 1.3
        let OFFHeight = self.stateOFFTitle.calculateAccumulatedFrame().height * 1.5
        self.stateOFFBackgroundShape = SKShapeNode()
        self.stateOFFBackgroundShape.path = CGPathCreateWithRoundedRect(CGRectMake(-OFFWidth / 2, -OFFHeight / 5, OFFWidth, OFFHeight), 5, 5, nil)
        
        //color background shapes
        self.stateONBackgroundShape.fillColor = GLOBAL_PONGCOLOR_BEIGE
        self.stateOFFBackgroundShape.fillColor = self.stateONBackgroundShape.fillColor
        
        self.stateONBackgroundShape.lineWidth = 0
        self.stateOFFBackgroundShape.lineWidth = self.stateONBackgroundShape.lineWidth
        
        //add background shapes to labels
        self.stateONTitle.addChild(stateONBackgroundShape)
        self.stateOFFTitle.addChild(stateOFFBackgroundShape)
        
        //add All to main object
        self.addChild(stateONTitle)
        self.addChild(stateOFFTitle)
        
        //sizes
        self.width = 180
        self.height = 40
        
        //default state is OFF
        self.isON = false
        
    }
    
    var width:CGFloat {
    get {
        return _width
    }
    set(newWidth) {
        self.stateOFFTitle.position.x = self.stateOFFTitle.calculateAccumulatedFrame().width / 2
        self.stateONTitle.position.x = newWidth / 2 + self.stateONTitle.calculateAccumulatedFrame().width / 2
        _width = newWidth
    }
    }
    
    
    var height:CGFloat {
    get {
        return _height
    }
    set(newHeight) {
        self.stateOFFTitle.position.y = self.stateOFFTitle.frame.height / 2
        self.stateONTitle.position.y = self.stateONTitle.frame.height / 2
        _height = newHeight
    }
    }
    
    var isON:Bool {
    get {
        return _isON
    }
    set(newState) {
        _isON = newState
        if newState == true {
            self.stateONBackgroundShape.hidden = false
            self.stateONTitle.fontColor = GLOBAL_PONGCOLOR_BLUE
            
            self.stateOFFBackgroundShape.hidden = true
            self.stateOFFTitle.fontColor = GLOBAL_PONGCOLOR_INACTIVE
        } else {
            self.stateONBackgroundShape.hidden = true
            self.stateONTitle.fontColor = GLOBAL_PONGCOLOR_INACTIVE
            
            self.stateOFFBackgroundShape.hidden = false
            self.stateOFFTitle.fontColor = GLOBAL_PONGCOLOR_BLUE
            
        }
        
    }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event)
    }
    
}

//MARK: Pong Button
class SSDPongButton: SKNode {
    let label:SKLabelNode
    var background:SKShapeNode
    
    var action = { () in println("no action defined yet") }
    var _width:CGFloat = 208
    var _height:CGFloat = 44
    
    var _backgroundColor:UIColor = GLOBAL_PONGCOLOR_BEIGE
    var backgroundColorHover:UIColor = UIColor(red: 0.90, green: 0.88, blue: 0.69, alpha: 1)
    
    var _textColor:UIColor = GLOBAL_PONGCOLOR_BLUE
    var textColorHover:UIColor = GLOBAL_PONGCOLOR_BLUE
    
    init(width:CGFloat?, andText text:String) {
        
        label = SKLabelNode(fontNamed: GLOBAL_FONT_LIGHT)
        label.fontColor = _textColor
        label.fontSize = 16
        label.text = text
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        var bRect:CGRect = CGRectMake(-104, -22, _width, _height)
        if var w = width {
            bRect.size.width = w
            bRect.origin.x = CGFloat(Int(-w/2))
        }
        background = SKShapeNode()
        background.path = CGPathCreateWithRoundedRect(bRect, 10, 10, nil)
        background.fillColor = _backgroundColor
        background.lineWidth = 0
        background.antialiased = false
        
        super.init()
        
        
        self.userInteractionEnabled = true
        
        self.addChild(background)
        self.addChild(label)
        
    }
    
    var backgroundColor:UIColor {
    get {
        return _backgroundColor
    }
    set(newColor) {
        _backgroundColor = newColor
        background.fillColor = newColor
    }
    }
    
    var textColor:UIColor {
    get {
        return _textColor
    }
    set(newColor) {
        self.label.fontColor = newColor
        _textColor = newColor
    }
    }
    
    var width:CGFloat {
    get {
        return _width
    }
    set(newVal) {
        label.position.x = newVal / 2
        self.removeChildrenInArray([background])
        let bRect = CGRectMake(0, -_height / 2, newVal, _height)
        background = SKShapeNode()
        background.path = CGPathCreateWithRoundedRect(bRect, 10, 10, nil)
        background.lineWidth = 0
        background.fillColor = _backgroundColor
        self.addChild(background)
        _width = newVal
    }
    }
    
    var height:CGFloat {
    get {
        return _height
    }
    set(newVal) {
        self.label.position.y = newVal / 2
        let bRect = CGRectMake(-_width/2, -newVal/2, _width, newVal)
        background = SKShapeNode()
        background.path = CGPathCreateWithRoundedRect(bRect, 10, 10, nil)
        _height = newVal
    }
    }
    
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesBegan(touches, withEvent: event)
        println("Button down: \(self.label.text)")
        if self.hidden || self.alpha == 0 {
            return
        }
        
        self.background.fillColor = backgroundColorHover
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event)
        println("Button pressed: \(self.label.text)")
        if self.hidden || self.alpha == 0 {
            return
        }
        self.background.fillColor = backgroundColor
        action()
    }
    
    func simpleFadeIn(timeInterval time:NSTimeInterval) {
        self.alpha = 0.0
        self.hidden = false
        self.userInteractionEnabled = false
        let fadeAction = SKAction.fadeInWithDuration(time)
        
        self.runAction(fadeAction, completion: {() in self.userInteractionEnabled = true})
        
    }
    
    
}
//MARK: ActionLabel Class
class SSDActionLabel:SKLabelNode {
    let backupShape:SKShapeNode
    init() {
        backupShape = SKShapeNode()
        backupShape.lineWidth = 0
        super.init()
        self.userInteractionEnabled = true
        applyBackupShapePath()
        self.addChild(backupShape)
    }
    
    convenience init(fontNamed fontName: String!) {
        self.init()
        self.fontName = fontName
    }
    
    var action = { () in println("No action defined") }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        action()
    }
    
    override var text:String! {
    get {
        return super.text
    }
    set(newText) {
        super.text = newText
        applyBackupShapePath()
    }
    }
    
    override var fontName:String! {
    get {
        return super.fontName
    }
    set(newFont) {
        super.fontName = newFont
        applyBackupShapePath()
    }
    }
    
    override var fontSize:CGFloat {
    get {
        return super.fontSize
    }
    set(newSize) {
        super.fontSize = newSize
        applyBackupShapePath()
    }
    
    }
    
    private func applyBackupShapePath() {
        backupShape.path = nil
        let bounds = CGRectMake(0, 0, self.frame.width, self.frame.height)
        backupShape.path = CGPathCreateWithRect(bounds, nil)
    }
    
    
}


