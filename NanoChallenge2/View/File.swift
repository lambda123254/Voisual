//
//  File.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 26/07/22.
//

import Foundation
import SwiftUI
struct BarView: View {
    @State var barHeight: Float
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.init(hex: "630000"))
            .frame(width: 3, height: CGFloat(barHeight), alignment: .center)
    }

}
