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
    @Binding var speakingPace: Int
    @Binding var wordFillers: Int
    @ObservedObject var gv = GlobalVariables()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.5)
            Group {
                VStack {
                    Text("Great Job, your result is")
                        .padding(.bottom, 1)
                    Text("Good")
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
        .onTapGesture(){
            print(gv.toggleShowResult)
        }
        .onAppear {
            calculateScore()
        }
    }
    
    func calculateScore() {
        print(speakingPace)
//        if speakingPace 
    }
}
