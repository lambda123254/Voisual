//
//  ResultManager.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 27/07/22.
//

import Foundation

protocol ResultManagerProtocol {
    func resultWpm(result: Int)
}

class ResultManager {
    var flatToneCounter: Float = 0.0
    var otherToneCounter: Float = 0.0
    var wf = 0
    var textArr: [String] = []
    var sm: SoundManager
    var delegate: ResultManagerProtocol?
    var second = 0
    var wpm = 0
    
    init(sm: SoundManager) {
        self.sm = sm
    }

    func calculateWordsPerMinute(){
        textArr = sm.textString.split(separator: " ").map({String($0)})
        wpm = textArr.count * 60 / 1
        self.delegate?.resultWpm(result: wpm)
    }
}
