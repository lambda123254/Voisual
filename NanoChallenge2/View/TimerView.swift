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
    var udm = UserDefaultManager()

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
//                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//                    if second == 0 {
//                        secondRound = "0"
//                    }
//
//                    if second > 8 {
//                        secondRound = ""
//                    }
//
//                    if second == 59 {
//                        second = 0
//                        minute += 1
//                    }
//                    else {
//                        second += 1
//
//                    }
//
//                    print("timer running")
////                    if gv.toggleShowResult {
////                        timer.invalidate()
////                    }
//                }
                timerViewModel.delegate = self
                second = timerViewModel.second
                timerViewModel.calulateTimer()
                
            }
    }
}

extension TimerView: TimerViewModelProtocol {
    func getSecond(second: Int) {
        udm.setTimerSecond(second: second)
    }
}
