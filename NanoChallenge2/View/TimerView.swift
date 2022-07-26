//
//  TimerView.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 26/07/22.
//

import Foundation
import SwiftUI
struct TimerView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var second = 0
    @State var minute = 0
    @State var minuteRound = "0"
    @State var secondRound = "0"
    var body: some View {
        Text("\(minuteRound)\(minute):\(secondRound)\(second)")
            .foregroundColor(.white)
            .font(.system(size: 40, weight: .bold, design: .default))
            .background(Circle().fill(Color(hex: "630000")).frame(width: 200, height: 200, alignment:.center))
            .onReceive(timer) { input in
                if second == 0 {
                    secondRound = "0"
                }
                
                if second > 8 {
                    secondRound = ""
                }
                
                if second == 59 {
                    second = 0
                    minute += 1
                }
                else {
                    second += 1
                    
                }
            }
    }
}
