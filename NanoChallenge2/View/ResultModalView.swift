//
//  ResultModalView.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 25/07/22.
//

import Foundation
import SwiftUI

struct ResultModalView: View {
    @Environment(\.dismiss) var dismiss
    
    var stars = 5
    var starsFilled = 5
    var speakingPace: Int
    var wordFillers: Int
    var flatToneCounter: Int
    var otherToneCounter: Int
    var toneScore = 0
    var toneValue: Int
    var toneString = ""
    var toneColor = Color.init(hex: "ffffff")


    var speakingPaceString = ""
    var speakingPaceColor = Color.init(hex: "ffffff")
    var speakingPaceScore = 0

    var wordFillersString = ""
    var wordFillersColor = Color.init(hex: "ffffff")
    var wordFillersScore = 0

    var vocalToneString = ""
    
    var overallResultString = ""
    var overallScore = 0
    var overallResultColor = Color.init(hex: "ffffff")
    var gv: GlobalVariables
    
    init(gv: GlobalVariables) {
        self.speakingPace = ShareableVariable.shared.wpm
        self.wordFillers = ShareableVariable.shared.wfCounter
        self.flatToneCounter = ShareableVariable.shared.flatToneCounter
        self.otherToneCounter = ShareableVariable.shared.otherToneCounter
        self.gv = gv
        
        if speakingPace <= 100 || speakingPace > 150 && speakingPace < 400 {
            speakingPaceColor = Color.red
        }
        else if speakingPace > 100 && speakingPace <= 120 {
            speakingPaceColor = Color.orange
        }
        else {
            speakingPaceColor = Color.init(hex: "4F9536")
        }
        
        if wordFillers >= 20 && wordFillers <= 1000 || wordFillers >= 15 && wordFillers < 20 {
            wordFillersColor = Color.red
        }
        else if wordFillers >= 10 && wordFillers <= 15 {
            wordFillersColor = Color.orange
            wordFillersScore = 20

        }
        else {
            wordFillersColor = Color.init(hex: "4F9536")
            wordFillersScore = 30
        }

        switch speakingPace {
        case 0...80:
            speakingPaceString = "Awful\n(too slow)"
            speakingPaceScore = 5

        case 80...100:
            speakingPaceString = "Bad\n(too slow)"
            speakingPaceScore = 10
        case 100...120:
            speakingPaceString = "Average"
            speakingPaceScore = 20
        case 120...130:
            speakingPaceString = "Good"
            speakingPaceScore = 25
        case 130...150:
            speakingPaceString = "Excellent"
            speakingPaceScore = 30
        case 150...170:
            speakingPaceString = "Bad\n(too fast)"
            speakingPaceScore = 10
        case 170...400:
            speakingPaceString = "Awful\n(too fast)"
            speakingPaceScore = 5
        default:
            speakingPaceString = "n/a"
        }
        
        switch wordFillers {
        case 20...1000:
            wordFillersString = "Awful"
            wordFillersScore = 5
        case 15...20:
            wordFillersString = "Bad"
            wordFillersScore = 10
        case 10...15:
            wordFillersString = "Average"
            wordFillersScore = 20
        case 5...10:
            wordFillersString = "Good"
            wordFillersScore = 25
        case 0...5:
            wordFillersString = "Excellent"
            wordFillersScore = 30
        default:
            wordFillersString = "n/a"
        }
        
        if flatToneCounter > otherToneCounter {
            toneValue = (flatToneCounter - otherToneCounter) * -1
        }
        else {
            toneValue = (otherToneCounter - flatToneCounter)
        }
        switch toneValue{
        case -100 ... -20:
            toneString = "Awful"
            toneScore = 5
            toneColor = .red
        case -10 ... 0:
            toneString = "Bad"
            toneScore = 10
            toneColor = .red
        case 0 ... 10:
            toneString = "Average"
            toneScore = 20
            toneColor = .orange
        case 10 ... 20:
            toneString = "Good"
            toneScore = 25
            toneColor = Color.init(hex: "4F9536")
        case 20 ... 100:
            toneString = "Excellent"
            toneScore = 30
            toneColor = Color.init(hex: "4F9536")
        default:
            toneString = "n/a"
        }
        print("toneScore = \(toneValue), flatTone = \(flatToneCounter), otherTone = \(otherToneCounter)")
        overallScore = (speakingPaceScore + wordFillersScore + toneScore) / 9
        
        switch overallScore {
        case 0...2:
            overallResultString = "Awful"
            overallResultColor = Color.red
            starsFilled = 1
        case 2...4:
            overallResultString = "Bad"
            overallResultColor = Color.red
            starsFilled = 2

        case 4...6:
            overallResultString = "Average"
            overallResultColor = Color.orange
            starsFilled = 3

        case 6...8:
            overallResultString = "Good"
            overallResultColor = Color.init(hex: "4F9536")
            starsFilled = 4

        case 8...10:
            overallResultString = "Excellent"
            overallResultColor = Color.init(hex: "4F9536")
            starsFilled = 5

        default:
            overallResultString = "n/a"
        }
        
    }
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.5)
            Group {
                VStack {
                    Text("Great Job, your result is")
                        .padding(.bottom, 1)
                        .foregroundColor(.black)

                    Text("\(overallResultString)")
                        .foregroundColor(overallResultColor)
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .padding(.bottom, 2)
                    HStack {
                        ForEach(1...starsFilled, id: \.self){ value in
                            Text(Image(systemName: "star.fill"))
                                .foregroundColor(Color(hex: "630000"))
                        }
                        ForEach(0...stars - starsFilled, id: \.self){ value in
                            if starsFilled != 5 && value != 0{
                                Text(Image(systemName: "star"))
                                    .foregroundColor(Color(hex: "630000"))
                            }
                            
                        }
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        VStack {
                            Text(Image(systemName: "speedometer"))
                                .foregroundColor(Color(hex: "630000"))
                                .font(.system(size: 30))
                            Text("**Speaking\nPace**")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 2)
                                .foregroundColor(.black)

                            Text("\(speakingPaceString)")
                                .foregroundColor(speakingPaceColor)
                                .multilineTextAlignment(.center)
                        }
                        VStack {
                            Text(Image(systemName: "w.circle"))
                                .foregroundColor(Color(hex: "630000"))
                                .font(.system(size: 30))
                            Text("**Word\nFillers**")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 2)
                                .foregroundColor(.black)

                            Text("\(wordFillersString)")
                                .foregroundColor(wordFillersColor)

                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 10)

                        VStack {
                            Text(Image(systemName: "waveform.circle"))
                                .foregroundColor(Color(hex: "630000"))
                                .font(.system(size: 30))
                            Text("**Vocal\nTone**")
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 2)
                                .foregroundColor(.black)

                            Text("\(toneString)")
                                .foregroundColor(toneColor)
                        }
                    }
                }
            }
            .padding(50)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
            
        }
        .onTapGesture {
            print("Tapped")
            gv.toggleShowResult.toggle()
        }

    }

    
}
