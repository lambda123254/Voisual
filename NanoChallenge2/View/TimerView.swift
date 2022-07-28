//
//  TimerView.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 26/07/22.
//

import Foundation
import SwiftUI

struct TimerView: View {
    @State var second = 0
    @State var minute = 0
    @State var minuteRound = "0"
    @State var secondRound = "0"
    @State var timer: Timer?
    @StateObject var timerViewModel = TimerViewModel()

//    var gv: GlobalVariables
//    
//    init(gv: GlobalVariables) {
//        self.gv = gv
//    }
    var body: some View {
        Text("\(minuteRound)\(timerViewModel.minute):\(secondRound)\(timerViewModel.second)")
            .foregroundColor(.white)
            .font(.system(size: 40, weight: .bold, design: .default))
            .background(Circle().fill(Color.appRed).frame(width: 200, height: 200, alignment:.center))
            .onAppear() {
                timerViewModel.delegate = self
                second = timerViewModel.second
                timerViewModel.calulateTimer()
            }
            .onDisappear {
                timerViewModel.stopTimer()
            }
    }
}

extension TimerView: TimerViewModelProtocol {
    func getSecond(second: Int) {
        if second > 9 {
            secondRound = ""
        }
        ShareableVariable.shared.secondTimer = second
    }
}
