//
//  MBMath.swift
//  EgoPong
//
//  Created by Markus Buhl on 08/06/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import Foundation

func MBMath_degreesToRadians (var value:Float) -> Float {
    value = value * Float(M_PI) / 180
    return value
}

func MBMath_radiansToDegrees (var value:Float) -> Float {
    value = value * 180/Float(M_PI)
    return value
}