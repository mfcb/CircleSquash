//
//  GameViewController.swift
//  EgoPong
//
//  Created by Markus Buhl on 07/06/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        var sceneData: NSData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil) as NSData
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SSDGameScene
        archiver.finishDecoding()
        return scene
    }
}

extension SSDGameSimulation {
    func flushOptions() {
        let settingControls = self.gameOptions & GLOBAL_OPTION_CONTROLS
        let settingSound = self.gameOptions & GLOBAL_OPTION_SOUNDFX
        let settingVibration = self.gameOptions & GLOBAL_OPTION_VIBRATION
        NSUserDefaults.standardUserDefaults().setInteger(Int(settingControls), forKey: "OptionControls")
        NSUserDefaults.standardUserDefaults().setInteger(Int(settingSound), forKey: "OptionSound")
        NSUserDefaults.standardUserDefaults().setInteger(Int(settingVibration), forKey: "OptionVibration")
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SSDGameSimulation.sharedSimulation().activateAudio(true)
        
        if let scene = SSDGameScene.unarchiveFromFile("GameScene") as? SSDGameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* set up a gameSimulation */
            let gameSim = SSDGameSimulation()
            gameSim.gameScene = scene
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            //Set background color to our special blue color
            scene.backgroundColor = GLOBAL_PONGCOLOR_BLUE
            //set font sizes
            switch(skView.bounds.height) {
            case 480:
                GLOBAL_PONG_FONTSIZE.Small = Float(Int(GLOBAL_PONG_FONTSIZE.Small * 1))
                GLOBAL_PONG_FONTSIZE.Medium = Float(Int(GLOBAL_PONG_FONTSIZE.Medium * 1))
                GLOBAL_PONG_FONTSIZE.Large = Float(Int(GLOBAL_PONG_FONTSIZE.Large * 1))
            case 568:
                GLOBAL_PONG_FONTSIZE.Small = Float(Int(GLOBAL_PONG_FONTSIZE.Small * 1.18))
                GLOBAL_PONG_FONTSIZE.Medium = Float(Int(GLOBAL_PONG_FONTSIZE.Medium * 1.18))
                GLOBAL_PONG_FONTSIZE.Large = Float(Int(GLOBAL_PONG_FONTSIZE.Large * 1.18))
            case 768:
                GLOBAL_PONG_FONTSIZE.Small *= 1.6
                GLOBAL_PONG_FONTSIZE.Medium *= 1.6
                GLOBAL_PONG_FONTSIZE.Large *= 1.6
            default:
                GLOBAL_PONG_FONTSIZE.Small *= 1
                GLOBAL_PONG_FONTSIZE.Medium *= 1
                GLOBAL_PONG_FONTSIZE.Large *= 1
            }
            skView.presentScene(scene)
            gameSim.setGameState(GameState.GameStateInMenu)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
