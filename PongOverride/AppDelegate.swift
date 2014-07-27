//
//  AppDelegate.swift
//  EgoPong
//
//  Created by Markus Buhl on 07/06/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        let appDefaults = ["Highscore":NSNumber(int: 0),
            "OptionControls":NSNumber(unsignedInt: GLOBAL_OPTION_CONTROLS),
            "OptionSound":NSNumber(unsignedInt: GLOBAL_OPTION_SOUNDFX),
            "OptionVibration":NSNumber(unsignedInt: GLOBAL_OPTION_VIBRATION)]
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        if SSDGameSimulation.sharedSimulation().gameState == GameState.GameStateInGame {
            SSDGameSimulation.sharedSimulation().setGameState(GameState.GameStatePaused)
        }
        SSDGameSimulation.sharedSimulation().activateAudio(false)
        SSDGameSimulation.sharedSimulation().flushOptions()
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        SSDGameSimulation.sharedSimulation().activateAudio(true)
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        SSDGameSimulation.sharedSimulation().flushOptions()
        println("Bye bye")
    }
    
    
}

