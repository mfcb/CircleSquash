//
//  GameSimulation.swift
//  EgoPong
//
//  Created by Markus Buhl on 11/06/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import CoreMotion

enum GameState {
    case GameStatePregame
    case GameStateInGame
    case GameStatePaused
    case GameStatePostGame
    case GameStateInMenu
}

var _sharedGameSimulation:SSDGameSimulation?
var _gameState:GameState = .GameStatePaused
var _menu:MainMenuType = .Main

class SSDGameSimulation {
    
    var gameScene:SSDGameScene?
    
    var gameOptions:UInt32 = 0
    
    let audioSession: AVAudioSession! = AVAudioSession.sharedInstance() as AVAudioSession
    
    let gameMotionManager:CMMotionManager
    
    var gameState:GameState {
    get {
        return _gameState
    }
    }
    
    //This class automatically creates a singleton for easy use
    class func sharedSimulation() ->SSDGameSimulation {
        if _sharedGameSimulation == nil {
            _sharedGameSimulation = SSDGameSimulation()
        }
        
        return _sharedGameSimulation!
    }
    
    init()  {
        gameMotionManager = CMMotionManager()
        _sharedGameSimulation = self
    }
    
    func setGameState(state:GameState) {
        //Ignore if given state is already set
        if(state == _gameState) {
            return
        }
        
        switch(state) {
        case .GameStateInGame:
            println("Game running")
        case .GameStatePaused:
            println("Game paused")
        case .GameStatePostGame:
            println("Game Over")
        case .GameStatePregame:
            println("Game is about to begin")
        case .GameStateInMenu:
            println("Currently in menu")
        }
        _gameState = state
        self.gameScene!.setGameState(state)
        
        
    }
    
    func setMenu(menu:MainMenuType) {
        if _gameState != .GameStateInMenu {
            return
        }
        
        self.gameScene!.mainMenu.activeMenu = menu
        _menu = menu
    }
    
    func activateAudio(activate:Bool) ->NSErrorPointer {
        
        var activationError:NSErrorPointer = nil
        var avActivationSuccess = SSDGameSimulation.sharedSimulation().audioSession.setActive(activate, error: activationError)
        
        if !avActivationSuccess {
            return activationError
        }
        
        return nil
    }
    
    
    
    
}