//
//  SSDMultilineLabel.swift
//  EgoPong
//
//  Created by Markus Buhl on 13/07/14.
//  Copyright (c) 2014 Markus Buhl. All rights reserved.
//

import Foundation
import SpriteKit

class SSDMulitlineLabelNode:SKLabelNode {
    var lines = [SKLabelNode]()
    var _text:String = ""
    
    init() {
        super.init()
    }
    
    
    /* TEXT */
    override var text:String! {
    get {
        return _text
    }
    set(newText) {
        lines.removeAll(keepCapacity: false)
        let linesAsStrings = newText.componentsSeparatedByString("\n")
        for line in linesAsStrings {
            let textNode = SKLabelNode()
            textNode.horizontalAlignmentMode = _horizontalAlignmentMode
            textNode.text = line
            textNode.fontColor = _fontColor
            textNode.fontName = _fontName
            textNode.fontSize = _fontSize
            lines.append(textNode)
        }
        for line in lines {
            self.addChild(line)
        }
        lineHeight = _lineHeight
        _text = newText
    }
    }
    
    /* LINE HEIGHT */
    var _lineHeight:CGFloat = 10
    var lineHeight:CGFloat {
    get {
        return _lineHeight
    }
    set(newHeight) {
        var i = CGFloat(lines.count)
        for line in lines {
            line.position.y = i * lineHeight + i * line.fontSize
            --i
        }
        _lineHeight = newHeight
    }
    }
    
    /* FONT COLOR */
    var _fontColor = UIColor()
    override var fontColor:UIColor! {
    get {
        return _fontColor
    }
    set(newColor) {
        for line in lines {
            line.fontColor = newColor
        }
        _fontColor = newColor
    }
    }
    
    /* FONT SIZE */
    var _fontSize:CGFloat = 10
    override var fontSize:CGFloat {
    get {
        return _fontSize
    }
    set(newSize) {
        for line in lines {
            line.fontSize = newSize
        }
        _fontSize = newSize
    }
    }
    
    /* FONT NAME */
    var _fontName:String = "HelveticaNeue-Light"
    override var fontName:String! {
    get {
        return _fontName
    }
    set(newName) {
        for line in lines {
            line.fontName = newName
        }
        _fontName = newName
    }
    }
    
    /* HORIZONTAL TEXT ALIGNMENT */
    var _horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    override var horizontalAlignmentMode:SKLabelHorizontalAlignmentMode {
    get {
        return _horizontalAlignmentMode
    }
    set(newAlignmentMode) {
        for line in lines {
            line.horizontalAlignmentMode = newAlignmentMode
        }
        _horizontalAlignmentMode = newAlignmentMode
    }
    }
    
    /* VERTICAL TEXT ALIGNMENT: NOT SUPPORTED!!! */
    override var verticalAlignmentMode:SKLabelVerticalAlignmentMode {
    get {
        return SKLabelVerticalAlignmentMode.Baseline
    }
    set(newMode) {
        println("Warning: Multiline does not support vertical alignment modes and will always be aligned to baseline")
    }
    }
    
    
}