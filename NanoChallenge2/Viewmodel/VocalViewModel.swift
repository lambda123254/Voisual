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
    @Published var wpm: Int = 0

//    func calculateWordsPerMinute() {
//        wpm = textArr.count * 60 / second
//    }
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
