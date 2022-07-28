//
//  TimerViewModel.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 27/07/22.
//

import Foundation
import SwiftUI

protocol TimerViewModelProtocol {
    func getSecond(second: Int)
}

class TimerViewModel: ObservableObject {
    @Published var second: Int = 0
    @Published var minute: Int = 0
    var timer = Timer()
    var delegate: TimerViewModelProtocol?
    func calulateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            if self.second == 59 {
                self.second = 0
                self.minute += 1
            }
            else {
                self.second += 1
            }
            self.delegate?.getSecond(second: second)
            print("timer running")
        }
    }
    func stopTimer() {
        timer.invalidate()
    }

}
