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
    
    @State var stars = 5
    var speakingPace: Int

    @State var speakingPaceString = ""
    init(speakingPace: Int) {
        self.speakingPace = speakingPace
        switch speakingPace {
        case 0...80:
            speakingPaceString = "Awful"
        case 80...100:
            speakingPaceString = "Bad"
        case 100...120:
            speakingPaceString = "Average"
        case 120...130:
            speakingPaceString = "Good"
        case 130...150:
            speakingPaceString = "Excellent"
        case 150...170:
            speakingPaceString = "Bad"
        case 170...400:
            speakingPaceString = "Awful"
        default:
            speakingPaceString = "n/a"
        }
    }
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.5)
            Group {
                VStack {
                    Text("Great Job, your result is")
                        .padding(.bottom, 1)
                    Text("\(speakingPaceString)")
                        .foregroundColor(Color(hex: "4F9536"))
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .padding(.bottom, 2)
                    HStack {
                        ForEach(1...stars, id: \.self){ value in
                            Text(Image(systemName: "star"))
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
                            Text("Excellent")
                        }
                        VStack {
                            Text(Image(systemName: "w.circle"))
                                .foregroundColor(Color(hex: "630000"))
                                .font(.system(size: 30))
                            Text("**Word\nFillers**")
                                .multilineTextAlignment(.center)

                            Text("Excellent")
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 10)

                        VStack {
                            Text(Image(systemName: "waveform.circle"))
                                .foregroundColor(Color(hex: "630000"))
                                .font(.system(size: 30))
                            Text("**Vocal\nTone**")
                                .multilineTextAlignment(.center)

                            Text("Excellent")
                        }
                    }
                }
            }
            .padding(50)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
            
        }

    }
    
}
