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
    
    @State var title = ""
    @State var imageTitle = ""
    @State var contentString = ""
    @State var contentStringArr: [String] = [
        "Speaking pace is a measure of the number of speech units of a given type produced within a given amount of time",
        "wawawa",
        "gagagagagag"
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
        }
        
    }
}

