//
//  UserDefaultManager.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 27/07/22.
//

import Foundation

class UserDefaultManager {
    let defaults = UserDefaults.standard

    func setTimerSecond(second: Int) {
        defaults.set(second, forKey: "secondTimer")
    }
    func getTimerSecond() -> Int {
        return defaults.integer(forKey: "secondTimer")
    }
}
