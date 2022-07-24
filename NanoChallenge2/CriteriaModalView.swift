//
//  CriteriaModalView.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 23/07/22.
//

import Foundation
import SwiftUI

struct CriteriaModalView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var title: String
    @State var imageTitle = "circle"
    @State var contentString = ""
    @State var contentStringArr: [String] = [
        "Speaking pace is a measure of the number of speech units of a given type produced within a given amount of time",
        "The term word fillers refers to short words or phrases that are used in speech for creating a pause or to indicate someone isn't finished speaking",
        "Vocal tone in public speaking is actually the way a person is speaking to someone. In essence, it's how speaker sound when they say words out loud."
    ]

    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 100, height: 5, alignment: .center)
                Text(Image(systemName: "\(imageTitle)"))
                    .font(.system(size: 70))
                    .foregroundColor(Color(hex: "630000"))
                Text("**\(title)**")
                    .font(.system(size: 20))
                Text("\(contentString)")
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }
        }
        .onAppear {
            if title == "Speaking Pace" {
                imageTitle = "speedometer"
                contentString = contentStringArr[0]
            }
            else if title == "Word Fillers" {
                imageTitle = "w.circle"
                contentString = contentStringArr[1]
            }
            else if title == "Vocal Tone" {
                imageTitle = "waveform.circle"
                contentString = contentStringArr[2]
            }
        }
        
    }
}

