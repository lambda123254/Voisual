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

class GlobalVariables: ObservableObject {
    @Published var number: Int = 0
    @Published var toggleShowResult = false
}

struct BarView: View {
    @State var barHeight: Float
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.init(hex: "630000"))
            .frame(width: 3, height: CGFloat(barHeight), alignment: .center)
    }

}

struct ConfettiView: View {
    @State var animate = false
    @State var xSpeed = Double.random(in: 0.7...2)
    @State var zSpeed = Double.random(in: 1...2)
    @State var anchor = CGFloat.random(in: 0...1).rounded()
    
    var body: some View {
        Rectangle()
            .frame(width: 20, height: 20, alignment: .center)
            .onAppear(perform: { animate = true })
            .rotation3DEffect(.degrees(animate ? 360:0), axis: (x: 1, y: 0, z: 0))
            .animation(Animation.linear(duration: xSpeed).repeatForever(autoreverses: false), value: animate)
            .rotation3DEffect(.degrees(animate ? 360:0), axis: (x: 0, y: 0, z: 1), anchor: UnitPoint(x: anchor, y: anchor))
            .animation(Animation.linear(duration: zSpeed).repeatForever(autoreverses: false), value: animate)
    }
}

struct ContentView: View {
    @State var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State var recRequest: SFSpeechAudioBufferRecognitionRequest?
    @State var recTask: SFSpeechRecognitionTask?
    @State var audioEngine = AVAudioEngine()
    @State var textString = ""
    @State var textArr: [String] = []
    @State var averagePowerForChannel0: Float = 0
    @State var averagePowerForChannel1: Float = 0
    @State var barValue: Float = 0.0
    @State var barArr: [Float] = []
    let LEVEL_LOWPASS_TRIG:Float32 = 0.5
    
    @State var soundClassifier = VocalTone.self
    @State var inputFormat: AVAudioFormat!
    @State var analyzer: SNAudioStreamAnalyzer!
    @State var resultObserver = ResultsObserver()
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    @State var toggleRecordButton = false
    @State var toggleShowResult = false
    @State var toggleCriteriaView = false
    @State var criteriaTitle = ""
    @State var offsetMove: CGFloat = -400
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var second = 0
    @State var minute = 0
    @State var minuteRound = "0"
    @State var secondRound = "0"

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
    @StateObject var gv = GlobalVariables()
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            if toggleRecordButton {
                HStack {
                    Text("\(minuteRound)\(minute):\(secondRound)\(second)")
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .background(Circle().fill(Color(hex: "630000")).frame(width: 200, height: 200, alignment:.center))
                        .onReceive(timer) { input in
                            gv.number += 1
                            if second == 0 {
                                secondRound = "0"
                            }
                            
                            if second > 8 {
                                secondRound = ""
                            }
                            
                            if second == 59 {
                                second = 0
                                minute += 1
                            }
                            else {
                                second += 1

                            }
                        }
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
                        if audioEngine.isRunning {
                            recRequest?.endAudio()
                            audioEngine.stop()
                            recTask?.cancel()
                            withAnimation(.easeInOut(duration: 0.3)){
                                toggleRecordButton.toggle()
                                gv.toggleShowResult.toggle()

                            }
                        } else {
                            print("Start Recording")
                            startRecording()
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
                
                //AI Detection
                inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
                analyzer = SNAudioStreamAnalyzer(format: inputFormat)
                //======================
                
            }
            
            if gv.toggleShowResult {
                ResultModalView(speakingPace: wpm, wordFillers: wf)
                    .onAppear {
                        textArr = textString.split(separator: " ").map({String($0)})
                        calculateWordsPerMinute()
                        wordFillersDetection()
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
    
    func calculateWordsPerMinute() {
        wpm = textArr.count * 60 / second
    }
    
    func wordFillersDetection() {
        for i in 0 ..< textArr.count {
            for j in 0 ..< wfArr.count {
                if textArr[i] == wfArr[j] {
                    wf += 1
                }
            }
        }
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties werent set because of an error.")
        }
        
        let inputNode = audioEngine.inputNode
        recRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recRequest = recRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recRequest.shouldReportPartialResults = true

        recTask = speechRecognizer?.recognitionTask(with: recRequest, resultHandler: { (result, error) in

            var isFinal = false
            if result != nil {
                textString = (result?.bestTranscription.formattedString)!
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                print("error speech failed")
                print(error)
                audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                recTask = nil
            }
        })
        
        
        //AI Detection
        do {
            let request = try SNClassifySoundRequest(mlModel: MLModel(contentsOf: soundClassifier.urlOfModelInThisBundle))
            try analyzer.add(request, withObserver: resultObserver)
        } catch {
            print("Unable to prepare request: \(error.localizedDescription)")
            return
        }
        // ==========================
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        let barCountMax = 34
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            audioMetering(buffer: buffer)
            barValue = 550 + averagePowerForChannel0
            if barValue < 90 {
                barValue = 10
            }
            else {
                barValue /= 4
            }

            if barArr.count > barCountMax{
                barArr.removeFirst()
            }
            else {
                barArr.append(barValue)
            }
            recRequest.append(buffer)
            
            self.analysisQueue.async {
                self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
            
        }

        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldnt start because of an error.")
        }
        
    }
    private func audioMetering(buffer:AVAudioPCMBuffer) {
        buffer.frameLength = 1024
        let inNumberFrames:UInt = UInt(buffer.frameLength)
        if buffer.format.channelCount > 0 {
            let samples = (buffer.floatChannelData![0])
            var avgValue:Float32 = 0
            vDSP_meamgv(samples,1 , &avgValue, inNumberFrames)
            var v:Float = -100
            if avgValue != 0 {
                v = 200.0 * log10f(avgValue)
            }
            averagePowerForChannel0 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel0)
            self.averagePowerForChannel1 = self.averagePowerForChannel0
        }
        
        if buffer.format.channelCount > 1 {
            let samples = buffer.floatChannelData![1]
            var avgValue:Float32 = 0
            vDSP_meamgv(samples, 1, &avgValue, inNumberFrames)
            var v:Float = -100
            if avgValue != 0 {
                v = 20.0 * log10f(avgValue)
            }
            self.averagePowerForChannel1 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel1)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ResultsObserver: NSObject, SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }
        
        let confidence = classification.confidence * 100.0
        if confidence > 60 {
        
        }
        
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
