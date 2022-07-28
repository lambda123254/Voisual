//
//  ResultManager.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 27/07/22.
//

import Foundation

class ResultManager {
    var flatToneCounter: Float = 0.0
    var otherToneCounter: Float = 0.0
    var textArr: [String] = []
    var sm: SoundManager
    var wpm = 0
    var timerViewModel = TimerViewModel()
    var second = 0
    var wfArr: [String] = [
        "absolutely",
        "actual",
        "actually",
        "amazing",
        "anyway",
        "apparently",
        "approximately",
        "badly",
        "basically",
        "begin",
        "certainly",
        "clearly",
        "completely",
        "definitely",
        "easily",
        "effectively",
        "entirely",
        "especially",
        "essentially",
        "exactly",
        "extremely",
        "fairly",
        "frankly",
        "frequently",
        "fully",
        "generally",
        "hardly",
        "heavily",
        "highly",
        "hopefully",
        "just",
        "largely",
        "like",
        "literally",
        "maybe",
        "might",
        "most",
        "mostly",
        "much",
        "necessarily",
        "nicely",
        "obviously",
        "ok",
        "okay",
        "particularly",
        "perhaps",
        "possibly",
        "practically",
        "precisely",
        "primarily",
        "probably",
        "quite",
        "rather",
        "real",
        "really",
        "relatively",
        "right",
        "seriously",
        "significantly",
        "simply",
        "slightly",
        "so",
        "specifically",
        "start",
        "strongly",
        "stuff",
        "surely",
        "things",
        "too",
        "totally",
        "truly",
        "try",
        "typically",
        "ultimately",
        "usually",
        "very",
        "virtually",
        "well",
        "whatever",
        "whenever",
        "wherever",
        "whoever",
        "widely"
      ]
    
    init(sm: SoundManager) {
        self.sm = sm
    }

    func calculateWordsPerMinute(){
        textArr = sm.textString.split(separator: " ").map({String($0)})
        wpm = textArr.count * 60 / ShareableVariable.shared.secondTimer
        ShareableVariable.shared.wpm = wpm
    }
    
    func wordFillersDetection() {
        for i in 0 ..< textArr.count {
            for j in 0 ..< wfArr.count {
                if textArr[i] == wfArr[j] {
                    ShareableVariable.shared.wfCounter += 1
                }
            }
        }
    }
    
}

