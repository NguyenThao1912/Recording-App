//
//  PlayRecordController.swift
//  RecordingApp
//
//  Created by Nguyen Huu Thao on 6/23/21.
//

import UIKit
import AVFoundation
class PlayRecordController: BaseViewController {
   
    

    @IBOutlet weak var playBack3s   : UIButton!
    @IBOutlet weak var playNext3s   : UIButton!
    @IBOutlet weak var playRecord   : UIButton!
    @IBOutlet weak var ProgressBar  : UIProgressView!
    @IBOutlet weak var recordName   : UILabel!
    var timer              : Timer?
    var currentRecord      : Record?
    var soundPlayer        : AVAudioPlayer!
    var count              : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        setupUI()
        
        // Do any additional setup after loading the view.
      
    }

    override func setupUI() {
        guard let record = currentRecord else {
            return
        }
        ProgressBar.progress = 0.0
        preparePlayer(filename : record.fileName)
        recordName.text = record.fileName
    }
    
    @IBAction func DidTapPlayButton(_ sender: UIButton) {
        ProgressBar.progress = 0.0
        guard let sound = soundPlayer else {
            print("error")
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            guard let record = self.currentRecord else {
                return
            }
            print("\(self.count) - \(record.duration)")
            if self.count < record.duration{
                self.count += 1
                DispatchQueue.main.async {
                    self.ProgressBar.progress = Float(self.count)/Float(record.duration)
                }
            }
            else{
                self.count = 0
                self.timer?.invalidate()
                self.timer = nil
            }
        })
        
        sound.play()
        
    }
 
    @IBAction func DidTapPlayBackButton(_ sender: UIButton) {
        print("Tap Playback button")
        guard let sound = soundPlayer else {
            return
        }
        guard let record = self.currentRecord else {
            return
        }
        if self.count - 3 < record.duration {
            self.count -= 3
            sound.play(atTime: Double(Double(self.count) - 3.0))
            DispatchQueue.main.async {
                self.ProgressBar.progress = Float(self.count)/Float(record.duration)
            }
        }else{
            sound.stop()
        }
        
    }
    
    @IBAction func DidTapPlayNextButton(_ sender: UIButton) {
        guard let sound = soundPlayer else {
            return
        }
        guard let record = self.currentRecord else {
            return
        }
        if self.count + 3 > record.duration {
            self.count += 3
            sound.play(atTime: Double(Double(self.count) + 3.0))
            DispatchQueue.main.async {
                self.ProgressBar.progress = Float(self.count)/Float(record.duration)
            }
        }else{
            sound.play(atTime: 0.0)
        }
    }
}

 

//MARK: - AudioPlayer extension

extension PlayRecordController :AVAudioPlayerDelegate{
    func preparePlayer(filename : String) {
        let audioFilePath = Constants.getDocumentPath().appendingPathComponent("\(filename).m4a")
        print(audioFilePath)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilePath)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print(error)
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finish Playing")
    }
}
