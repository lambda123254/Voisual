//
//  ShareableVariable.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 27/07/22.
//

import Foundation

class ShareableVariable {
    
    static var shared = ShareableVariable()
    
    private init() {}
    
    var secondTimer = 0
    var wpm = 0
    var wordFillers = 0
    var wfCounter = 0
    var flatToneCounter = 0
    var otherToneCounter = 0
}
