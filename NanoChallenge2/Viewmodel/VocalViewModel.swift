//
//  VocalToneViewModel.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 26/07/22.
//

import Foundation
import SwiftUI
class VocalViewModel: ObservableObject {
    @Published var flatToneCounter: Float = 0.0
    @Published var otherToneCounter: Float = 0.0
    var wpm = 0
    @Published var wf = 0
    @Published var barArr: [Float] = []
    var sm = SoundManager()
    var textArr: [String] = []

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

    func startSoundManager() {
        sm.delegate = self
        sm.startRecording()
    }
    
    func stopSoundManager() {
        sm.recRequest?.endAudio()
        sm.audioEngine.stop()
        sm.recTask?.cancel()
    }
    func calculateWordsPerMinute() {
        textArr = sm.textString.split(separator: " ").map({String($0)})
//        wpm = textArr.count * 60 / second
    }
//
//    func wordFillersDetection() {
//        for i in 0 ..< textArr.count {
//            for j in 0 ..< wfArr.count {
//                if textArr[i] == wfArr[j] {
//                    wf += 1
//                }
//            }
//        }
//    }
}

extension VocalViewModel: SoundManagerProtocol {
    func barOutput(arr: [Float]) {
        DispatchQueue.main.async {
            self.barArr = arr
        }
    }
}
