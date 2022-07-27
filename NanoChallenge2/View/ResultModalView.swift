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
    
    init(speakingPace: Int, wordFillers: Int, gv: GlobalVariables) {
        self.speakingPace = speakingPace
        self.wordFillers = wordFillers
        self.gv = gv
        if speakingPace <= 100 || speakingPace > 150 && speakingPace < 400 {
            speakingPaceColor = Color.red
            speakingPaceScore = 10
        }
        else if speakingPace > 100 && speakingPace <= 120 {
            speakingPaceColor = Color.orange
            speakingPaceScore = 20
        }
        else {
            speakingPaceColor = Color.init(hex: "4F9536")
            speakingPaceScore = 30
        }
        
        if wordFillers >= 30 && wordFillers <= 50 {
            wordFillersColor = Color.red
            wordFillersScore = 10

        }
        else if wordFillers >= 10 && wordFillers < 30 {
            wordFillersColor = Color.orange
            wordFillersScore = 20

        }
        else {
            wordFillersColor = Color.init(hex: "4F9536")
            wordFillersScore = 30
        }
        overallScore = speakingPaceScore + wordFillersScore
        switch overallScore {
        case 0...12:
            overallResultString = "Awful"
            overallResultColor = Color.red
            starsFilled = 1
        case 12...24:
            overallResultString = "Bad"
            overallResultColor = Color.red
            starsFilled = 2

        case 24...36:
            overallResultString = "Average"
            overallResultColor = Color.orange
            starsFilled = 3

        case 36...48:
            overallResultString = "Good"
            overallResultColor = Color.init(hex: "4F9536")
            starsFilled = 4

        case 48...60:
            overallResultString = "Excellent"
            overallResultColor = Color.init(hex: "4F9536")
            starsFilled = 5

        default:
            overallResultString = "n/a"
        }

        switch speakingPace {
        case 0...80:
            speakingPaceString = "Awful\n(too slow)"
        case 80...100:
            speakingPaceString = "Bad\n(too slow)"
        case 100...120:
            speakingPaceString = "Average"
        case 120...130:
            speakingPaceString = "Good"
        case 130...150:
            speakingPaceString = "Excellent"
        case 150...170:
            speakingPaceString = "Bad\n(too fast)"
        case 170...400:
            speakingPaceString = "Awful\n(too fast)"
        default:
            speakingPaceString = "n/a"
        }
        
        switch wordFillers {
        case 20...25:
            wordFillersString = "Awful"
        case 15...20:
            wordFillersString = "Bad"
        case 10...15:
            wordFillersString = "Average"
        case 5...10:
            wordFillersString = "Good"
        case 0...5:
            wordFillersString = "Excellent"
        default:
            wordFillersString = "n/a"
        }
        
        
    }
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.5)
            Group {
                VStack {
                    Text("Great Job, your result is")
                        .padding(.bottom, 1)
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

                            Text("Excellent")
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
