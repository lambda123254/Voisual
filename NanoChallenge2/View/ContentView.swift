//
//  ContentView.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 18/07/22.
//

import SwiftUI
import Speech
import AVKit
import Accelerate
import SoundAnalysis
import HalfASheet

struct ContentView: View {
    
    @State var textArr: [String] = []

    @State var barValue: Float = 0.0
    @State var barArr: [Float] = []
        
    @State var toggleRecordButton = false
    @State var toggleShowResult = false
    @State var toggleCriteriaView = false
    @State var criteriaTitle = ""
    @State var offsetMove: CGFloat = -400
    
    @State var sm = SoundManager()

    @State var wfArr: [String] = [
        "absolutely",
        "actual",
        "actually",
        "amazing",
        "anyway",
        "apparently",
        "approximately",
        "badly",
        "basically",
        "begin",
        "certainly",
        "clearly",
        "completely",
        "definitely",
        "easily",
        "effectively",
        "entirely",
        "especially",
        "essentially",
        "exactly",
        "extremely",
        "fairly",
        "frankly",
        "frequently",
        "fully",
        "generally",
        "hardly",
        "heavily",
        "highly",
        "hopefully",
        "just",
        "largely",
        "like",
        "literally",
        "maybe",
        "might",
        "most",
        "mostly",
        "much",
        "necessarily",
        "nicely",
        "obviously",
        "ok",
        "okay",
        "particularly",
        "perhaps",
        "possibly",
        "practically",
        "precisely",
        "primarily",
        "probably",
        "quite",
        "rather",
        "real",
        "really",
        "relatively",
        "right",
        "seriously",
        "significantly",
        "simply",
        "slightly",
        "so",
        "specifically",
        "start",
        "strongly",
        "stuff",
        "surely",
        "things",
        "too",
        "totally",
        "truly",
        "try",
        "typically",
        "ultimately",
        "usually",
        "very",
        "virtually",
        "well",
        "whatever",
        "whenever",
        "wherever",
        "whoever",
        "widely"
      ]
    
    @State var wpm = 0
    @State var wf = 0
    @StateObject var vocalViewModel = VocalViewModel()
    @StateObject var gv = GlobalVariables()
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            if toggleRecordButton {
                HStack {
                    TimerView()
                }
                .padding(.bottom, 250)
                VStack {
                    //AUDIO GRAPH
                    HStack {
                        Spacer()
                        ForEach(barArr, id: \.self) { value in
                            BarView(barHeight: value)
                        }
                    }
                    
                }
                .padding(.top, 250)
            }
            
            VStack {
                HStack {
                    if !toggleRecordButton {
                        Text("**Home**")
                            .padding()
                            .padding(.top, 20)
                            .font(.largeTitle)
                    }
                    else {
                        Text("**Recording**")
                            .padding()
                            .padding(.top, 20)
                            .font(.largeTitle)
                    }

                    Spacer()
                }

                HStack {
                    Text("Your speech will be scored based on this criteria")
                        .padding(.leading)
                        .font(.title3)
                    Spacer()
                }
                .offset(x: toggleRecordButton ? offsetMove : 0, y: 0)

                VStack {
                    HStack {
                        Text(Image(systemName: "speedometer"))
                            .foregroundColor(Color.init(hex: "630000"))
                            .font(Font.system(size: 30))
                        Text("Speaking Pace")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(Color.init(hex: "EDEADC"))
                    .padding(5)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    .onTapGesture(count: 1){
                        criteriaTitle = "Speaking Pace"
                        toggleCriteriaView.toggle()
                    }
                    .offset(x: toggleRecordButton ? offsetMove : 0, y: 0)

                    HStack {
                        Text(Image(systemName: "w.circle"))
                            .foregroundColor(Color.init(hex: "630000"))
                            .font(Font.system(size: 30))
                        Text("Word Fillers")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(Color.init(hex: "EDEADC"))
                    .padding(5)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    .onTapGesture(count: 1){
                        criteriaTitle = "Word Fillers"
                        toggleCriteriaView.toggle()
                    }
                    .offset(x: toggleRecordButton ? offsetMove : 0, y: 0)
                    
                    HStack {
                        Text(Image(systemName: "waveform.circle"))
                            .foregroundColor(Color.init(hex: "630000"))
                            .font(Font.system(size: 30))
                        Text("Vocal Tone")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(Color.init(hex: "EDEADC"))
                    .padding(5)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    .onTapGesture(count: 1){
                        criteriaTitle = "Vocal Tone"
                        toggleCriteriaView.toggle()
                    }
                    .offset(x: toggleRecordButton ? offsetMove : 0, y: 0)

                }
                Spacer().ignoresSafeArea()
                Text("Tap record button to start practicing your speech")
                    .padding(20)
                    .font(.title3)
                    .foregroundColor(Color.init(hex: "7F7F7F"))
                    .multilineTextAlignment(.center)
                    .offset(x: toggleRecordButton ? offsetMove : 0, y: 0)
                HStack {
                    Spacer()
                    Button(action: {
                        if sm.audioEngine.isRunning {
                            sm.recRequest?.endAudio()
                            sm.audioEngine.stop()
                            sm.recTask?.cancel()
                            withAnimation(.easeInOut(duration: 0.3)){
                                toggleRecordButton.toggle()
                                gv.toggleShowResult.toggle()

                            }
                        } else {
                            print("Start Recording")
                            sm.startRecording()
                            withAnimation(.easeInOut(duration: 0.3)){
                                toggleRecordButton.toggle()
                            }
                        }
                        
                    }, label: {
                        Text(Image(systemName: "mic"))
                            .padding(20)
                            .foregroundColor(Color.init(hex: "630000"))
                            .opacity(0)
                            .background(RoundedRectangle(cornerRadius: toggleRecordButton ? 5 : 75).frame(width: toggleRecordButton ? 35 : nil, height: toggleRecordButton ? 35 : nil, alignment: .center).animation(.easeInOut))
                            .foregroundColor(Color.init(hex: "630000"))
                            .font(.system(size: 25))
                            .overlay(Circle().stroke(.white, lineWidth: 6))
                    })
                    Spacer()
                }
                .padding(.top, 10)
                .background(Rectangle().ignoresSafeArea())
                .foregroundColor(Color.init(hex: "D8B7A3"))

            }
            .onAppear {
                SFSpeechRecognizer.requestAuthorization {
                    (authStatus) in
                    switch authStatus {
                    case .authorized:
                        print("authorized")
                    case .denied:
                        print("Speech recognition authorization denied")
                    case .restricted:
                        print("Not available on this device")
                    case .notDetermined:
                        print("Not determined")
                    }
                }
                
            }
            
            if gv.toggleShowResult {
                ResultModalView(speakingPace: wpm, wordFillers: wf)
                    .onAppear {
//                        textArr = textString.split(separator: " ").map({String($0)})
//                        calculateWordsPerMinute()
//                        wordFillersDetection()
                    }
            }
            
            HalfASheet(isPresented: $toggleCriteriaView) {
                CriteriaModalView(title: $criteriaTitle)
            }
            .height(.proportional(0.4))
            .backgroundColor(.white)
            .closeButtonColor(.white)
            .ignoresSafeArea()
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
