//
//  GlobalVariables.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 26/07/22.
//

import Foundation

class GlobalVariables: ObservableObject {
    @Published var toggleShowResult = false
    @Published var barArr: [Float] = []
    @Published var number: Int = 0
}
