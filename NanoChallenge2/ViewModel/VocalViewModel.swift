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
    @Published var wf = 0
    @Published var barArr: [Float] = []
    @Published var wpm = 0
    var sm = SoundManager()
    var rm: ResultManager
    var textArr: [String] = []
    
    init() {
        rm = ResultManager(sm: sm)
        sm.delegate = self
    }

    func startSoundManager() {
        sm.startRecording()
    }
    
    func stopSoundManager() {
        sm.barArr = []
        sm.recRequest?.endAudio()
        sm.audioEngine.stop()
        sm.recTask?.cancel()
        rm.calculateWordsPerMinute()
        rm.wordFillersDetection()
    }

}

extension VocalViewModel: SoundManagerProtocol {
    func barOutput(arr: [Float]) {
        DispatchQueue.main.async {
            self.barArr = arr
        }
    }
}



