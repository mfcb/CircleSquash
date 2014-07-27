//
//  Globals.swift
//  EgoPong
//
//  Created by Markus Buhl on 10/06/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import Foundation
import SpriteKit

/* the bundle */


/* Scene Sizes */


/*  Colors   */

let GLOBAL_PONGCOLOR_BLUE = UIColor(red: 0.058, green: 0.388, blue: 0.498, alpha: 1)
let GLOBAL_PONGCOLOR_BEIGE = UIColor(red: 0.94, green: 0.921, blue: 0.8, alpha: 1)
let GLOBAL_PONGCOLOR_INACTIVE = UIColor(red: 0.65, green: 0.64, blue: 0.5, alpha: 1)

/* Typo */

let GLOBAL_FONT_LIGHT = "HelveticaNeue-Light"
let GLOBAL_FONT_BOLD = "HelveticaNeue-Bold"

struct GLOBAL_PONG_FONTSIZE {
    static var Small:Float = 12.0
    static var Medium:Float = 37.0
    static var Large:Float = 40.0
}

/* Global game parameters */
var GLOBAL_COLLISIONIMPULSE_MULTIPLIER:Float = 500
let GLOBAL_INITIALIMPULSE:Int = 100
var GLOBAL_PADDLEIMPULSE:CGFloat = 100.0

/* option bit-masks */
let GLOBAL_OPTION_CONTROLS:UInt32 = 1 << 0
let GLOBAL_OPTION_SOUNDFX:UInt32 = 1 << 1
let GLOBAL_OPTION_VIBRATION:UInt32 = 1 << 2

func getImageInMainBundle(imageName:String, type:String) -> UIImage? {
    return UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(imageName, ofType: type))
    
}

/* Graphics */
var GLOBAL_ANTI_ALIASING = true