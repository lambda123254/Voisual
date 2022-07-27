//
//  SoundManager.swift
//  NanoChallenge2
//
//  Created by Reza Mac on 26/07/22.
//

import Foundation
import Speech
import AVKit
import Accelerate
import SoundAnalysis
import SwiftUI

protocol SoundManagerProtocol {
    func barOutput(arr: [Float])
}

class SoundManager {
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recRequest: SFSpeechAudioBufferRecognitionRequest?
    var recTask: SFSpeechRecognitionTask?
    var audioEngine = AVAudioEngine()
    let LEVEL_LOWPASS_TRIG:Float32 = 0.5
    var textString = ""

    var soundClassifier = VocalTone.self
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    var averagePowerForChannel0: Float = 0
    var averagePowerForChannel1: Float = 0
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    var resultObserver = ResultsObserver()
    
    var barValue: Float = 0.0
    var barArr: [Float] = []
    var delegate: SoundManagerProtocol?
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
                self.textString = (result?.bestTranscription.formattedString)!
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                print("error speech failed")
                print(error)
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recTask = nil
            }
        })
        //AI Detection
        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        analyzer = SNAudioStreamAnalyzer(format: inputFormat)
        //======================

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
            self.audioMetering(buffer: buffer)
            self.barValue = 550 + self.averagePowerForChannel0
            if self.barValue < 90 {
                self.barValue = 10
            }
            else {
                self.barValue /= 4
            }

            if self.barArr.count > barCountMax{
                self.barArr.removeFirst()
            }
            else {
                self.barArr.append(self.barValue)
            }
//            print(self.barArr)
            self.delegate?.barOutput(arr: self.barArr)
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

class ResultsObserver: NSObject, SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
            let classificationFlat = result.classifications.first else { return }

        let classificationOther = result.classifications[1]

        let confidenceFlat = classificationFlat.confidence * 100.0
        let confidenceOther = classificationOther.confidence * 100.0
        if confidenceFlat > 80 {

        }
        if confidenceOther > 80 {

        }

    }
}

struct TestSoundManager: View {
    @Binding var number: [Float]
    var sm = SoundManager()
    var body: some View {
        Button("") {
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                number.append(Float(Int.random(in: 20...100)))

            }
        }
    }
    func calculate() {
        number.append(0)
    }
}
