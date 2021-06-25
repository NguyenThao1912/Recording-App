//
//  MicManager.swift
//  RecordingApp
//
//  Created by Nguyen Huu Thao on 6/24/21.
//

import Foundation
import AVFoundation
protocol AudioDelegate {
    func updateUI(minutes:Int,second:Int,milisecons:Int)
}
class MicrophoneMonitor: ObservableObject {
    
    // 1
    private var audioRecorder   : AVAudioRecorder!
    private var timer           : Timer?
    private var controller      : AudioDelegate?
    private var count           : Int
    private var second          : Int
    // 2
    //@Published public var soundSamples: [Float]
    //private var currentSample   : Int
    //private let numberOfSamples : Int
    init(delegate : AVAudioRecorderDelegate , controller:AudioDelegate) {
        self.count = 0
        self.second = 0
        self.controller = controller
        //self.numberOfSamples = numberOfSamples // In production check this is > 0.
        //self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        //self.currentSample = 0
        // 3 ASK for micro permission
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("You must allow audio recording for this app to work")
                }
            }
        }
        
        // 4 create URL and Setting for audio
        let url = Constants.getDocumentPath().appendingPathComponent("default.m4a")
        let recorderSettings: [String:Any] = [
            AVFormatIDKey               : kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey    : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey         : 32000,
            AVNumberOfChannelsKey       : 2 ,
            AVSampleRateKey             : 44100.2
        ]
        
        // 5 initialize audio recorder
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            audioRecorder.delegate = delegate
            audioRecorder.prepareToRecord()
            
        } catch {
            fatalError(error.localizedDescription)
        }
    
    }
    
    // 6
    func startRecording() {
        //audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            // 7
            self.increaseTime()
        })
    }
    func getURL() -> URL {
        return audioRecorder.url
    }
    func pause()  {
        audioRecorder.pause()
        timer?.invalidate()
    }
    func stop() {
        count  = 0
        second = 0
        timer?.invalidate()
        audioRecorder.stop()
    }
    func increaseTime()  {
        // 1. increase time count
        count += 1
        
        // 1.1 if count pass 100 increase second set count equal 0
        if count > 100{
            count = 0
            second += 1
        }
        let minutes  = second / 60
        let seconds  = second % 60
        self.controller?.updateUI(minutes: minutes, second: seconds, milisecons: count)
    }
    
}


