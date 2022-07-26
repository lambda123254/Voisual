//
//  VocalToneViewModel.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 26/07/22.
//

import Foundation
import SwiftUI
class VocalToneViewModel: ObservableObject {
    @Published var number: Int = 0
    @Published var toggleShowResult = false
    @Published var flatToneCounter: Float = 0.0
    @Published var otherToneCounter: Float = 0.0
}
